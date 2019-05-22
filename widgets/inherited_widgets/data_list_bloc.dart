import 'dart:async';
import 'data/functions.dart';
import 'data/mini_classes.dart';
import 'data/profile.dart';
import 'package:flutter_web/material.dart';
import 'package:rxdart/rxdart.dart';
import 'blocs/main_bloc.dart';


class DataListBloc{

  String title;
  MainBloc mainModel;
  ProfileType profileType;

  GlobalKey<AnimatedListState> _listKey;
  set listkey(GlobalKey<AnimatedListState> key) => _listKey;


  BehaviorSubject<List<Profile>> _outgoingProfilesListObservable = new BehaviorSubject<List<Profile>>();
  Stream<List<Profile>> get outgoingProfilesStream => _outgoingProfilesListObservable.stream;


  BehaviorSubject<List<Profile>> _incomingProfilesStreamController = new BehaviorSubject<List<Profile>>();

  BehaviorSubject<String> _queryStreamController = new BehaviorSubject<String>();

  set sendQuery(String query) => _queryStreamController.sink.add(query);
  String get _query => _queryStreamController.value;

  BehaviorSubject<ListSortingOptions> _sortTypeObservable = new BehaviorSubject<ListSortingOptions>();

  ListSortingOptions get _sortType => _sortTypeObservable.value;
  Stream<ListSortingOptions> get sortTypeStream => _sortTypeObservable.stream;
  void setSortType(ListSortingOptions type) { if (_sortTypeObservable.value != type) { _sortTypeObservable.add(type); }}

    DataListBloc( this.profileType, this.mainModel ){
        setSortType(ListSortingOptions.mostRecent);
        sendQuery = '';
        title = Functions.getProfileTypeString(profileType)+'s';

        _incomingProfilesStreamController.add( mainModel.profiles(profileType) );
        _incomingProfilesStreamController.addStream( mainModel.getProfilesStream(profileType));
        _incomingProfilesStreamController.stream.listen(_processIncomingProfiles);

        _queryStreamController.stream.listen( (query) { _processIncomingProfiles( _incomingProfilesStreamController.value ) ;} ); 
        _sortTypeObservable.listen((type) { _processIncomingProfiles( _incomingProfilesStreamController.value ); });
    }

    void initialise( GlobalKey<AnimatedListState> listKey, Widget Function(Profile, BuildContext, Animation<double>, int) buildFunction){
        _listKey = listKey;
        _processIncomingProfiles( _incomingProfilesStreamController.value );
    } 

    void _processIncomingProfiles(List<Profile> profiles){ 
        if (profiles != null){
        List<Profile> incomingList = _removeDuplicates(profiles); 
        List<Profile> sortedList = _reorganiseList(incomingList);
        List<Profile> filterdList = _getFiltedItems(sortedList);

        _outgoingProfilesListObservable.add(filterdList);

        }
    }

    /// remove Duplicates
    List<Profile> _removeDuplicates(List<Profile> profiles){
        List<Profile> list = new List<Profile>.from(profiles);
        list.removeWhere((p){
            int findCount = 0;
        
            for (var i = 0; i < list.length; i++) {
                if( p.objectId == list[i].objectId ){
                    findCount++;
                }
            } 
            return findCount > 1 ;
        });
        return list;
    }


    /// Filtering out profiles to be removed
    List<Profile> _getFiltedItems(List<Profile> profiles){
        List<Profile> filterd = new List<Profile>.from(profiles);

        if ( profiles != null && profiles.length > 0){
            if(_query.isNotEmpty || _query != '') {
            filterd.removeWhere((profile){

                String title = profileType ==ProfileType.recipe ?
                profile.getProfileTitleValue().toLowerCase() + ' ' + profile.getProfileProfile(ProfileType.equipment).getProfileTitleValue().toLowerCase():
                profile.getProfileTitleValue().toLowerCase();

                return !title.contains(_query.toLowerCase()); 
            });
            }
        }
        return filterd;
    }
     

  List<Profile> _reorganiseList(List<Profile> list){

    List<Profile> sortedList = new List.from(list);

    switch (_sortType) {
      case ListSortingOptions.alphabeticallyAcending: 
        sortedList.sort((a, b) =>
         a.getProfileTitleValue().toLowerCase().compareTo(b.getProfileTitleValue().toLowerCase()));
        break;

      case ListSortingOptions.alphabeticallyDecending: 
        sortedList.sort((a, b) =>
         b.getProfileTitleValue().toLowerCase().compareTo(a.getProfileTitleValue().toLowerCase()));
        break;

      case ListSortingOptions.mostRecent:
        sortedList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;

      case ListSortingOptions.oldest: 
        sortedList.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;

      case ListSortingOptions.valueAcending: 
        sortedList.sort((a, b) => a.getTotalScore().compareTo(b.getTotalScore()));
        break;

      case ListSortingOptions.valueDecending: 
        sortedList.sort((a, b) => b.getTotalScore().compareTo(a.getTotalScore()));
        break;
      default: Error();
    }
    return sortedList;
  }


  int findAddingProfileIndex(List<Profile> _profiles, Profile _addingProfile){
    int index = 0;
    if ( _addingProfile != null)
    { index = _profiles.indexWhere((profiley) => _addingProfile.objectId == profiley.objectId ? true : false); }
    return index;
  }

  void deleteProfile(Profile profile){
    mainModel.delete(profile);
  }

  void dispose() { 
      _incomingProfilesStreamController.close();
      _sortTypeObservable.close();
      _queryStreamController.close();
      _outgoingProfilesListObservable.close();
  }

}




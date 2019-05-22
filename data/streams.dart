import 'dart:async';
import 'profile.dart';
import 'functions.dart';
import 'database_functions.dart';
import 'mini_classes.dart';
import 'error_reporting.dart';

class ProfileFeedBloc{

  ///Other Variables
  final String _databaseId;
  String get databaseId => _databaseId;
  bool _initialised = false;

  BehaviorSubject<UserProfile> _userDetails = BehaviorSubject<UserProfile>();
  BehaviorSubject<List<Profile>> _outgoingController = BehaviorSubject<List<Profile>>();
  BehaviorSubject<QuerySnapshot> _incomingController = BehaviorSubject<QuerySnapshot>();

  void removeProfile(Profile profile){
    _profiles.removeWhere((p) => p.objectId == profile.objectId);
    _outgoingController.add(_profiles);
  }

  Stream<List<Profile>> get profilesStream => _outgoingController.stream;
  List<Profile> get profiles => _outgoingController.value;
    
  List<Profile> _profiles;
  int get profilesCount => _profiles.length;

  /// Init of the class
  ProfileFeedBloc(this._databaseId){
    _userDetails.listen(_initialise );
  }

  void addUserProfileStream(Stream<UserProfile> userStream){
      if (!_initialised){
        _userDetails.addStream(userStream);
      }
  } 

  /// Deinit
  void deinit(){
    _initialised = false;
    _outgoingController = new BehaviorSubject<List<Profile>>();
    _incomingController = new BehaviorSubject<QuerySnapshot>();
    _userDetails = new BehaviorSubject<UserProfile>();
  }

  void dispose() { 
    _outgoingController.close();
    _incomingController.close();
    _userDetails.close();
  }

  void add(Profile profileIn){
  }

  void convertQuerytoStream(List<Profile> profiles){
     _profiles = new List<Profile>.from(profiles);
        Iterable<Profile> _reversedList = _profiles.reversed;
              List<Profile> _list = new List<Profile>();
                _reversedList.forEach((x){_list.add(x);});
        _outgoingController.add(_list);
  }

  Future _initialise(UserProfile user)async{
    if ( !_initialised ) {
      _initialised = true;
      _incomingController.stream.listen((p){
            Dbf.convertStreamToListOfProfiles(p, _databaseId)
              .then(convertQuerytoStream).catchError(Sentry.report)
      ;})
      .onDone(() => print('${_userDetails.value.userName ?? 'user'}  ${this.databaseId} in "Done" Statement')); 
      
      _incomingController.addStream( Dbf.getStreamFromFireStoreOneArg( _databaseId, DatabaseIds.user, user.id) , cancelOnError: true)
      .whenComplete(() => print(user.userName + ' ' + this.databaseId + ' stream Added (Complete)'))
      .then((v){ print('${user.userName}  ${this.databaseId} stream in "then" statement with value $v') ;})
      .catchError(Sentry.report);
    }
  }
}  


class SocialFeedBloc{

  final String _databaseId;
  String get databaseId => _databaseId;
  bool _initilised = false;
  Stream<UserProfile> _currentUserStream;
  UserProfile _currentUser;
  Function(String) isUserFollowing;
  List<Profile> _currentFeedData;

  Stream<List<FeedProfileData>> get profiles => _outgoingController.stream;

  var _outgoingController = BehaviorSubject<List<FeedProfileData>>();
  var _incomingController = StreamController<QuerySnapshot>.broadcast();


  /// Init of the class
  SocialFeedBloc(this._databaseId, this._currentUserStream, {this.isUserFollowing} )
  {_currentUserStream.listen((user){
    assert(user != null , 'user is null');
    _currentUser = user;
    _userStreamListenerFunction();
   });
  }


  void deinit(){
    _initilised = false;
  }

  
  void dispose() { 
    _outgoingController.close();
    _incomingController.close();
  }


  Future getProfiles()async{
  
    if(!_initilised){

      _initilised = true;
    
      _incomingController.addStream( 
                          Dbf.getStreamFromFireStoreTwoArgs(
                            DatabaseIds.recipe,
                             DatabaseIds.public, true,
                             DatabaseIds.isDeleted, false));
        
      _incomingController.stream.listen(_profileStreamListenerFunction);
    }
  }


  void _userStreamListenerFunction(){
    
    if(_currentFeedData != null){
    handleProfileList(_currentFeedData);}
  }


  void _profileStreamListenerFunction(QuerySnapshot p){
      Dbf.convertStreamToListOfProfiles(p, DatabaseIds.recipe)
        .then((profilesOut){ handleProfileList(profilesOut);
      }
    ); 
  }


  void handleProfileList(List<Profile> profilesin){
    
      _currentFeedData = profilesin;
      if ( _currentUser != null ) {
      var profiles = _returnListOfProfilesWithoutUserProfiles(profilesin);

     if(_databaseId == DatabaseIds.community){

          convertProfilesToListOfFeedProfiles(profiles).then(

          (feedProfiles){_outgoingController.add(feedProfiles);
          
        });

      /// For following only
      }else{      
        
          /// remove none followers
          profiles.removeWhere((profile) 

          {if (profile.userId != null){

             bool result;

              if (_currentUser.following != null) {

              List<String> followingList = _currentUser.following;

               result =  followingList.contains(profile.userId); 
              }    

              bool returnValue = !result;

              return returnValue;

          }});

          convertProfilesToListOfFeedProfiles(profiles)
          .then((List<FeedProfileData> feedListProfiles){        
              _outgoingController.add(feedListProfiles);}
          );
        }
    }
  }


  List<Profile> _returnListOfProfilesWithoutUserProfiles(List<Profile> profilesIn){

    var profiles = new List<Profile>.from(profilesIn);
              /// Remove Current User profiles
                profiles.removeWhere((profile) { 
                   
                if (profile.userId != null){

                  assert(_currentUser.id != null, 'user D is null');

                  String otherUserId = profile.userId ?? '';
                  String currentUserId = _currentUser.id ?? '';
                    
                    /// Remove the profile where the profile userId is eqaula to the currrent userId
                    if (otherUserId == currentUserId){ 
                      return true;}
                    else{ return false;}
    
              }});
    return profiles ?? NullThrownError();
  }


  Future<List<FeedProfileData>> convertProfilesToListOfFeedProfiles(List<Profile> stream) async {

    List<FeedProfileData> profiles = new List<FeedProfileData>();

    for(var doc in stream){  /// <<<<==== changed line
            FeedProfileData result = await Functions.createFeedProfileFromProfile(doc);
            profiles.add(result);
    }
    return profiles;
  }
}



class UserFeed {
   
  bool _initilised = false;
  Stream<UserProfile> get userStream{ assert(_outgoingController.stream != null, '_userDetails is null'); return _outgoingController.stream;}

  // CurrentUserDetailsStream currentUserDetailsStream = CurrentUserDetailsStream();
  UserDetails _userDetails;
  UserDetails get userDetails { assert(_userDetails != null, '_userDetails is null'); return _userDetails;}

  // CurrentUserProfileStream currentUserProfileStream;
  UserProfile _userProfile;
  UserProfile get userProfile { assert(_userProfile != null, '_userProfile is null'); return _userProfile;}
  
  BehaviorSubject<UserProfile> _outgoingController = BehaviorSubject<UserProfile>();
  BehaviorSubject<UserDetails> _outgoingUserDetailsController = BehaviorSubject<UserDetails>();


  UserFeed(){
    // currentUserProfileStream = CurrentUserProfileStream(
    //                           currentUserDetailsStream.userDetailsStreamcontroller.stream);

    ///Make user Profile streams from firebase :)
     Dbf.getCurrentUserStream();
  }

  void deinit(){
    _initilised = false;
    // dispose();
  }

  void dispose() { 
    _outgoingController.close();
    _outgoingUserDetailsController.close();
  }

  void refresh(){
    _initilised = false;
    getProfile();
  }

  Future getProfile()async{
  
   if(!_initilised){

     _initilised= true;

      _userDetails = await Dbf.getCurrentUserDetails()
                        .catchError((e){Sentry.report(e); throw(e);});

      _outgoingUserDetailsController.add(_userDetails);

    UserProfile userProfile = await Dbf.getUserProfileFromFireStoreWithDocRef(_userDetails.id)
    .catchError((e){Sentry.report(e); throw(e);});
        
        if ( userProfile != null ){
            _userDetails.userName = userProfile.userName; 
            _userDetails.photoUrl = userProfile.imageUrl;
            _userDetails.motto = userProfile.motto; 
            _userProfile = userProfile;
            _outgoingController.add(_userProfile);
            _outgoingUserDetailsController.add(_userDetails);
        }else{
          Future.delayed(Duration(seconds: 3));
          getProfile();
        }
      }
    }
  }


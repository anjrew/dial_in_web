    import 'package:dial_in_v1/widgets/cards/profile_card.dart';
    import 'package:dial_in_v1/widgets/popups.dart';
    import 'package:flutter/cupertino.dart';
    import 'package:flutter/material.dart';
    import 'package:dial_in_v1/data/profile.dart';
    import 'package:dial_in_v1/blocs/main_bloc.dart';
    import 'package:dial_in_v1/routes/routes.dart';
    import 'dart:async';

    /// Profile list
    class ProfileList extends StatelessWidget {

    final ProfileType _profileType;
    final bool onOverviewSceen;
    final Function(Profile) giveProfile;
    ProfileList(this._profileType, this.onOverviewSceen,{ this.giveProfile });

    void _dealWithProfileSelection(Profile profile, BuildContext context, String heroTag, ) async {
        if( onOverviewSceen ){
        var result = await Routes.openProfilePage(context, profile.objectId, profile.type, false, false, true, false, false, heroTag);
        if ( result is TimeoutException ) { PopUps.showAlert('Error', result.message, 'ok', () { Navigator.pop(context); Navigator.pop(context); } , context); }
        }
        else{ 
        giveProfile(profile);
        }
    }

    void _deleteProfile(Profile profile, BuildContext context, String index) {
        PopUps.yesOrNoDioLog(
            context,
            'Warning',
            'Are you sure you want to delete this profile?',
            (isYes) {
                if (isYes) {
                    MainBloc.of(context).overviewBloc.profileDataList(_profileType).deleteProfile(profile);
                    Navigator.pop(context);
                    Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Profile deleted"),
                    duration: Duration(seconds: 2),
                    ));
                } else {
                    Navigator.pop(context);
                }
            });
    }

        @override
        Widget build(BuildContext context) {
            Widget returnWidget;
            return
            StreamBuilder<List<Profile>>(
            stream: MainBloc.of(context).overviewBloc.profileDataList(_profileType).outgoingProfilesStream,
            builder: (BuildContext streamContext, AsyncSnapshot<List<Profile>> snapshot) {
            
            if ( snapshot.data == null || snapshot.data.length <= 0 ) { 

            returnWidget =  
            Column
            (mainAxisAlignment: MainAxisAlignment.center ,children: <Widget>[
                Container(child: Icon(Icons.no_sim),),
                Container(margin: EdgeInsets.all(20.0),child: Text('No Data',style: Theme.of(context).textTheme.display3,),) ,],);

        }else{
            
                ListView _list = new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) => ProfileCard(
                        index.toString()+'DataList'+this.hashCode.toString(),
                        snapshot.data[index], 
                        _dealWithProfileSelection,
                        _deleteProfile,
                        null,
                        isDeletable: true,
                    )
                );

                if (onOverviewSceen){
                    returnWidget =  Expanded(child:_list);
                }else{
                    returnWidget =  _list;
                }
            }
        assert(returnWidget != null, 'The return widget is null');
        return returnWidget;
        });
        }    
    }

import 'package:dial_in_v1/widgets/popups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/data/strings.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:dial_in_v1/data/images.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'dart:io';
import 'dart:async';

class UserInputDetails extends StatefulWidget { 
  final UserDetails _userDetails;
  UserInputDetails(this._userDetails);
  _UserInputDetailsState createState() => _UserInputDetailsState();}
class _UserInputDetailsState extends State<UserInputDetails> {

  final _formKey = GlobalKey<FormState>();

  _handleSubmitted() {

    final FormState form = _formKey.currentState;
    if (!form.validate()) {

    } else {
      form.save();
      PopUps.showCircularProgressIndicator(context);
      Dbf.updateUserProfile(widget._userDetails)
                  .catchError((error) => PopUps.showAlert('Warning', error.toString(), 'ok', () => Navigator.pop(context), context))
                  .timeout(Duration(seconds: 10), onTimeout: handleSubmissionTimeout) 
                  .then((_) { 
                      /// Pop Circular indicator
                      Navigator.pop(context);
                      MainBloc.of(context).refreshUser();
                      /// PopBack to drawer
                      Navigator.pop(context);
                    }
                  );       
    }
  }

  FutureOr<void>handleSubmissionTimeout()async{
    PopUps.showAlert(
      'This is taking way too long', 
      'We are trying to Save your data but it is taking too long. Maybe the internet connection is bad?', 
      'ok', 
      () { Navigator.pop(context); Navigator.pop(context); },
       context);
  }

  void _getImage()async{

    PopUps.showCircularProgressIndicator(context);

    var result = await PopUps.getimageFromCameraOrGallery(context);

    if ( result is String ){

      String url = await Dbf.upLoadFileReturnUrl( File( result ), [ DatabaseIds.user, widget._userDetails.id, 'images' ] );
            
            if ( widget._userDetails != null ){
            if ( url != widget._userDetails.photoUrl ){

            // Dbf.deleteFireBaseStorageItem( widget._userDetails.photoUrl );
              }
            }

            setState(() { widget._userDetails.photoUrl = url; }); 
            Navigator.pop(context);

    }else if(result is ResetImageRequest){
      widget._userDetails.photoUrl = null;
      Navigator.pop(context);

    }else{
     Navigator.pop(context);     
      }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return 
    Container(color: Colors.white, child:
    
    Form(
      key: _formKey,
      child: ListView( 
        children: <Widget>[

          Padding(padding: EdgeInsets.all(20),),


          Container(
            alignment: Alignment(0, 0),
            child: InkWell(
              onTap: _getImage,
              child: UserDetailsCachedProfileImage( widget._userDetails ?? Images.userFirebase , 180.0))),
        

          Container( 
            margin:EdgeInsets.all(20),
            child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[

                Container(
                  margin:EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center, 
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: <Widget>[
                    
                    
                ///Username
                TextFormField(
                  decoration: InputDecoration(labelText: StringLabels.userName),
                  initialValue: widget._userDetails.userName ?? '',
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Enter some text';
                    }
                  },
                  onSaved: (value){ widget._userDetails.userName = value;}
                ),
    
                ///Motto
                  TextFormField(
                  initialValue: widget._userDetails.motto ?? '',
                  decoration: InputDecoration(
                                labelText: StringLabels.motto,
                                hasFloatingPlaceholder: true,
                                            ),
                  obscureText: false,
                  onSaved: (String value){if (value != null || value != ''){ widget._userDetails.motto = value;}}
    
                ),
    
                /// Email
                TextFormField(
                  decoration: InputDecoration(labelText: StringLabels.email),
                  initialValue: widget._userDetails.email ?? '',
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid email';
                    }
                  },
                  onSaved: (value){ widget._userDetails.email = value;}
                ),
    
                ///Password
                TextFormField(
                  decoration: InputDecoration(
                                labelText: StringLabels.password,
                                hasFloatingPlaceholder: true,
                                helperText: 'If applicable'
                                            ),
                  obscureText: true,
                  onSaved: (String value){if (value != null || value != '') widget._userDetails.password = value;}
                ),
    
                Padding(padding: EdgeInsets.all(5),),
    
                /// Submit button
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                              color: const Color.fromARGB(250, 209, 140, 92),
                              shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                              onPressed: () { _handleSubmitted(); },
                              child: Text('Save changes',  style: Theme.of(context).textTheme.display2.apply(color: Theme.of(context).brightness == Brightness.light ? Colors.white :Colors.black),)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ), 
          )
        ]
      )
    )
    );
  }
}




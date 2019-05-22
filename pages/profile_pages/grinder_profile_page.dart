import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/widgets/profile_page_widgets.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/pages/profile_pages/profile_page_model.dart';


class GrinderPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) =>

  ScopedModelDescendant(builder: (BuildContext context,_, ProfilePageModel model) =>

     StreamBuilder<Profile>(
            stream: model.profileStream,
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot){

              if( !snapshot.hasData ){ return CenterdCircularProgressIndicator(); }

    return new Column(children: <Widget>[

      /// Details
      GrinderDetailsCard(),

      /// Notes
      NotesCard(snapshot.data.getItem( DatabaseIds.notes))
    ]);
  
    }
     )
  );
}

class GrinderDetailsCard extends StatelessWidget {
  final double _padding = 5.0;
  final double _margin = 5.0;
  final double _textFieldWidth = 140.0;

  @override
  Widget build(BuildContext context) {
    return 
    
  
  ScopedModelDescendant(builder: (BuildContext context,_, ProfilePageModel model) =>

     StreamBuilder<Profile>(
            stream: model.profileStream,
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot){
                if (!snapshot.hasData){ return Center(child: CircularProgressIndicator(),);}

              return 
                Card(
                    child: Container(
                  padding: EdgeInsets.all(_padding),
                  margin: EdgeInsets.all(_margin),
                  child: Column(
                    children: <Widget>[
                      ///Row 1
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          
                          /// Name
                          TextFieldItemWithInitalValue( snapshot.data.getItem( DatabaseIds.grinderId ), width: _textFieldWidth),

                          /// Burrs
                          PickerTextField( snapshot.data.getItem( DatabaseIds.burrs ), _textFieldWidth),

                        ],
                      ),


                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          /// Make
                          TextFieldItemWithInitalValue( snapshot.data.getItem( DatabaseIds.grinderMake ), width: _textFieldWidth),

                          /// Model
                          TextFieldItemWithInitalValue( snapshot.data.getItem( DatabaseIds.grinderModel ),width:  _textFieldWidth),

                        ],
                      ),
                    ],
                  ),
                )
                );
              }
                  )
                  );
              }
}

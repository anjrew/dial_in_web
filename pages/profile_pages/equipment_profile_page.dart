import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/widgets/profile_page_widgets.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/pages/profile_pages/profile_page_model.dart';


class EquipmentPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return 
    
     ScopedModelDescendant(builder: (BuildContext context,_, ProfilePageModel model) =>

     StreamBuilder<Profile>(
            stream: model.profileStream,
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot){
              
              if (!snapshot.hasData){ return Center(child: CircularProgressIndicator(),);}

              return
              
               Column(children: <Widget>[

          /// Details
          EquipmentDetailsCard(),

          /// Notes
          NotesCard(snapshot.data.getItem( DatabaseIds.method)),

        ]);
          }
        )

     );
  }
}

class EquipmentDetailsCard extends StatelessWidget {
  final double _padding = 5.0;
  final double _margin = 5.0;
  final double _textFieldWidth = 140.0;

  @override
  Widget build(BuildContext context) {

    return
    
    ScopedModelDescendant(builder: (BuildContext context,_, ProfilePageModel model) =>

        StreamBuilder<Profile>(
                stream: model.profileStream,
                builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {

        if (!snapshot.hasData){ return CenterdCircularProgressIndicator();}
        return

        Card(
            child: Container(
            padding: EdgeInsets.all(_padding),
            margin: EdgeInsets.all(_margin),
            child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 2.0, 
                children: <Widget>[
                ///Row 1

                    /// Name
                    Row(
                     children:[ 
                        TextFieldItemWithInitalValue(
                            snapshot.data.getItem(DatabaseIds.equipmentId),width:  _textFieldWidth,),
                        ]
                    ), 

                    /// Type
                    Row(children: <Widget>[
                        PickerTextField(
                        snapshot.data.getItem(DatabaseIds.type), _textFieldWidth,), 
                    ],),


                    /// Make
                    Row(children: <Widget>[
                        TextFieldItemWithInitalValue(
                        snapshot.data.getItem(DatabaseIds.equipmentMake),width: _textFieldWidth),
                    ],),

                    /// Model
                    Row(children: <Widget>[
                        TextFieldItemWithInitalValue(
                        snapshot.data.getItem(DatabaseIds.equipmentModel),width: _textFieldWidth),
                    ],),

                    /// Liquid retension ratio
                    Row(children: <Widget>[
                        TextFieldItemWithInitalValue(
                        snapshot.data.getItem(DatabaseIds.lrr),
                        width: _textFieldWidth,
                        textInputFormatters: [
                            BlacklistingTextInputFormatter(RegExp(' '), replacementString: ''),
                            BlacklistingTextInputFormatter(RegExp(','), replacementString: '.'),
                            WhitelistingTextInputFormatter(RegExp('[0-9,.]')),
                        ],),
                    ],),
                ],
                ),
            ));}
            )
        );
    }
}

 


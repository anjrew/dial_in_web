import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/widgets/profile_page_widgets.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/pages/profile_pages/profile_page_model.dart';

class BaristaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
     ScopedModelDescendant(
        builder: (BuildContext context, _, ProfilePageModel model) =>

        StreamBuilder<Profile>(
            stream: model.profileStream,
            builder:
                (BuildContext context, AsyncSnapshot<Profile> snapshot) {

            if ( !snapshot.hasData ){ return CenterdCircularProgressIndicator(); }

            return
              new Column(children: <Widget>[
                /// Details
                BaristaDetailsCard(),

                /// Notes
                NotesCard(snapshot.data.getItem(DatabaseIds.notes))
              ]);
            }));
  }
}

class BaristaDetailsCard extends StatelessWidget {
  final double _padding = 5.0;
  final double _margin = 5.0;
  final double _textFieldWidth = 150.0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProfilePageModel>(
        rebuildOnChange: true,
        builder: (BuildContext context, _, ProfilePageModel model) {
          return
          StreamBuilder<Profile>(
              stream: model.profileStream,
              builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {

                if (!snapshot.hasData){ return Center(child: CircularProgressIndicator(),);}

                return
                Card(
                    child: Container(
                        padding: EdgeInsets.all(_padding),
                        margin: EdgeInsets.all(_margin),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment:  CrossAxisAlignment.center,
                          children: <Widget>[

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                /// Name
                                TextFieldItemWithInitalValue(
                                  snapshot.data.getItem(DatabaseIds.name),
                                  width: _textFieldWidth,
                                ),

                                /// Level
                                TextFieldItemWithInitalValue(
                                    snapshot.data.getItem(DatabaseIds.level),
                                    width: _textFieldWidth),
                              ],
                            ),
                          ],
                        )));
              });
        });
  }
}

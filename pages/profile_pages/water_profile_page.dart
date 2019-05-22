import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/data/strings.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/widgets/profile_page_widgets.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/pages/profile_pages/profile_page_model.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:dial_in_v1/data/mini_classes.dart';

class WaterPage extends StatelessWidget {
  /// UI Build
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, _, ProfilePageModel model) =>
            StreamBuilder<Profile>(
                stream: model.profileStream,
                builder:
                    (BuildContext context, AsyncSnapshot<Profile> profile) {
                  if (!profile.hasData) {
                    return CenterdCircularProgressIndicator();
                  }

                  return Column(children: <Widget>[
                    /// Name
                    Card(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            height: 100.0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFieldItemWithInitalValue(
                                      profile.data.getItem(DatabaseIds.waterID),
                                      width: 300)
                                ]))),

                    /// Details
                    WaterDetailsCard(),

                    // /// Notes
                    NotesCard(profile.data.getItem(DatabaseIds.notes))
                  ]);
                }));
  }
}

class WaterDetailsCard extends StatefulWidget {
  _WaterDetailsCardState createState() => _WaterDetailsCardState();
}

class _WaterDetailsCardState extends State<WaterDetailsCard> {
  final double _padding = 5.0;
  final double _textFieldWidth = 140.0;

  bool _isExpanded;

  void initState() { 
    super.initState();
    _isExpanded = MainBloc.of(context).preferances.getPreferance(Preferance.roastedBeansExpansion); 
  }

  void _expansionCallback(int index, bool isExpanded) {
    setState(() {
      _isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, _, ProfilePageModel model) =>
            StreamBuilder<Profile>(
                stream: model.profileStream,
                builder:
                    (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ExpansionPanelList(
                      expansionCallback: _expansionCallback,
                      children: <ExpansionPanel>[
                        ExpansionPanel(
                            isExpanded: _isExpanded ?? false,
                            headerBuilder: (BuildContext context,
                                    bool expanded) =>
                                Container(
                                  alignment: Alignment(0, 0),
                                  child: Text(
                                    'Measurements',
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                            body: Container(
                                padding: EdgeInsets.fromLTRB(_padding, 0 ,_padding,_padding),
                                margin: EdgeInsets.fromLTRB(_padding, 0 ,_padding,_padding),
                                child: Column(
                                  children: <Widget>[

                                      /// Date
                                       
                                       DateTimeTextField(StringLabels.dateTested,
                                          snapshot.data.getItemValue(DatabaseIds.date),
                                          (dateTime) {
                                        model.setProfileItemValue(DatabaseIds.date, dateTime);
                                      }),
                                      
                                
                                    ///Row 1
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          ///Total ppm
                                          TextFieldItemWithInitalValue(
                                            snapshot.data
                                                .getItem(DatabaseIds.ppm),
                                            width: _textFieldWidth,
                                          ),

                                          ///gh Ppm
                                          TextFieldItemWithInitalValue(
                                            snapshot.data
                                                .getItem(DatabaseIds.gh),
                                            width: _textFieldWidth,
                                          ),
                                        ]),

                                    ///Row 2
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        /// kH
                                        TextFieldItemWithInitalValue(
                                          snapshot.data.getItem(DatabaseIds.kh),
                                          width: _textFieldWidth,
                                        ),

                                        /// pH
                                        TextFieldItemWithInitalValue(
                                          snapshot.data.getItem(DatabaseIds.ph),
                                          width: _textFieldWidth,
                                        ),
                                      ],
                                    ),
                                  ],
                                )))
                      ]);
                }));
  }
}

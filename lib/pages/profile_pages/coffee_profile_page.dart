import 'package:dial_in_v1/data/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/pages/profile_pages/profile_page_model.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:dial_in_v1/data/mini_classes.dart';

/// Page
class CoffeeProfilePage extends StatelessWidget {

  /// UI Build
  @override
  Widget build(BuildContext context) {
    return 
    
     ScopedModelDescendant(builder: (BuildContext context,_, ProfilePageModel model) =>

     StreamBuilder<Profile>(
      stream: model.profileStream,
      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot){
        if (!snapshot.hasData){ return Center(child: CircularProgressIndicator(),);}

        return
        
    Column(
      children: <Widget>[

        Card(child:
        Container(margin: EdgeInsets.all(10), height: 100.0, width: double.infinity, child:
        Column(mainAxisAlignment: MainAxisAlignment.center ,children: <Widget>[
        TextFieldItemWithInitalValue
        (snapshot.data.getItem( DatabaseIds.coffeeId), width: 300)]))),
     
          RoastingDetailsCard(),

          ///Origin details
          OriginDetailsCard(),

          /// Green details
          GreenDetailsCard(),

      ] );
      }
    ) 
  );
}
}


class OriginDetailsCard extends StatefulWidget {
  _OriginDetailsCardState createState() => _OriginDetailsCardState();}
class _OriginDetailsCardState extends State<OriginDetailsCard> {

  final double _padding = 5.0;
  final double _margin = 5.0;
  final double _textFieldWidth = 150.0;

  bool _isExpanded = true;

  void initState() { 
    super.initState();
    _isExpanded = MainBloc.of(context).preferances.getPreferance(Preferance.originDetailsExpansion) ?? false; 
  }

  void _expansionCallback(int index, bool isExpanded) {
    setState(() {
       MainBloc.of(context).preferances.setPreferance(Preferance.originDetailsExpansion, !isExpanded);
    });
   }
 
 @override
  Widget build(BuildContext context) {

    return 
    
      
    ScopedModelDescendant(builder: (BuildContext context,_, ProfilePageModel model) =>

    StreamBuilder<Profile>(
        stream: model.profileStream,
        builder: (BuildContext context, AsyncSnapshot<Profile> snapshot){

          if (!snapshot.hasData){ return CenterdCircularProgressIndicator(); }

          return
    ExpansionPanelList(
        expansionCallback:  _expansionCallback,
        children: <ExpansionPanel>[

        ExpansionPanel(
          isExpanded: MainBloc.of(context).preferances.getPreferance( Preferance.originDetailsExpansion ) ?? false,
          headerBuilder:(BuildContext context , bool expanded)=> 
            Container(alignment: Alignment(0, 0), padding: EdgeInsets.all( _margin), margin: EdgeInsets.all( _margin), child: 
            Text(StringLabels.originDetails, style: Theme.of(context).textTheme.subhead,),), 
          body: Padding(padding: EdgeInsets.fromLTRB( 20,0,20,20,),child: Column(
          children: <Widget>[
      ///Row 1
      Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[
        ///Country TODO
        // TextFieldItemLauncher(snapshot.data.getItem(DatabaseIds.country), () => PopUps.showCountryPicker(context, model)),
        PickerTextField(snapshot.data.getItem(DatabaseIds.country), _textFieldWidth,),
        
        ///Farm
        TextFieldItemWithInitalValue(snapshot.data.getItem(DatabaseIds.farm),width: _textFieldWidth),
      ],),

      ///Row 2
      Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[
      ///Producer
        TextFieldItemWithInitalValue( snapshot.data.getItem( DatabaseIds.producer ),width: _textFieldWidth ),
      ///Lot
        TextFieldItemWithInitalValue( snapshot.data.getItem( DatabaseIds.lot ),width: _textFieldWidth ),
      ],),

      ///Row 3
      Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[
        ///Alititude
        TextFieldItemWithInitalValue(snapshot.data.getItem(DatabaseIds.altitude),width: _textFieldWidth),
          ///Region
        TextFieldItemWithInitalValue(snapshot.data.getItem(DatabaseIds.region),width: _textFieldWidth),
        
      ],)
    ],),))
        ]);
          }
    )
    );
  }
}


/// Roasting details
class RoastingDetailsCard extends StatefulWidget {
  RoastingDetailsCardState createState() => new RoastingDetailsCardState();}
class RoastingDetailsCardState extends State<RoastingDetailsCard> {
  final double _margin = 5.0;
  final double _textFieldWidth = 150.0;

  bool _isExpanded = true; 

  void initState() { 
    super.initState();
    _isExpanded = MainBloc.of(context).preferances.getPreferance(Preferance.roastedBeansExpansion) ?? false; 
  }

  void _expansionCallback(int index, bool isExpanded) {
    setState(() {
       _isExpanded = !isExpanded;
       MainBloc.of(context).preferances.setPreferance(Preferance.roastedBeansExpansion, _isExpanded) ;
    });
  }

 @override
  Widget build(BuildContext context) =>

    ScopedModelDescendant(builder: (BuildContext context,_, ProfilePageModel model) =>

    StreamBuilder<Profile>(
          stream: model.profileStream,
          builder: (BuildContext context, AsyncSnapshot<Profile> snapshot){

          if (!snapshot.hasData){ return CenterdCircularProgressIndicator();}
            
    return 
    
    ExpansionPanelList(
      expansionCallback:  _expansionCallback,
      children: <ExpansionPanel>[

        ExpansionPanel(
          isExpanded: _isExpanded ?? false,
          headerBuilder:(BuildContext context , bool expanded)=> 
              
            Container(alignment: Alignment(0, 0), padding: EdgeInsets.all( _margin), margin: EdgeInsets.all( _margin), child: 
            Text(StringLabels.roastedCoffeeDetails, style: Theme.of(context).textTheme.subhead,),), 
          body: Padding(padding: EdgeInsets.fromLTRB(20,0,20,20,),child: Column(
          children: <Widget>[
    
        ///Row 1
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[
          
          Expanded(flex: 5,child:
          DateTimeTextField(
            StringLabels.date,
            snapshot.data.getItemValue(DatabaseIds.roastDate),
            (DateTime dateTime) { if ( dateTime != null && dateTime is DateTime){ model.setProfileItemValue( DatabaseIds.roastDate , dateTime );}},
            dateFormat: 'd/M/yyyy',
            justDate: true,)
            ,),

        ///Roast profile
          PickerTextField
          (snapshot.data.getItem(DatabaseIds.roastProfile), _textFieldWidth),                  
        ],),

        ///Row 2
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[
          ///Roastery Name
          TextFieldItemWithInitalValue
          (snapshot.data.getItem(DatabaseIds.roasteryName), width: _textFieldWidth) ,    
          
          /// Roastery name
          TextFieldItemWithInitalValue
          (snapshot.data.getItem(DatabaseIds.roasterName), width: _textFieldWidth) ,    
                                 
        ],)
    ],
    )))
    ]);
  })
  );
}           
        
class ProfileInputCard extends StatelessWidget {
  final double _padding = 20.0;
  final double _margin = 10.0;
  final double _textFieldWidth = 150.0;

  final String imageRefString;
  final String title;
  final Function(String) onAttributeTextChange;
  final Function onProfileTextPressed;
  final String profileTextfieldText;
  final String attributeTextfieldText;
  final String attributeHintText;
  final String profileHintText = StringLabels.chooseProfile;
  final String attributeTitle;
  final double _spacing = 5.0;
  final TextInputType keyboardType;

  ProfileInputCard(
      {this.imageRefString,
      this.title,
      this.onAttributeTextChange,
      this.onProfileTextPressed,
      this.attributeTextfieldText,
      this.attributeHintText,
      this.attributeTitle,
      this.profileTextfieldText,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(_margin),
        child: Container(
            padding: EdgeInsets.all(_padding),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, _margin),
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        RawMaterialButton(
                          onPressed: onProfileTextPressed,
                          child: Text(
                            StringLabels.selectProfile,
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, _margin),
                            width: 40.0,
                            height: 40.0,
                            child: Image.asset(
                              imageRefString,
                              fit: BoxFit.cover,
                            )),

                        Container(
                          width: _spacing,
                          height: _spacing,
                        ),

                        Container(
                            width: _textFieldWidth,
                            child: TextField(
                              textAlign: TextAlign.end,
                              keyboardType: keyboardType,
                              decoration: new InputDecoration(
                                labelText: attributeTitle,
                                hintText: attributeHintText,
                              ),
                              onChanged: onAttributeTextChange,
                            ))
                      ])
                ])));
  }
}

class GreenDetailsCard extends StatefulWidget {
  GreenDetailsCard({Key key}) : super(key: key);
  _GreenDetailsCardState createState() => _GreenDetailsCardState();}
class _GreenDetailsCardState extends State<GreenDetailsCard> {

  final double _padding = 5.0;
  final double _margin = 5.0;
  final double _textFieldWidth = 150.0;

  bool _isExpanded; 

  void initState() { 
    super.initState();
    _isExpanded = MainBloc.of(context).preferances.getPreferance(Preferance.greenBeansExpansion); 
  }

  void _expansionCallback(int index, bool isExpanded) {
    setState(() {
       _isExpanded = !isExpanded;
       MainBloc.of(context).preferances.setPreferance(Preferance.greenBeansExpansion, _isExpanded) ;
    });
   }

 @override
  Widget build(BuildContext context) {
    return 
    
    ScopedModelDescendant(builder: (BuildContext context,_, ProfilePageModel model) =>

    StreamBuilder<Profile>(
          stream: model.profileStream,
          builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {

    if( !snapshot.hasData ){ return CenterdCircularProgressIndicator(); }

    return

   ExpansionPanelList(
  
      expansionCallback:  _expansionCallback,
      children: <ExpansionPanel>[

        ExpansionPanel(
          isExpanded: _isExpanded ?? false,
          headerBuilder:(BuildContext context , bool expanded)=> 
            Container(alignment: Alignment(0, 0), child: 
            Text(StringLabels.greenCoffeeDetails, style: Theme.of(context).textTheme.subhead,),), 
          body: Padding(padding: EdgeInsets.fromLTRB(20,0,20,20,),child: Column(
          children: <Widget>[

        ///Row 1
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[

          ///BeanType
          PickerTextField(snapshot.data.getItem(DatabaseIds.beanType), _textFieldWidth),
        
          ///BeanSize
          PickerTextField(snapshot.data.getItem(DatabaseIds.beanSize), _textFieldWidth),
        ],),

        ///Row 2
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[

          ///Processing Methord
          PickerTextField(snapshot.data.getItem(DatabaseIds.processingMethod), _textFieldWidth),

          ///Density
          TextFieldItemWithInitalValue(snapshot.data.getItem(DatabaseIds.density), width: _textFieldWidth,)                
        ],),

        ///Row 3
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[

          ///Water activity
          TextFieldItemWithInitalValue(snapshot.data.getItem(DatabaseIds.aW),width: _textFieldWidth),

          ///moisture Content
          TextFieldItemWithInitalValue(snapshot.data.getItem(DatabaseIds.moisture),width: _textFieldWidth)                  
        ],),

        ///Row 4
        Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: <Widget>[

          ///Harvest
        TextFieldItemWithInitalValue(snapshot.data.getItem(DatabaseIds.harvest), width: _textFieldWidth),
        // DateTimeTextField 
                     
        ],),     
    ],),)
    )
      ]);
  }
    )
  );
  }
}

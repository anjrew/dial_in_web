import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:dial_in_v1/pages/overview_page/profile_list.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'package:dial_in_v1/data/strings.dart';
import 'package:dial_in_v1/theme/appColors.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dial_in_v1/routes/routes.dart';

/// Data page
class DataPage extends StatefulWidget {

  @override
  DataPageState createState() => new DataPageState();}
  class DataPageState extends State<DataPage>with SingleTickerProviderStateMixin {

  TabController _controller;
  List<ProfileTabViewData> _tabViewDataArray;
  int index;

  @override
  void initState() { 
    super.initState();
    _tabViewDataArray = [
      ProfileTabViewData(
        DataList( ProfileType.recipe ),
        Icons.list,
        StringLabels.recipe,
        ProfileType.recipe,
        context
      ),
      ProfileTabViewData(
        DataList( ProfileType.coffee ),
        MdiIcons.egg,
        StringLabels.coffee,
        ProfileType.coffee,
        context
      ),
      ProfileTabViewData(
        DataList( ProfileType.grinder ),
        FontAwesomeIcons.mortarPestle,
        StringLabels.grinder,
        ProfileType.grinder,
        context
      ),
      ProfileTabViewData(
        DataList( ProfileType.equipment ),
        FontAwesomeIcons.filter,
        StringLabels.method,
        ProfileType.equipment,
        context
      ),
      ProfileTabViewData(
        DataList( ProfileType.water ),
        MdiIcons.water,
        StringLabels.water,
        ProfileType.water,
        context
      ),
      ProfileTabViewData(
        DataList( ProfileType.barista,),
        Icons.people,
        StringLabels.barista,
        ProfileType.barista,
        context
      ),
    ];  
    _controller = new TabController(vsync: this, length: _tabViewDataArray.length);
    _controller.addListener(setupListRefData);  
  }
  
  @override
  void didChangeDependencies() {   
    super.didChangeDependencies(); 
    index =  MainBloc.of(context).overviewBloc.currentDataListIndex ?? 0;
    _controller.animateTo(index);
  }

  void setupListRefData(){
    MainBloc.of(context).overviewBloc.setListref(_controller.index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//
  /// UI Build
  ///
  @override
  Widget build( BuildContext context ) {

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                boxShadow: [ BoxShadow(
                  color: Colors.grey, 
                  offset: Offset(0, 0.1), 
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 1.0)]),
              child: Material(
                color: Theme.of(context).cardColor,
                child: TabBar(
                    
                    unselectedLabelColor: Theme.of(context).primaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: new BubbleTabIndicator(
                      insets: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      indicatorHeight: 30,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,),
                    indicatorPadding: EdgeInsets.all(0.0),
                    labelPadding: EdgeInsets.all(0.0),
                    controller: _controller,
                    tabs: <Widget>[
                      _tabViewDataArray[0].tab,
                      _tabViewDataArray[1].tab,
                      _tabViewDataArray[2].tab,
                      _tabViewDataArray[3].tab,
                      _tabViewDataArray[4].tab,
                      _tabViewDataArray[5].tab,
                    ]),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  _tabViewDataArray[0].screen,
                  _tabViewDataArray[1].screen,
                  _tabViewDataArray[2].screen,
                  _tabViewDataArray[3].screen,
                  _tabViewDataArray[4].screen,
                  _tabViewDataArray[5].screen,
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: ScopedModelDescendant<MainBloc>
            ( rebuildOnChange: false, builder: (context, _ ,model) => AddButton(()async{
          Routes.openProfilePage(context, '', _tabViewDataArray[_controller.index].type, false, true, false, false, true, '89787987');
        }))
    );
  }
}

class DataList extends StatelessWidget {

  final ProfileType _profileType;

  DataList(this._profileType);

  @override
  Widget build(BuildContext context) =>    
    Container(
        color: AppColors.getColor(ColorType.lightBackground),
        key: UniqueKey(),
        child:
        Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch,children:[
            Padding( padding: EdgeInsets.all(2) ),
            ProfileList( _profileType, true )
            ]
        )
    );   
}



          
        





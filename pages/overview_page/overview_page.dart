import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/data/strings.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:dial_in_v1/pages/overview_page/data.dart';
import 'package:dial_in_v1/pages/overview_page/feed.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:dial_in_v1/pages/overview_page/current_user_page.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:dial_in_v1/theme/appColors.dart';
import 'package:dial_in_v1/routes/routes.dart';

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => new _OverviewPageState();}
  class _OverviewPageState extends State<OverviewPage> with SingleTickerProviderStateMixin {
  TabController _controller;
  TabViewDataArray _tabViews;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabViews = TabViewDataArray(context);
    _controller = new TabController(vsync: this, length: _tabViews.tabs.length);
    _controller.addListener(() => _createTitle());
    MainBloc.of(context).overviewBloc.currentDataListStream.listen((d) => _createTitle());
    checkFirstTimer();
    super.initState();
  }


  void checkFirstTimer()async{
    bool isfirstTimer = await MainBloc.of(context).checkIsFirstTimer();
    // TODO
    if (isfirstTimer) { Navigator.pushNamed(context, RouteIds.welcome); }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget _title;

  void _createTitle(){
    if (this.mounted){ 
      setState(() {
      switch (_controller.index) {
        case 0:
          _title = FeedTitle();
          break;
        case 1:
          _title = DataListFilterBar(true);
          break;
        case 2:
          _title = Text("Your user profile", style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.white :Colors.black87),);
          break;
        default:
      }  
    });
    }
    else{
      _title = FeedTitle();
    }
    assert(_title != null, '_title is null');
  }

  void logOut(BuildContext context) {
    showLogOutWarning(context).then((loggedOut) {
      if (loggedOut != null) {
        if (loggedOut is bool) {
          if (loggedOut) {
            if ( Navigator.canPop(context)){
              Navigator.pop(context);
            }
            else{
              Navigator.pushNamed(context, RouteIds.login);
            }
          }
        }
      }
    });
  }

  Future<bool> showLogOutWarning(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(StringLabels.logOut),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  MainBloc.of(context).logOut();
                  Navigator.pop(context, true);
                }),
            FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  /// UI Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      /// App bar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 209, 140, 92),
        centerTitle: true,
        brightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
        title:  _title,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: RawMaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () { logOut(context); },
          child: Icon(
            Icons.exit_to_app,
            color: Theme.of(context).brightness == Brightness.light ? Colors.white :Colors.black,
          ),
        ),
        actions: <Widget>[
          RawMaterialButton(
              padding: EdgeInsets.all(0),
              onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
              child: Icon(
                Icons.menu,
                color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
              ))
        ],
      ),
      endDrawer: MainMenuDrawer(),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          _tabViews.tabs[0].screen,
          _tabViews.tabs[1].screen,
          _tabViews.tabs[2].screen,
        ],
      ),
      bottomNavigationBar: FancyBottomNavigation(
        activeIconColor: AppColors.getColor(ColorType.lightColor),
        barBackgroundColor: Theme.of(context).cardColor,
        tabs: [
          _tabViews.tabs[0].data,
          _tabViews.tabs[1].data,
          _tabViews.tabs[2].data,
        ],
        onTabChangedListener: (position) {
          setState(() {
            _controller.animateTo(position);
          });
        },
      )
    );
  }
}

class TabViewDataArray {
  List<TabViewData> tabs;

  TabViewDataArray(BuildContext context) {
  this.tabs = [
    new TabViewData(
      new FeedPage(),
        Icons.public,
        StringLabels.feed),
    new TabViewData(
      new DataPage(),
      Icons.list,
      StringLabels.records
      ),
    new TabViewData(
        new CurrentUserPage(),
        Icons.portrait,
        StringLabels.user)
    ];
  }
}

class FeedTitle extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>

  StreamBuilder<String>(
  stream: MainBloc.of(context).overviewBloc.feedTitleSream,
  initialData: "Feed",
  builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>

    Text(snapshot.data, style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.white :Colors.black))
   
  );
}


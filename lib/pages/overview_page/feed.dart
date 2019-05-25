import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/pages/overview_page/feed_list.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'package:dial_in_v1/data/strings.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:dial_in_v1/theme/appColors.dart';

class FeedPage extends StatefulWidget {
  @override
  FeedPageState createState() => new FeedPageState();
}

class FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  List<TabViewData> _tabViewDataArray;

  @override
  void initState() {
    super.initState();

    _tabViewDataArray = [
      TabViewData(
          FeedList(FeedType.community), Icons.public, StringLabels.public),
      TabViewData(
          FeedList(FeedType.following), Icons.people, StringLabels.following),
    ];
    _controller =
        new TabController(vsync: this, length: _tabViewDataArray.length);
    _controller.addListener(() =>
        MainBloc.of(context).overviewBloc.currentFeedRef = _controller.index);
    MainBloc.of(context).overviewBloc.currentFeedRef = 0;
  }

  @override
  void didChangeDependencies() {
    int index = MainBloc.of(context).overviewBloc.currentFeedRef ?? 0;
    _controller.animateTo(index);
    super.didChangeDependencies();
  }

  void setupListRefData() {
    MainBloc.of(context).overviewBloc.setListref(_controller.index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///
  /// UI Build
  ///
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: AppColors.getColor(ColorType.lightBackground),
        body: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: AppColors.getColor(ColorType.lightBackground),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 0.1),
                      blurRadius: 5.0, // has the effect of softening the shadow
                      spreadRadius: 1.0)
                ]),
            child: Material(
              color: Theme.of(context).cardColor,
              child: TabBar(
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(0.0),
                  indicator: new BubbleTabIndicator(
                    insets:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                    indicatorHeight: 30,
                    indicatorColor: Theme.of(context).primaryColor,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  labelPadding: EdgeInsets.all(0.0),
                  controller: _controller,
                  tabs: <Widget>[
                    _tabViewDataArray[0].tab,
                    _tabViewDataArray[1].tab,
                  ]),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                _tabViewDataArray[0].screen,
                _tabViewDataArray[1].screen,
              ],
            ),
          ),
        ]));
  }
}

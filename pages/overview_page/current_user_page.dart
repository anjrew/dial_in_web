import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'package:dial_in_v1/pages/overview_page/user_profile_page.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';


class CurrentUserPage extends StatelessWidget{

  Widget setupWidgetView(SnapShotDataState dataState , AsyncSnapshot<UserProfile> snapshot, BuildContext context){

    Widget _returnWidget;

    switch(dataState){
      case SnapShotDataState.waiting: 
        _returnWidget = 
                Center(child:
                  Column
                  (mainAxisAlignment: MainAxisAlignment.center ,children: <Widget>[
                    
                    CircularProgressIndicator(),
                    Container(margin: EdgeInsets.all(20.0),child: Text('Loading...'),) ,
                    ],
                  ),
                );
        break;

      case SnapShotDataState.noData:
        _returnWidget =  Stack(children: <Widget>[ 
                Center(child:
                  Column
                  (mainAxisAlignment: MainAxisAlignment.center ,children: <Widget>[
                    Container(child: Icon(Icons.no_sim),),
                    Container(margin: EdgeInsets.all(20.0),child: Text('No Data',style: Theme.of(context).textTheme.display3,),) ,],)),
                  ],);
        break;

      case SnapShotDataState.hasError:
        _returnWidget =  Stack(children: <Widget>[ 
                Container(color: Colors.white,),
                Center(child:
                  Column
                  (mainAxisAlignment: MainAxisAlignment.center ,children: <Widget>[
                    Container(child: Icon(Icons.warning),),
                    Container(margin: EdgeInsets.all(20.0),child: Text('Error',style: Theme.of(context).textTheme.display3,),) ,],)),
                  ],);
        break;

      case SnapShotDataState.hasdata:
        _returnWidget = UserProfilePage(snapshot.data, true, tag:'0');

        break;
    }   

    return _returnWidget ?? Stack(children: <Widget>[ 
                                  Center(child:
                                    Column
                                    (mainAxisAlignment: MainAxisAlignment.center ,children: <Widget>[
                                      Container(child: Icon(Icons.warning),),
                                      Container(margin: EdgeInsets.all(20.0),child: Text('Error',style: Theme.of(context).textTheme.display3,),) ,],)),
                                    ],
                                  );
  }

  /// UI Build
  @override
  Widget build(BuildContext context) {

    return 
    StreamBuilder<UserProfile>(
          stream:  MainBloc.of(context).userProfileStream,
          builder: (context, snapshot) {

     switch (snapshot.hasError) {
              case true: return setupWidgetView(SnapShotDataState.hasError, snapshot, context);
              case false:

              switch (snapshot.hasData) {
                case false: 
                  switch(snapshot.connectionState){
                    case ConnectionState.none: break;
                    case ConnectionState.active: return setupWidgetView(SnapShotDataState.noData, snapshot, context);
                    case ConnectionState.waiting: return setupWidgetView(SnapShotDataState.waiting, snapshot, context);
                    case ConnectionState.done: break;
                  }     
                  break;       

                case true: return setupWidgetView(SnapShotDataState.hasdata, snapshot, context); 
                  
                default: Error();
              }
     }
    }
    );
  }
}
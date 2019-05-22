import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:dial_in_v1/pages/login/bloc_login_signup.dart';
import 'package:dial_in_v1/pages/login/log_in.dart';
import 'package:dial_in_v1/pages/login/sign_up.dart';
import 'package:dial_in_v1/routes/routes.dart';
import 'package:dial_in_v1/widgets/popups.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginSignUpPage extends StatefulWidget {
  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  LoginSignUpBloc _bloc;

  @override
  void initState() {
    _bloc = new LoginSignUpBloc(mainBloc: MainBloc.of(context));
    _bloc.notificationsStream.listen(_recieveNotifications);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: _bloc.mainBloc.images.kalitaMain, fit: BoxFit.cover)),
      alignment: Alignment(0, 0),
      child: new Stack(children: <Widget>[
        Container(
          color: Colors.white.withOpacity(0.8),
        ),
        ScopedModel(
          model: _bloc,
          child: SafeArea(
            child: PageView(
              scrollDirection: Axis.vertical,
              controller: _bloc.pageController,
              pageSnapping: true,
              children: <Widget>[ LoginPage(), SignUpPage()],
            ),
          ),
        ),
      ]));

  void _recieveNotifications(LoginSignUpNotification notification) {
    if (notification.wasSuccessful) {
      if (notification.navigation == LoginSignUpNavigation.overview) {
        navigateToOverviewPage();
      }
    } 
    else {

    }
  }

  void navigateToOverviewPage() async {
    if (this.mounted) {
      await MainBloc.of(context).init().catchError((error) {
        PopUps.showAlert(
            "Failed to log in",
            error.toString(),
            'OK',
            () => Navigator.popUntil(
                context, ModalRoute.withName(RouteIds.login)),
            context);
      });
      Navigator.of(context).pop();

      if (Navigator.of(context).canPop()) {
        Navigator.popAndPushNamed(context, RouteIds.overview);
      } else {
        Navigator.pushNamed(context, RouteIds.overview);
      }
    } else {
      Future.delayed(Duration(seconds: 1));
      navigateToOverviewPage();
    }
  }
}

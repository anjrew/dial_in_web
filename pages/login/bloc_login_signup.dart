import 'dart:async';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginSignUpBloc extends Model {

  MainBloc mainBloc;

  // TextEditingController _
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  PageController pageController =
      new PageController(initialPage: 0, viewportFraction: 1);

  // For notifications to the UI
  BehaviorSubject<LoginSignUpNotification> _notifications =
      new BehaviorSubject<LoginSignUpNotification>();
  Stream<LoginSignUpNotification> get notificationsStream =>
      _notifications.stream;

  LoginSignUpBloc({@required this.mainBloc});

  static LoginSignUpBloc of(BuildContext context) =>
      ScopedModel.of<LoginSignUpBloc>(context);

  void toSignUpButtonPressed() {
    pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  void loginButtonPressed() {
    login();
  }

Future login() async {
  
    await mainBloc.logOut();

    mainBloc.login(emailController.text.trim(), passwordController.text.trim(),
        (success, error) async {
      if (success) {
        emailController.text = '';
        passwordController.text = '';
        _notifications.add(new LoginSignUpNotification(
          message: 'Successful Login',
          title: "Success",
          wasSuccessful: true,
          navigation: LoginSignUpNavigation.overview,
        ));
      } else {
        new LoginSignUpNotification(
          message: error.toString(),
          title: "Failed to log in",
          wasSuccessful: false,
          navigation: LoginSignUpNavigation.none,
        );
      }
    }).catchError((error) {
        if (error is TimeoutException) {
          _notifications.add(new LoginSignUpNotification(
            message: error.message,
            title: "Failed to log in",
            wasSuccessful: false,
            navigation: LoginSignUpNavigation.none,
          ));
        } else {
          _notifications.add(new LoginSignUpNotification(
            message: error.toString(),
            title: "Failed to log in",
            wasSuccessful: false,
            navigation: LoginSignUpNavigation.none,
          ));
        }
    });
}

  void signUpBackButtonPressed() {
    pageController.animateToPage(0,
        curve: Curves.easeOut, duration: Duration(milliseconds: 500));
  }
}

class LoginSignUpNotification {
  String message;
  String title;
  bool wasSuccessful;
  LoginSignUpNavigation navigation;

  LoginSignUpNotification({
    @required this.message,
    @required this.title,
    @required this.wasSuccessful,
    @required this.navigation,
  });
}

enum LoginSignUpNavigation { login, none, overview }

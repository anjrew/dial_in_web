import 'dart:async';
import '../../widgets/popups.dart';
import 'package:flutter_web/material.dart';
import '../../data/strings.dart';
import '../../widgets/custom_widgets.dart';
import '../../data/database_functions.dart';
import '../../theme/appColors.dart';
import '../../routes/routes.dart';

class LoginPage extends StatefulWidget {
    @override
    _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
    final Image _logo = Image.asset('assets/images/dial_in_logo_nobg.png',
        height: 200.0, width: 250.0);

    TextEditingController _emailController;
    TextEditingController _passwordController;

    @override
    void initState() {
        _emailController = LoginSignUpBloc.of(context).emailController;
        _passwordController = LoginSignUpBloc.of(context).passwordController;
        super.initState();
    }

    void forgotPassword() {
        PopUps.forgottonPasswordPopup(context);
    }

    void loginButtonPressed() async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => Center(child: CircularProgressIndicator()));

        await MainBloc.of(context).logOut();

        MainBloc.of(context)
            .login(_emailController.text.trim(), _passwordController.text.trim(),
                (success, error) async {
        if (success) {
            setState(() {
            _emailController.text = '';
            _passwordController.text = '';
            });
            navigateToOverviewPage();
        } else {
            Navigator.pop(context);
            PopUps.showAlert(
                "Failed to log in",
                error.toString(),
                'OK',
                () => Navigator.pop(context),
                context);
        }
        }).catchError((error) {
        if (error is TimeoutException) {
            PopUps.showAlert(
                "Failed to log in",
                error.message,
                'OK',
                () => Navigator.popUntil(
                    context, ModalRoute.withName(RouteIds.login)),
                context);
        } else {
            PopUps.showAlert(
                "Failed to log in",
                error.toString(),
                'OK',
                () => Navigator.popUntil(
                    context, ModalRoute.withName(RouteIds.login)),
                context);
        }
        });
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

    Future<bool> checkForUpdates() async {
        bool isUptodate = await MainBloc.of(context)
            .checkisUpdated()
            .timeout(databaseTimeoutDuration);

        if (!isUptodate) {
        await PopUps.showAlert(
            'Warning',
            'You need to update this app. This version is old news.',
            'OK',
            () => Navigator.pop(context),
            context);
        }
        return isUptodate;
    }

    @override
    Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Container(
            alignment: Alignment(0, 0),
            child: Scaffold(
            backgroundColor: Colors.transparent,
            body: new ListView(
            children: <Widget>[
                Padding(
                padding: EdgeInsets.all(20.0),
                ),

                /// Logo
                Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Hero(
                    tag: 'logo',
                    child: _logo,
                    )),

                // Welcome text
                Container(
                    width: 230.0,
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment(0.0, 0.0),
                    child: Text(
                    StringLabels.welcomeToDialIn,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline,
                    )),

                // Instructions
                Container(
                    width: 260.0,
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment(0.0, 0.0),
                    child: Text(
                    StringLabels.logInWithDetails,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subhead,
                    )),

                // Email field
                TextFieldEntry(StringLabels.email, _emailController, false, textInputType: TextInputType.emailAddress,),

                // Password
                TextFieldEntry(StringLabels.password, _passwordController, true),

                // Forgotton password
                Container(
                margin: const EdgeInsets.all(5.0),
                child: FlatButton(
                    child: Text(StringLabels.forgottonPassword,
                        style: TextStyle(fontWeight: FontWeight.w300)),
                    onPressed: () {
                        forgotPassword();
                    }),
                ),

                /// Login button
                LoginButton(loginButtonPressed),

                Container(
                    margin: const EdgeInsets.all(15.0),
                    child: Center(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                        // Text
                        Container(
                            margin: const EdgeInsets.all(0.0),
                            child: Text(StringLabels.dontHaveAccount,
                                style: TextStyle(fontSize: 10.0))),

                        // Sign up button
                        SignUpButton()
                        ])))
            ],
            ),
        )
        )
    );
}

/// Login button
class LoginButton extends StatelessWidget {
    final Function loginAction;

    LoginButton(this.loginAction);

    Widget build(BuildContext context) {
        return Center(
            child: Container(
                width: 250,
                child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: AppColors.getColor(ColorType.primarySwatch),
                    child: Text(StringLabels.logIn,
                        style:
                            TextStyle(fontWeight: FontWeight.w300, fontSize: 25.0)
                                .apply(color: Colors.white)),
                    onPressed: loginAction)));
    }
}

/// Sign up Button
class SignUpButton extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return new Container(
        margin: const EdgeInsets.all(0.0),
        child: MaterialButton(
            child: Text(StringLabels.signUp,
                style: TextStyle(
                    color: AppColors.getColor(ColorType.primarySwatch),
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300)),
            onPressed: () => LoginSignUpBloc.of(context).toSignUpButtonPressed()),
        );
    }
}

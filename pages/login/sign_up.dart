import 'package:dial_in_v1/pages/login/bloc_login_signup.dart';
import 'package:dial_in_v1/widgets/popups.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:dial_in_v1/data/strings.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/data/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
    @override
    _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
    
    String _userImage;

    TextEditingController _userNameController = new TextEditingController();
    TextEditingController _emailController = new TextEditingController();
    TextEditingController _passwordController = new TextEditingController();

    LoginSignUpBloc _bloc;

    @override
    void initState() {
        _bloc = LoginSignUpBloc.of(context);
        super.initState();
    }
    
    ///
    /// UI Build
    ///
    @override
    Widget build(BuildContext context) =>
        Stack(
        children: <Widget>[
            
            new Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20.0),
            ),

            /// New User text
            Center(
                child: Text(
                StringLabels.newUser,
                style: TextStyle(color: Colors.black87, fontSize: 30.0),
            )),

            Padding(
                padding: EdgeInsets.all(10.0),
            ),

            ///User Picture
            Center(
                child: InkWell(
                    child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        margin:
                            EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
                        child: CircularCachedProfileImage(
                            Images.user, _userImage, 180.0, '')),
                    onTap: savePicture)),

            /// Sign up details
            /// Username
            Center(
                child: Text(
                StringLabels.userName,
                style: TextStyle(fontWeight: FontWeight.w600),
            )),
            TextFieldEntry(
                StringLabels.userName, _userNameController, false, textInputType: TextInputType.emailAddress),

            /// Email
            Center(
                child: Text(
                StringLabels.email,
                style: TextStyle(fontWeight: FontWeight.w600),
            )),
            TextFieldEntry(StringLabels.email, _emailController, false),

            /// Password
            Center(
                child: Text(
                StringLabels.password,
                style: TextStyle(fontWeight: FontWeight.w600),
            )),
            TextFieldEntry(
                StringLabels.password, _passwordController, true),

            /// Signup button
            Center(
                child: Container(
                margin: EdgeInsets.all(20.0),
                child: ActionButton(StringLabels.signUp, signUpButton),
            )),

            Padding(
                padding: EdgeInsets.all(20.0),
            ),
            ])),

            BackIcon()
        ],
        );
  

    void signUpButton() async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => Center(child: CircularProgressIndicator()));

        await Dbf.signUp(
            _userNameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _userImage, 
            (success, message) {
        Navigator.pop(context);

        if (success) {

            _bloc.emailController.text = _emailController.text;
            _bloc.passwordController.text = _passwordController.text;
            _bloc.login();

        } else {
            PopUps.showAlert(StringLabels.warning, message, StringLabels.ok, () {
            Navigator.of(context).pop();
            }, context);
        }
        }).catchError((message) =>
            PopUps.showAlert(StringLabels.warning, message, StringLabels.ok, () {
            Navigator.of(context).pop();
            }, context));
    }

    void savePicture() async {
        PopUps.showCircularProgressIndicator(context);

        var result = await PopUps.getimageFromCameraOrGallery(context);

        if (result is String) {
        String url =
            await Dbf.upLoadFileReturnUrl(File(result), ['NewUserImages'])
                .catchError((e) => print(e));
        MainBloc.of(context).cache.setFile(url, File(result));
        setState(() {
            _userImage = url;
        });
        Navigator.pop(context);
        } else if (result is ResetImageRequest) {
        setState(() {
            _userImage = null;
        });
        Navigator.pop(context);
        } else {
        Navigator.pop(context);
        }
    }

    @override
    void dispose() {
        _userNameController.dispose();
        _emailController.dispose();
        _passwordController.dispose();
        super.dispose();
    }
}

class BackIcon extends StatelessWidget {

    @override
    Widget build(BuildContext context) => Container(
            margin: EdgeInsets.all(20.0),
            height: 30.0,
            width: 30.0,
            child: RawMaterialButton(
            onPressed: LoginSignUpBloc.of(context).signUpBackButtonPressed,
            child: Transform.rotate(
                angle: 1.56,
                child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/back_icon.png'),
                        fit: BoxFit.fitHeight)),
            ),
            ),),
    );
}

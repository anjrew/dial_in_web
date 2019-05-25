import 'widgets/popups.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/cupertino.dart';
import 'data/strings.dart';
import 'theme/appColors.dart';
import 'package:flutter_web/services.dart';
import 'package:flutter_web/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'classes/error_reporting.dart';
import 'widgets/custom_widgets.dart';
import 'data/mini_classes.dart';

class CupertinoImagePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: 300,
            child: CupertinoActionSheet(
              title: Text(
                StringLabels.photoSource,
                style: Theme.of(context).textTheme.subtitle,
              ),
              actions: <Widget>[
                CupertinoImagePickerDiolog(ImageSource.camera),
                CupertinoImagePickerDiolog(ImageSource.gallery),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Reset to default',
                      style: Theme.of(context).textTheme.display1),
                  onPressed: () => PopUps.showTwoOptionsDiolog(
                        context,
                        title: 'Warning',
                        message:
                            'Are you sure you want to delete this image and reset it to default',
                        actionOneTitle: 'Yes',
                        actionOne: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(ResetImageRequest.reset);
                        },
                        actionTwoTitle: 'No',
                        actionTwo: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                )
              ],
            )));
  }
}

class CupertinoImagePickerDiolog extends StatelessWidget {
  final ImageSource _imageSource;

  CupertinoImagePickerDiolog(this._imageSource);

  @override
  Widget build(BuildContext context) {
    String _title = '';

    if (_imageSource == ImageSource.camera) {
      _title = StringLabels.camera;
    } else {
      _title = StringLabels.photoLibrary;
    }

    return CupertinoDialogAction(
        child: Text(_title, style: Theme.of(context).textTheme.display1),
        isDestructiveAction: false,
        onPressed: () => showImagePicker(context));
  }

  void showImagePicker(BuildContext context) {
    ImagePicker.pickImage(
            maxWidth: 512.0, maxHeight: 384.0, source: _imageSource)
        .then((image) => handleImagePickerReturn(image, context))
        .catchError((error) => print(error));
  }

  void handleImagePickerReturn(dynamic image, BuildContext context) async {
    if (image != null) {
      ///Image is a File
      String filePath = (image as File).path;
      Navigator.of(context, rootNavigator: true).pop(filePath);
    }
  }
}

class ReportContentDiolog extends StatefulWidget {
  final String _referance;
  final String _user;

  ReportContentDiolog(this._referance, this._user, {Key key}) : super(key: key);

  _ReportContentDiologState createState() => _ReportContentDiologState();}
  class _ReportContentDiologState extends State<ReportContentDiolog> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) => Dismissible(
      key: UniqueKey(),
      onDismissed: (dir) {},
      child: Scaffold(
          backgroundColor: AppColors.getColor(ColorType.transparant),
          body: SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Text(
              'Report content',
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
            titlePadding: EdgeInsets.all(10),
            contentPadding: EdgeInsets.all(10),
            children: <Widget>[
              Text(
                  'If you believe some of the content on this post is unacceptible for public viewing, please  give a desciption in the box below.',
                  textAlign: TextAlign.center),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  decoration: InputDecoration.collapsed(
                    hintText: 'e.g racist',
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                width: 150,
                child: RoundedTextButton(
                    text: 'Submit',
                    action: () {
                      Sentry.reportCustomError(CustomError(
                          'Content in profile ${widget._referance} has been deemed unacceptable by user ${widget._user} with message : ${_controller.text} '));
                      Navigator.pop(context);
                    }),
              )
            ],
          )));
}

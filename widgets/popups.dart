
import 'blocs/main_bloc.dart';
import 'classes/error_reporting.dart';
import 'data/item.dart';
import 'data/mini_classes.dart';
import 'data/strings.dart';
import 'inherited_widgets.dart';
import 'pages/profile_pages/profile_page_model.dart';
import 'widgets/custom_widgets.dart';
import 'widgets/diologs/add%20_flavour_descriptor_diolog.dart';
import 'widgets/popups_widgets.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

class PopUps {

    static void showReportContentDiolog(
        BuildContext context, String referance, String userid) {
        showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) =>
                    ReportContentDiolog(referance, userid))
            .then((shouldBeNothing) => Navigator.pop(context));
    }

    static Future<dynamic> getimageFromCameraOrGallery(
        BuildContext contextIn) async {
        var result = await showDialog(
            context: contextIn,
            builder: (BuildContext context) {
            return CupertinoImagePicker();
            }).catchError(Sentry.report);

        return result;
    }

    static void selectSortTypeDiolog(
        BuildContext context, Function(ListSortingOptions) _sortType, {@required Set<ListSortingOptions> options}) {
        showDialog(
            context: context,
            builder: (BuildContext context) => SelectSortTypeDiolog(_sortType, options: options));
    }

    static void logOut(BuildContext context) {
        showLogOutWarning(context).then((loggedOut) {
        if (loggedOut != null) {
            if (loggedOut is bool) {
            if (loggedOut) {
                Navigator.pop(context);
            }
            }
        }
        });
    }

  static Future<bool> showLogOutWarning(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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
                  Navigator.pop(context, true);
                  MainBloc.of(context).logOut();
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

  static Future<dynamic> showTwoOptionsDiolog(BuildContext context,
      {@required String title,
      @required String message,
      @required String actionOneTitle,
      @required String actionTwoTitle,
      @required Function actionOne,
      @required Function actionTwo}) async {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(title),
          titlePadding: EdgeInsets.all(20),
          contentPadding: EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(actionOneTitle),
              onPressed: actionOne,
            ),
            FlatButton(child: Text(actionTwoTitle), onPressed: actionTwo)
          ],
        );
      },
    );
  }

  static void forgottonPasswordPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => ForgottonPasswordDialog());
  }

  static void showCircularProgressIndicator(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
  }

  static void showCountryPicker(BuildContext context, ProfilePageModel model) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CountryPickerDiolog(model)));
  }

  static void showPickerMenu(
      Item item, BuildContext context, ProfilePageModel model) {
    List<Widget> _items = new List<Widget>();
    double _itemHeight = 40.0;

    if (item.inputViewDataSet != null && item.inputViewDataSet.length > 0) {
      item.inputViewDataSet[0].forEach((itemText) {
        _items.add(Center(
            child: Text(
          itemText.toString(),
          style: Theme.of(context).textTheme.display2,
        )));
      });
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          if (item.inputViewDataSet != null &&
              item.inputViewDataSet.length < 1) {
            return Center(
              child: Text('Error No Data for picker'),
            );
          } else {
            int startItem = item.inputViewDataSet[0]
                .indexWhere((value) => (value == item.value));

            FixedExtentScrollController _scrollController =
                new FixedExtentScrollController(initialItem: startItem);

            return Container(
                child: SizedBox(
                    height: 200.0,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Material(
                            elevation: 5.0,
                            shadowColor: Colors.black,
                            color: Theme.of(context).accentColor,
                            type: MaterialType.card,
                            child: Container(
                              height: 40.0,
                              width: double.infinity,
                              alignment: Alignment(1, 0),
                              child: FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Done')),
                            )),
                        SizedBox(
                          height: 160.0,
                          width: double.infinity,
                          child: CupertinoPicker(
                              scrollController: _scrollController,
                              useMagnifier: true,
                              onSelectedItemChanged: (value) {
                                model.setProfileItemValue(item.databaseId,
                                    item.inputViewDataSet[0][value]);
                              },
                              itemExtent: _itemHeight,
                              children: _items),
                        )
                      ],
                    )));
          }
        }).then((nul) {});
  }

  static void showTimePicker(BuildContext context, TimerPickerModel model) {
    showModalBottomSheet(
        context: context, builder: (BuildContext context) => TimePicker(model));
  }

  static void showAddFlavourDescriptorDiolog(BuildContext contextin) {
    showDialog(context: contextin, builder: (BuildContext contextout) => AddFlavourDescriptorDiolog());
  }

  static Future<void> showAlert(String title, String message, String buttonText,
      Function buttonFunction, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(buttonText,
                    style: Theme.of(context).textTheme.display4),
                onPressed: buttonFunction ?? Navigator.of(context).pop())
          ],
        );
      },
    );
  }

  static Future<void> yesOrNoDioLog(BuildContext context, String title,
      String message, Function returnYes) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(child: Text('Yes'), onPressed: () => returnYes(true)),
            FlatButton(child: Text('No'), onPressed: () => returnYes(false))
          ],
        );
      },
    );
  }
}

import 'package:flutter_web/material.dart';
import 'data/strings.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/foundation.dart';
import 'package:meta/meta.dart';
import 'widgets/custom_widgets.dart';
import 'data/item.dart';
import 'data/profile.dart';
import 'database_functions.dart';
import 'package:flutter_web/services.dart';
import 'data/functions.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/profile_pages/profile_page_model.dart';
import 'routes/routes.dart';

class ScoreSlider extends StatefulWidget {
  final double _value;
  final String _label;
  final Function(double) _sliderValue;

  ScoreSlider(
    this._label,
    this._value,
    this._sliderValue,
  );

  ScoreSliderState createState() => new ScoreSliderState();
}

class ScoreSliderState extends State<ScoreSlider> {
  double _value;
  String _label;
  double _margin = 5.0;

  @override
  void initState() {
    _value = widget._value;
    _label = widget._label;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, _, ProfilePageModel model) =>
            StreamBuilder<bool>(
                stream: model.isEditingStream,
                builder: (BuildContext context,
                        AsyncSnapshot<bool> isEditing) =>
                    StreamBuilder<Profile>(
                        stream: model.profileStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<Profile> snapshot) {
                          if (snapshot.data == null) {
                            return BlankWidget();
                          } else {
                            return Container(
                                width: 130,
                                margin: EdgeInsets.all(_margin),
                                padding: EdgeInsets.all(_margin),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(_margin),
                                        padding: EdgeInsets.all(_margin),
                                        child: Text('${widget._label} ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline),
                                      ),
                                      Text('${_value.toInt() ?? 0}/10',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle),
                                      isEditing.data
                                          ? CupertinoSlider(
                                              value: _value,
                                              onChanged: isEditing.data
                                                  ? (value) {
                                                      setState(() {
                                                        _value = value;
                                                      });
                                                    }
                                                  : null,
                                              onChangeEnd: (value) {
                                                widget._sliderValue(value);
                                              },
                                              min: 0,
                                              max: 10,
                                              divisions: 10,
                                              activeColor: Theme.of(context)
                                                  .sliderTheme
                                                  .activeTrackColor,
                                            )
                                          : Container(
                                              width: 0.0,
                                              height: 0.0,
                                            ),
                                    ]));
                          }
                        })));
  }
}

/// Widgets

class ProfileInputCardWithAttribute extends StatefulWidget {
  final double _padding = 5.0;
  final double _margin = 5.0;
  final double textFieldWidth;

  final Item attributeItem;
  final String profileHintText = StringLabels.chooseProfile;
  final Profile profile;

  ProfileInputCardWithAttribute(this.profile, this.attributeItem,
      {this.textFieldWidth = 150.0});
  _ProfileInputCardWithAttributeState createState() =>
      new _ProfileInputCardWithAttributeState();
}

class _ProfileInputCardWithAttributeState
    extends State<ProfileInputCardWithAttribute> {
  TextEditingController _attributeController;
  TextEditingController _profileTextController;
  FocusNode _textFocus;

  @override
  void initState() {
    _attributeController =
        new TextEditingController(text: widget.attributeItem.value);
    _attributeController.addListener(sendAttributeValue);
    _profileTextController = new TextEditingController();
    _textFocus = new FocusNode();
    _textFocus.addListener(handleProfileTextfieldFocus);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _attributeController.dispose();
    _profileTextController.dispose();
    super.dispose();
  }

  void sendAttributeValue() {
    ProfilePageModel.of(context).setProfileItemValue(
        widget.attributeItem.databaseId, _attributeController.text);
  }

  void handleProfileTextfieldFocus() {
    Routes.handleProfileTextfieldFocus(context, _textFocus, widget.profile);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    _profileTextController.text = widget.profile.getProfileTitleValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _profileTextController.text = widget.profile.getProfileTitleValue();
    return Card(
        margin: EdgeInsets.all(widget._margin),
        child: Container(
            padding: EdgeInsets.all(widget._padding),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 10.0,
                  ),

                  CircularCachedProfileImage(widget.profile.placeholder,
                      widget.profile.imageUrl, 40, widget.profile.objectId),

                  /// Left profile selection

                  /// Spacer
                  Container(
                    width: 10.0,
                  ),

                  Expanded(
                      flex: 1,
                      child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: TextFormField(
                            enabled: true,
                            textCapitalization: TextCapitalization.sentences,
                            textAlign: TextAlign.start,
                            keyboardType: widget.attributeItem.keyboardType,
                            decoration: new InputDecoration(
                              labelText: widget.profile.label,
                              hintText: StringLabels.selectProfile,
                            ),
                            focusNode: _textFocus,
                            controller: _profileTextController,
                          ))),

                  /// Spacer
                  Container(
                    width: 10.0,
                  ),

                  Container(
                      margin: EdgeInsets.all(10.0),
                      width: 60.0,
                      child: TextFormField(
                        enabled: ProfilePageModel.of(context).isEditing,
                        textAlign: TextAlign.start,
                        keyboardType: widget.attributeItem.keyboardType,
                        decoration: new InputDecoration(
                          labelStyle: widget.attributeItem.title ==
                                  StringLabels.preinfusion
                              ? TextStyle(fontSize: 8.0)
                              : Theme.of(context).textTheme.caption,
                          labelText: widget.attributeItem.title,
                          hintText: widget.attributeItem.placeHolderText,
                        ),
                        controller: _attributeController,
                      ))
                ])));
  }
}

///Double profile card
class DoubleProfileInputCard extends StatefulWidget {
  final double _padding = 20.0;
  final double _margin = 10.0;
  final double _cornerRadius = 20.0;
  final double _textFieldWidth = 150.0;

  final String leftImageRefString;
  final String leftTitle;
  final String leftTextfieldText;
  final String leftHintText;
  final Function onLeftProfileTextPressed;
  final String rightImageRefString;
  final String rightTitle;
  final String rightTextfieldText;
  final String rightHintText;
  final Function onRightProfileTextPressed;

  DoubleProfileInputCard({
    @required this.leftImageRefString,
    @required this.leftTitle,
    @required this.leftTextfieldText,
    @required this.leftHintText,
    @required this.onLeftProfileTextPressed,
    @required this.rightImageRefString,
    @required this.rightTitle,
    @required this.rightTextfieldText,
    @required this.rightHintText,
    @required this.onRightProfileTextPressed,
  });

  _DoubleProfileInputCardState createState() =>
      new _DoubleProfileInputCardState();
}

class _DoubleProfileInputCardState extends State<DoubleProfileInputCard> {
  TextEditingController _leftController;
  FocusNode _leftFocus;

  TextEditingController _rightController;
  FocusNode _rightFocus;

  @override
  void initState() {
    _leftFocus = new FocusNode();
    _leftFocus.addListener(handleLeftProfileTextfieldFocus);
    _rightFocus = new FocusNode();
    _rightFocus.addListener(handleRightProfileTextfieldFocus);
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    _leftController = new TextEditingController(text: widget.leftTextfieldText);
    _rightController =
        new TextEditingController(text: widget.rightTextfieldText);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  void handleLeftProfileTextfieldFocus() {
    if (_leftFocus.hasFocus) {
      widget.onLeftProfileTextPressed();
      _leftFocus.unfocus();
    }
  }

  void handleRightProfileTextfieldFocus() {
    if (_rightFocus.hasFocus) {
      widget.onRightProfileTextPressed();
      _rightFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(widget._margin),
        child: Container(
            padding: EdgeInsets.all(widget._padding),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /// Left profile selection
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                0.0, 0.0, 0.0, widget._margin),
                            width: 40.0,
                            height: 40.0,
                            child: Image.asset(
                              widget.leftImageRefString,
                              fit: BoxFit.cover,
                            )),
                        Container(
                            width: widget._textFieldWidth,
                            margin: EdgeInsets.fromLTRB(
                                0.0, 0.0, 0.0, widget._margin),
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                labelText: widget.leftTitle,
                                hintText: widget.leftHintText,
                              ),
                              focusNode: _leftFocus,
                              controller: _leftController,
                            )),
                      ]),

                  /// Right
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(
                                0.0, 0.0, 0.0, widget._margin),
                            width: 40.0,
                            height: 40.0,
                            child: Image.asset(
                              widget.rightImageRefString,
                              fit: BoxFit.cover,
                            )),
                        Container(
                          width: widget._textFieldWidth,
                          margin: EdgeInsets.fromLTRB(
                              0.0, 0.0, 0.0, widget._margin),
                          child: TextFormField(
                            textAlign: TextAlign.end,
                            decoration: new InputDecoration(
                              labelText: widget.rightTitle,
                              hintText: widget.rightHintText,
                            ),
                            focusNode: _rightFocus,
                            controller: _rightController,
                          ),
                        ),
                      ]),
                ])));
  }
}

///Profile details card
class ProfileInputWithDetailsCard extends StatefulWidget {
  final double _padding = 10.0;
  final double _margin = 5.0;
  final double _cornerRadius = 20.0;
  final double _textFieldWidth = 150.0;
  final Profile _profile;
  final String _detailTitle;
  final String _detailValue;

  ProfileInputWithDetailsCard(
    this._profile,
    this._detailTitle,
    this._detailValue,
  );

  ProfileInputWithDetailsCardState createState() =>
      ProfileInputWithDetailsCardState();
}

class ProfileInputWithDetailsCardState
    extends State<ProfileInputWithDetailsCard> {
  TextEditingController _controller;
  TextEditingController _detailController;

  FocusNode _focus;

  @override
  void initState() {
    _focus = new FocusNode();
    _focus.addListener(handleProfileTextfieldFocus);
    _controller = new TextEditingController();
    _detailController = new TextEditingController();
    _controller.text = widget._profile.getProfileTitleValue();
    _detailController.text = widget._detailValue;
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    _controller.text = widget._profile.getProfileTitleValue();
    _detailController.text = widget._detailValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _controller.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void handleProfileTextfieldFocus() {
    Routes.handleProfileTextfieldFocus(context, _focus, widget._profile);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            margin: EdgeInsets.all(widget._margin),
            child: Container(
                padding: EdgeInsets.all(widget._padding),
                child: Row(
                    textBaseline: TextBaseline.ideographic,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircularCachedProfileImage(
                          widget._profile.placeholder,
                          widget._profile.imageUrl,
                          40,
                          widget._profile.objectId),

                      Container(
                        width: 10.0,
                      ),

                      /// Profile
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  0.0, 0.0, widget._margin, 0.0),
                              child: TextFormField(
                                enabled: true,
                                textAlign: TextAlign.start,
                                decoration: new InputDecoration(
                                  labelText: widget._profile.databaseId,
                                ),
                                focusNode: _focus,
                                controller: _controller,
                              ))),

                      // /// Spacer
                      Container(
                        width: 10.0,
                      ),

                      /// Attribute Value
                      Container(
                          width: 60,
                          child: TextfieldWithFixedValue(
                              widget._detailTitle, _detailController.text)),
                    ]))));
  }
}

/// TextField With pickerview

//Single profile card
class ProfileInputCard extends StatefulWidget {
  final double _padding = 10.0;
  final double _margin = 5.0;
  final Profile _profile;

  ProfileInputCard(this._profile);

  _ProfileInputCardState createState() => _ProfileInputCardState();
}

class _ProfileInputCardState extends State<ProfileInputCard> {
  TextEditingController _controller;
  FocusNode _focus;

  @override
  void initState() {
    _focus = new FocusNode();
    _focus.addListener(handleProfileTextfieldFocus);
    _controller = new TextEditingController();
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    _controller.text = widget._profile.getProfileTitleValue();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleProfileTextfieldFocus() {
    Routes.handleProfileTextfieldFocus(context, _focus, widget._profile);
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget._profile.getProfileTitleValue();
    return Container(
        child: Card(
            margin: EdgeInsets.all(widget._margin),
            child: Container(
                padding: EdgeInsets.all(widget._padding),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircularCachedProfileImage(
                          widget._profile.placeholder,
                          widget._profile.imageUrl,
                          40,
                          widget._profile.objectId),

                      /// Spacer
                      Container(
                        width: 10.0,
                      ),

                      Expanded(
                          child: Container(
                              margin: EdgeInsets.all(
                                widget._margin,
                              ),
                              child: TextFormField(
                                enabled: true,
                                textAlign: TextAlign.start,
                                decoration: new InputDecoration(
                                  labelText: widget._profile.databaseId,
                                ),
                                focusNode: _focus,
                                controller: _controller,
                              ))),
                    ]))));
  }
}

/// Profile image
class ProfileImage extends StatelessWidget {
  final double _padding = 20.0;
  final double _margin = 10.0;
  final double _textFieldWidth = 120.0;
  final double _cornerRadius = 20.0;
  final Image _image;

  ProfileImage(this._image);

  @override
  Widget build(BuildContext context) {
    return

        /// Profile Image
        Container(
            margin: EdgeInsets.all(_margin),
            width: 200.0,
            height: 200.0,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 1.0, // has the effect of softening the shadow
                spreadRadius: 1.0, // has the effect of extending the shadow
                offset: Offset(
                  1.0, // horizontal, move right 10
                  1.0, // vertical, move down 10
                ),
              )
            ], borderRadius: BorderRadius.circular(_cornerRadius)),
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
                child: _image,
              ),
            ));
  }
}

/// Coffee Card
class CoffeeCard extends StatelessWidget {
  final double _padding = 20.0;
  final double _margin = 10.0;
  final double _textFieldWidth = 120.0;
  final double _cornerRadius = 20.0;
  final Function _openOptions;
  final String coffee;

  CoffeeCard(this._openOptions, this.coffee);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(_margin),
      padding: EdgeInsets.all(_margin),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(width: 10.0, height: 10.0),
            RawMaterialButton(
              onPressed: _openOptions,
              child: Text(StringLabels.selectCoffee),
            ),
            Container(
              child: Text(
                coffee,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ]),
    );
  }
}

/// Ratio Card
class RatioCard extends StatefulWidget {
  final double _margin = 10.0;
  final double _textFieldWidth = 80.0;
  _RatioCardState createState() => _RatioCardState();
}

class _RatioCardState extends State<RatioCard> {
  BrewRatioType _brewRatioType = BrewRatioType.doseYield;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProfilePageModel>(
        rebuildOnChange: false,
        builder: (context, _, model) => StreamBuilder<Profile>(
            stream: model.profileStream,
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Card(
                    child: Container(
                  margin: EdgeInsets.all(widget._margin),
                  padding: EdgeInsets.all(widget._margin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            model.isEditing
                                ? Container(
                                    width: 130.0,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        child: Text(
                                          'Calc Yield',
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        ),
                                        onPressed: () =>
                                            model.estimateBrewRatio(
                                              BrewRatioType.doseYield,
                                            )))
                                : Container(
                                    width: 0,
                                    height: 0,
                                  ),
                            model.isEditing
                                ? Container(
                                    width: 130.0,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        child: Text('Calc Weight',
                                            softWrap: true,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .button),
                                        onPressed: () =>
                                            model.estimateBrewRatio(
                                                BrewRatioType.doseBrewWeight)))
                                : Container(
                                    width: 0,
                                    height: 0,
                                  ),
                          ]),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          /// Dose
                          RatioTextFieldItemWithInitalValue(
                              snapshot.data.getItem(DatabaseIds.brewingDose)),

                          /// Yield
                          RatioTextFieldItemWithInitalValue(
                              snapshot.data.getItem(DatabaseIds.yielde)),

                          /// Brew wieght
                          RatioTextFieldItemWithInitalValue(
                            snapshot.data.getItem(DatabaseIds.brewWeight),
                          ),
                        ],
                      ),

                      Padding(padding: EdgeInsets.all(widget._margin)),

                      /// Dose yeild brew control
                      DoseYieldBrewControl((value) {
                        setState(() {
                          _brewRatioType = value;
                        });
                      }),

                      Padding(padding: EdgeInsets.all(widget._margin)),
                      Container(
                        child: Text(
                          Functions.getTwoNumberRatio(
                              Functions.getIntValue(snapshot.data
                                  .getItemValue(DatabaseIds.brewingDose)),
                              _brewRatioType == BrewRatioType.doseYield
                                  ? Functions.getIntValue(snapshot.data
                                      .getItemValue(DatabaseIds.yielde))
                                  : Functions.getIntValue(snapshot.data
                                      .getItemValue(DatabaseIds.brewWeight))),
                          style: Theme.of(context).textTheme.display3,
                        ),
                      ),

                      Container(
                        child: _brewRatioType == BrewRatioType.doseYield
                            ? Text(
                                'Dose : Yield',
                                style: Theme.of(context).textTheme.caption,
                              )
                            : Text(
                                'Dose : Brew Weight',
                                style: Theme.of(context).textTheme.caption,
                              ),
                      ),
                    ],
                  ),
                ));
              }
            }));
  }
}

///Two textFieldcard
class TdsAndExtractionCard extends StatelessWidget {
  final double _padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, _, ProfilePageModel model) =>
            StreamBuilder<Profile>(
                stream: model.profileStream,
                builder:
                    (BuildContext context, AsyncSnapshot<Profile> profile) {
                    String extractionYieldValue;
                    Widget render;

                    if ( profile.hasData ){
                        extractionYieldValue =  profile.data.getExtractionYield() == 0.0
                            ? ''
                            : profile.data.getExtractionYield().toString() + "%";
                        render =  Card(
                        child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                    Padding(padding: EdgeInsets.all(_padding / 2)),

                                    /// TDS
                                    Container(
                                    width: 100,
                                    child:Row(children: <Widget>[

                                    TextFieldItemWithInitalValue(
                                        profile.data.getItem(DatabaseIds.tds),
                                        width: 100.0,
                                        textInputFormatters: [
                                            BlacklistingTextInputFormatter(
                                            new RegExp('[\\,]'),
                                            replacementString: '.',
                                            )
                                        ],
                                        textAlign: TextAlign.center,),
                                        
                                    ],)
                                    ), 

                                    /// Extraction
                                    TextfieldWithFixedValue(
                                    StringLabels.extraction,
                                    extractionYieldValue,
                                    width: 100.0,
                                    textAlign: TextAlign.center,
                                    ),

                                    Padding(padding: EdgeInsets.all(_padding / 2)),
                                ],
                                ),
                            ]),
                        ),
                        );
                    }
                    else{
                        extractionYieldValue = '';
                        render = BlankWidget();
                    }   
                    return render ?? BlankWidget();
                }
            )
    );
  }
}

class DoseYieldBrewControl extends StatefulWidget {
  final Function(BrewRatioType) _brewRatioTypeFunction;

  DoseYieldBrewControl(this._brewRatioTypeFunction);

  @override
  _DoseYieldBrewControlState createState() => _DoseYieldBrewControlState();
}

enum BrewRatioType { doseYield, doseBrewWeight }

class _DoseYieldBrewControlState extends State<DoseYieldBrewControl> {
  int _groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoSegmentedControl(
        groupValue: _groupValue,
        selectedColor: Theme.of(context).primaryColorLight,
        unselectedColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColorDark,
        onValueChanged: (intValue) {
          setState(() {
            assert(intValue < 2, 'Int value is too hight');
            _groupValue = intValue;
            switch (intValue) {
              case 0:
                widget._brewRatioTypeFunction(BrewRatioType.doseYield);
                break;
              case 1:
                widget._brewRatioTypeFunction(BrewRatioType.doseBrewWeight);
                break;
              default:
                Error();
            }
          });
        },
        children: {
          0: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Dose/Yield',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          1: Container(
              decoration:
                  BoxDecoration(borderRadius: new BorderRadius.circular(20.0)),
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Dose/Brew Weight',
                style: Theme.of(context).textTheme.button,
              ))
        });
  }
}

/// Notes card
class NotesCard extends StatefulWidget {
  final double _padding = 10.0;
  final double _margin = 10.0;
  final Item _item;

  NotesCard(this._item);
  _NotesCardState createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  TextEditingController controller;

  void initState() {
    controller = new TextEditingController(text: this.widget._item.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, _, ProfilePageModel model) =>
            StreamBuilder<Profile>(
                stream: model.profileStream,
                builder:
                    (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                  return Card(
                      child: Container(
                    constraints: BoxConstraints(minHeight: 50),
                    margin: EdgeInsets.all(widget._margin),
                    padding: EdgeInsets.all(widget._padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget._item.title),
                        Container(
                            child: TextField(
                                textInputAction: widget._item.textInputAction,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                enabled: ProfilePageModel.of(context).isEditing,
                                controller: controller,
                                textAlign: TextAlign.start,
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: StringLabels.enterInfo,
                                ),
                                onChanged: (value) => model.setProfileItemValue(
                                    widget._item.databaseId, value)))
                      ],
                    ),
                  ));
                }));
  }
}

import '../data/flavour_descriptors.dart';
import 'popups.dart';
import 'package:flutter_web/material.dart';
import '../data/strings.dart';
import '../theme/appColors.dart';
import '../data/profile.dart';
import '../data/database_functions.dart' ;
import '../data/images.dart';
import 'package:intl/intl.dart';
import '../data/item.dart';
import 'dart:async';
import '../data/mini_classes.dart';
import 'package:flutter_web/services.dart';
import '../data/functions.dart';
import 'package:flutter_web/widgets.dart';
import 'package:flutter_web/cupertino.dart';
import 'dart:io';
import '../pages/overview_page/profile_list.dart';
import '../pages/overview_page/user_details_page.dart';
import '../pages/custom_scaffold.dart';


/// Background
class Pagebackground extends StatelessWidget {
  final AssetImage _image;

  Pagebackground(this._image);

  @override
  Widget build(BuildContext context) {
    /// Background
    return new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: _image,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class NoDataIndicator extends StatelessWidget {
  final Widget child;

  NoDataIndicator({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Icon(Icons.no_sim),
          ),
          Container(
            margin: EdgeInsets.all(20.0),
            child: Text(
              'No Data',
              style: Theme.of(context).textTheme.display3,
            ),
          ),
        ],
      );
}

class BlankWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 0, height: 0);
  }
}

/// Dial in logo
class DialInLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Image.asset('assets/images/dial_in_logo_nobg.png',
          height: 200.0, width: 250.0),
    );
  }
}

///Text Field entry
class TextFieldEntry extends StatefulWidget {
    final String _placeholder;
    final bool _obscureText;
    final TextEditingController _controller;
    final TextInputType textInputType;

    TextFieldEntry(this._placeholder, this._controller, this._obscureText, { this.textInputType});

    @override
    _TextFieldEntryState createState() => new _TextFieldEntryState();
}
class _TextFieldEntryState extends State<TextFieldEntry> {

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            width: 200.0,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(0.0),
            alignment: const Alignment(0.0, 0.0),
            child: TextFormField(
                keyboardType: widget.textInputType,
                obscureText: widget._obscureText,
                controller: widget._controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(const Radius.circular(10.0))),
                filled: true,
                hintText: widget._placeholder,
                hintStyle: TextStyle(color: Colors.black38),
                // fillColor: AppColors.getColor(Colo)
                )));
  }
}

class CircularFadeInAssetNetworkImage extends StatelessWidget {
    final String _image;
    final String _placeHolder;
    final double _size;

    CircularFadeInAssetNetworkImage(
        this._image,
        this._placeHolder,
        this._size,
    );

    @override
    Widget build(BuildContext context) {
        return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
                BoxShadow(
                color: Colors.black,
                offset: new Offset(0.0, 2.0),
                blurRadius: 2.0,
                )
            ],
            shape: BoxShape.circle),
        height: _size,
        width: _size,
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: new BorderRadius.circular(_size),
            child: FadeInImage.assetNetwork(
                fit: BoxFit.cover, placeholder: _placeHolder, image: _image)),
        );
    }
}

class ShapedBox extends StatelessWidget {
    final Widget _child;
    final double _size;
    final Shape _shape;

    ShapedBox(this._child, this._size, this._shape);

    @override
    Widget build(BuildContext context) {
        BorderRadius border;
        BoxShape shape;

        switch (_shape) {
        case Shape.circle:
            border = BorderRadius.circular(_size);
            shape = BoxShape.circle;
            break;
        case Shape.square:
            shape = BoxShape.rectangle;
            border = BorderRadius.vertical();
            break;
        }

        return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
                BoxShadow(
                color: Colors.black45,
                offset: new Offset(0.0, 2.0),
                blurRadius: 3.0,
                )
            ],
            shape: shape),
        height: _size,
        width: _size,
        child: ClipRRect(borderRadius: border, child: _child),
        );
    }
}

class CircularCachedProfileImage extends StatelessWidget {
    final double _size;
    final dynamic _imageUrl;
    final String _heroTag;
    final String _placeholder;

    CircularCachedProfileImage(
        this._placeholder, this._imageUrl, this._size, this._heroTag);

    @override
    Widget build(BuildContext context) {
        Widget _child = BlankWidget();

        if (_imageUrl == null || _imageUrl == '') {
        _child = Image.asset(_placeholder);
        } else if (_imageUrl is String) {
        _child = CachedNetworkImage(
            placeholder: (BuildContext context, String string) =>
                Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Container(
                    color: Colors.white54,
                    )),
            errorWidget: (BuildContext context, String message, Object error) =>
                Image.asset(_placeholder, key: Key('placeholder')),
            imageUrl: _imageUrl,
            fit: BoxFit.cover,
        );
        } else {
        _child = Image.asset(_placeholder);
        }

        assert(_child != null, 'Child is null');

        return Hero(
            key: UniqueKey(),
            tag: _heroTag,
            child: ShapedBox(_child, _size, Shape.circle));
    }
}

class StanderdShimmer extends StatelessWidget {
    final Widget child;

    StanderdShimmer({Key key, @required this.child}) : super(key: key);

    @override
    Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.black26, highlightColor: Colors.black87, child: child);
}

class UserDetailsCachedProfileImage extends StatelessWidget {
    final double _size;
    final UserDetails _userDetails;

    UserDetailsCachedProfileImage(this._userDetails, this._size);

    @override
    Widget build(BuildContext context) {
        Widget _child = CachedNetworkImage(
            placeholder: (BuildContext context, String string) =>
                Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Container(
                    color: Colors.white54,
                    )),
            errorWidget: (BuildContext context, String message, Object error) =>
                Image.asset(Images.user),
            imageUrl: _userDetails.photoUrl ?? Images.userFirebase,
            fit: BoxFit.cover);

        return ShapedBox(_child, _size, Shape.circle);
    }
}

class RoundedTextButton extends StatelessWidget {
    final String text;
    final Function action;

    RoundedTextButton({Key key, @required this.text, @required this.action})
        : super(key: key);

    @override
    Widget build(BuildContext context) => Center(
        child: Container(
            width: 250,
            child: RaisedButton(
                padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: AppColors.getColor(ColorType.primarySwatch),
                child: Text(text,
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25.0)
                        .apply(color: Colors.white)),
                onPressed: action)));
}

class CoverProfileCachedImage extends StatelessWidget {
    final String _herotag;
    final Profile _profile;
    CoverProfileCachedImage(this._profile, this._herotag);

    @override
    Widget build(BuildContext context) => Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
            BoxShadow(
                color: Colors.black45,
                offset: new Offset(0.0, 2.0),
                blurRadius: 3.0,
            )
            ],
        ),
        key: UniqueKey(),
        child: Hero(
            key: UniqueKey(),
            tag: _herotag,
            child: CachedNetworkImage(
                placeholder: (BuildContext context, String string) =>
                    Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey,
                        child: Container(
                        color: Colors.white54,
                        )),
                errorWidget: (BuildContext context, String message, Object error) =>
                    Image.asset(_profile.placeholder),
                imageUrl: _profile.imageUrl,
                fit: BoxFit.cover,
            )));
}


class ImageLocalNetwork extends StatefulWidget {
    final String _imageUrl;
    final String _imagePath;
    final double _size;
    final Shape _shape;
    final String _placeHolder;

    ImageLocalNetwork(this._imageUrl, this._size, this._shape, this._imagePath,
        this._placeHolder);
    _ImageLocalNetworkState createState() => _ImageLocalNetworkState();}
    class _ImageLocalNetworkState extends State<ImageLocalNetwork> {
    final BehaviorSubject<Widget> _widgetStreamController =
        new BehaviorSubject<Widget>();

    void initState() {
        super.initState();
        _returnImageWidget();
    }

    @override
    void didUpdateWidget(ImageLocalNetwork oldWidget) {
        _returnImageWidget();
        super.didUpdateWidget(oldWidget);
    }

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        _returnImageWidget();
    }

    _returnImageWidget() async {
        if (widget._imagePath != null && widget._imagePath != '') {
        if (await File(widget._imagePath).exists()) {
            _widgetStreamController.add(Image.file(
            File(widget._imagePath),
            fit: BoxFit.cover,
            ));
        }
        } else if (widget._imageUrl != null && widget._imageUrl != '') {
        _widgetStreamController.add(FadeInImage.assetNetwork(
            image: widget._imageUrl,
            placeholder: widget._placeHolder,
            fit: BoxFit.cover,
        ));
        } else {
        _widgetStreamController.add(Image.asset(Images.user));
        }
  }

    Widget setupWidgetView(SnapShotDataState dataState,
        AsyncSnapshot<Widget> snapshot, Shape shape) {
        Widget _placeholder = shape == Shape.circle
            ? CircularProgressIndicator()
            : LinearProgressIndicator();
        Widget _returnWidget;

        switch (dataState) {
        case SnapShotDataState.waiting:
            _returnWidget = ShapedBox(_placeholder, widget._size, shape);
            break;
        case SnapShotDataState.noData:
            _returnWidget =
                ShapedBox(Icon(Icons.error_outline), widget._size, shape);
            break;
        case SnapShotDataState.hasdata:
            _returnWidget = ShapedBox(snapshot.data, widget._size, shape);
            break;
        case SnapShotDataState.hasError:
            print(snapshot.error);
            throw (snapshot.error);
            break;
        }
        assert(_returnWidget != null, '_return widdget is null');
        return _returnWidget;
    }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Widget>(
        stream: _widgetStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          switch (snapshot.hasError) {
            case true:
              return setupWidgetView(
                  SnapShotDataState.hasError, snapshot, widget._shape);
            case false:
              switch (snapshot.hasData) {
                case false:
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      break;
                    case ConnectionState.active:
                      return setupWidgetView(
                          SnapShotDataState.noData, snapshot, widget._shape);
                    case ConnectionState.waiting:
                      return setupWidgetView(
                          SnapShotDataState.waiting, snapshot, widget._shape);
                    case ConnectionState.done:
                      break;
                  }
                  break;

                case true:
                  return setupWidgetView(
                      SnapShotDataState.hasdata, snapshot, widget._shape);
                default:
              }
          }
        });
  }
}

enum Shape { square, circle }

class ProfilePicture extends StatelessWidget {
    final Profile _profile;
    final double _size;
    final Shape _shape;

    ProfilePicture(this._profile, this._size, this._shape);

    @override
    Widget build(BuildContext context) {
        return ImageLocalNetwork(_profile.imageUrl, _size, _shape,
            _profile.imageUrl, _profile.placeholder);
    }
}

class FadeInImageAssetNetworkFromProfile extends StatelessWidget {
    final Profile _profile;
    FadeInImageAssetNetworkFromProfile(this._profile);

    @override
    Widget build(BuildContext context) => FadeInImage.assetNetwork(
        fit: BoxFit.cover,
        placeholder: _profile.getImagePlaceholder(),
        image: _profile.imageUrl);
}

/// Action button
class ActionButton extends StatelessWidget {
    final String _buttonTitle;
    final Function _buttonAction;

    ActionButton(this._buttonTitle, this._buttonAction);

    Widget build(BuildContext context) {
        return RaisedButton(
            padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: AppColors.getColor(ColorType.primarySwatch),
            child: Text(_buttonTitle,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25.0)
                    .apply(color: Colors.white)),
            onPressed: _buttonAction);
    }
}

///Segmented control button
class SegmentControlButton extends StatelessWidget {
    final String text;
    // final Image image;

    SegmentControlButton(this.text);

    @override
    Widget build(BuildContext context) {
        return Container(
        width: 50.0,
        height: 50.0,
        child: RawMaterialButton(
            onPressed: () => {},
            child: Column(
            children: <Widget>[
                Icon(Icons.add),
                Text(text, style: TextStyle(fontSize: 10.0))
            ],
            ),
        ),
        );
    }
}

/// Usercard
class UserCard extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
            ///
            /// User Image
            ///
            Container(
                child: Center(
                    child: CircularFadeInAssetNetworkImage(
                        'assets/images/user.png', Images.user, 100.0))),

            Column(
                children: <Widget>[
                ///
                /// User name text
                ///
                Container(
                    margin: EdgeInsets.all(20.0),
                    child: Text(
                        StringLabels.userName,
                        style: TextStyle(fontSize: 20.0),
                    )),

                Container(
                    child: Row(
                    children: <Widget>[
                        ///
                        /// Brew count
                        ///
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child:

                                /// Title
                                Column(children: <Widget>[
                            Text(StringLabels.brewCount),

                            /// Value
                            CountLabel('B')
                            ])),

                        ///
                        ///Bean stash
                        ///
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child:

                                ///Title
                                Column(children: <Widget>[
                            Text(StringLabels.beanStash),

                            /// Value
                            CountLabel('C')
                            ]))
                    ],
                    ),
                )
                ],
            )
            ]));
    }
}


class ScalableWidget extends FittedBox {
    ScalableWidget(Widget child) : super(child: child, fit: BoxFit.scaleDown);
}


class TextFieldItemLauncher extends StatefulWidget {
  
  final Item _item;
  final Function _action;

  TextFieldItemLauncher(this._item, this._action, {Key key}) : super(key: key);
  @override
  _TextFieldItemLauncherState createState() => _TextFieldItemLauncherState();}
  class _TextFieldItemLauncherState extends State<TextFieldItemLauncher> {

    final TextEditingController _controller = new TextEditingController();
    final double _padding = 10.0;
    final double _margin = 5.0;
    final double _cornerRadius = 20.0;
    final double _textFieldWidth = 150.0;
    final FocusNode _focus = new FocusNode();

    void _handleFocus(){
        if (_focus.hasFocus){
        widget._action();
        _focus.unfocus();
        }
    }

    void initState() { 
        super.initState();
        _controller.text = widget._item.value;
    }

    @override
    Widget build(BuildContext context) {
        _focus.addListener(_handleFocus);
        _controller.text = widget._item.value;

        return Expanded(
            flex: 5,
            child: Container(
                alignment: Alignment(-1, -1),
                margin: EdgeInsets.all(
                _margin,
                ),
                child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                enabled: ProfilePageModel.of(context).isEditing,
                textAlign: TextAlign.start,
                decoration: new InputDecoration(
                    labelText: widget._item.title,
                ),
                focusNode: _focus,
                controller: _controller,
                )));
    }
}

///RatioTextField Item input
class RatioTextFieldItemWithInitalValue extends StatefulWidget {
    final Item _item;
    final TextAlign textAlign;

    RatioTextFieldItemWithInitalValue(this._item,
        {this.textAlign = TextAlign.center});

    _RatioTextFieldItemWithInitalValueState createState() =>
        _RatioTextFieldItemWithInitalValueState();
}

class _RatioTextFieldItemWithInitalValueState
    extends State<RatioTextFieldItemWithInitalValue> {
    BlacklistingTextInputFormatter _spaceBlacklistingTextInputFormatter =
        BlacklistingTextInputFormatter(RegExp(' '), replacementString: '');
    BlacklistingTextInputFormatter _commaBlacklistingTextInputFormatter =
        BlacklistingTextInputFormatter(RegExp(','), replacementString: '.');
    WhitelistingTextInputFormatter _whitelistingTextInputFormatter =
        WhitelistingTextInputFormatter(RegExp('[0-9,.]'));
    List<TextInputFormatter> _inputFormatters = List<TextInputFormatter>();
    TextEditingController _controller;
    FocusNode _focusNode = new FocusNode();
    final double _textFieldWidth = 30.0;

    @override
    void initState() {
        _inputFormatters = [
        _commaBlacklistingTextInputFormatter,
        _spaceBlacklistingTextInputFormatter,
        _whitelistingTextInputFormatter
        ];
        _controller = new TextEditingController(text: widget._item.value);
        _focusNode.addListener(_focusNodeListenerFunction);
        super.initState();
    }

    void unfocus() {
        _focusNode.unfocus();
    }

    void _focusNodeListenerFunction() {
        if (!_focusNode.hasFocus) {
        _controller.text = widget._item.value.toString();
        }
    }

    @override
    Widget build(BuildContext context) {
        return ScopedModelDescendant<ProfilePageModel>(
            rebuildOnChange: true,
            builder: (BuildContext context, _, ProfilePageModel model) {
            return StreamBuilder<Profile>(
                stream: model.profileStream,
                builder: (BuildContext context, AsyncSnapshot<Profile> snapShot) {
                    if (model.isCalculating) {
                    _controller.text = snapShot.data.toString();
                    model.isCalculating = false;
                    }

                    _focusNodeListenerFunction();
                    return Expanded(
                        flex: 5,
                        child: Container(
                            width: _textFieldWidth,
                            padding: EdgeInsets.all(5.0),
                            margin: EdgeInsets.all(5.0),
                            child: TextField(
                                enabled: ProfilePageModel.of(context).isEditing,
                                focusNode: _focusNode,
                                inputFormatters:
                                    _inputFormatters ?? <TextInputFormatter>[],
                                controller: _controller,
                                textAlign: widget.textAlign,
                                keyboardType: widget._item.keyboardType,
                                decoration: new InputDecoration(
                                prefixIcon: widget._item.icon ?? null,
                                labelText: widget._item.title,
                                hintText: widget._item.placeHolderText,
                                ),
                                onChanged: (value) {
                                model.setProfileItemValue(
                                    widget._item.databaseId, value);
                                })));
                });
            });
    }
}

/// Five star rating
class FiveStarRating extends StatelessWidget {
    final int _score;
    final int _starCount = 5;

    FiveStarRating(this._score);

    @override
    Widget build(BuildContext context) {
        return Container(
        child: new StarRating(
            size: 25.0,
            rating: _score / 10,
            color: Colors.orange,
            borderColor: Colors.grey,
            starCount: _starCount),
        );
    }
}

/// Cout label
class CountLabel extends StatelessWidget {
    final String _text;

    CountLabel(this._text);

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.all(5.0),
            child: Text(
            _text,
            style: TextStyle(
                color: AppColors.getColor(ColorType.primarySwatch),
                fontSize: 25.0),
            ));
    }
}

/// Add floating action button
class AddButton extends StatelessWidget {
    final Function _onPressed;

    AddButton(this._onPressed);

    @override
    Widget build(BuildContext context) {
        return FloatingActionButton(
        onPressed: _onPressed,
        child: Icon(
            Icons.add,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
        ),
        );
    }
}

////////////////////////////////// Custom Classes ///////////////////////////////////////

// TimePicker textfield card
class TimePickerTextField extends StatefulWidget {
    final double _textFieldWidth;

    TimePickerTextField(this._textFieldWidth);

    _TimePickerTextFieldState createState() => _TimePickerTextFieldState();}
    class _TimePickerTextFieldState extends State<TimePickerTextField> {
    TextEditingController _controller;
    FocusNode _focus;
    TimerPickerModel _model;

    @override
    void initState() {
        _focus = new FocusNode();
        _focus.addListener(handleLeftProfileTextfieldFocus);
        _controller = new TextEditingController();
        _model = new TimerPickerModel(ProfilePageModel.of(context));
        super.initState();
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    void handleLeftProfileTextfieldFocus() {
        if (_focus.hasFocus) {
        if (ProfilePageModel.of(context).isEditing) {
            setState(() {
            PopUps.showTimePicker(context, _model);
            });
        }
        _focus.unfocus();
        }
    }

    @override
    Widget build(BuildContext context) {
        return ScopedModelDescendant(
            builder: (BuildContext context, _, ProfilePageModel model) =>
                StreamBuilder<Profile>(
                    stream: model.profileStream,
                    builder:
                        (BuildContext context, AsyncSnapshot<Profile> profile) {
                    if (profile.data == null) {
                        return Center(child: CircularProgressIndicator());
                    } else {
                        Item item = profile.data.getItem(DatabaseIds.time);
                        int time = Functions.getIntValue(item.value);
                        String timeString = Functions.convertSecsToMinsAndSec(time);

                        _controller.text = timeString;

                        return Expanded(
                            flex: 5,
                            child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: TextFormField(
                                enabled: ProfilePageModel.of(context).isEditing,
                                key: new Key(item.databaseId),
                                textAlign: TextAlign.start,
                                decoration: new InputDecoration(
                                    prefixIcon: Icon(Icons.timer),
                                    labelText: StringLabels.time,
                                ),
                                focusNode: _focus,
                                controller: _controller,
                                )));
                    }
                    }));
    }
}

//Picker textfield card
class PickerTextField extends StatefulWidget {
    final double _textFieldWidth;
    final Item _item;

    /// Returns a funtion with the Item
    /// of the item to open the picker view witht the correct data.

    PickerTextField(this._item, this._textFieldWidth);

    _PickerTextFieldState createState() => _PickerTextFieldState();
}

class _PickerTextFieldState extends State<PickerTextField> {
    TextEditingController _controller;
    FocusNode _focus;
    ProfilePageModel _model;

    @override
    void initState() {
        _focus = new FocusNode();
        _focus.addListener(handleLeftProfileTextfieldFocus);
        _controller = new TextEditingController(text: widget._item.value);
        super.initState();
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    void handleLeftProfileTextfieldFocus() {
        if (_focus.hasFocus) {
            PopUps.showPickerMenu(widget._item, context, _model);
        _focus.unfocus();
        setState(() {
            
        });
        }
    }

    @override
    void didChangeDependencies() {
        _controller.text = widget._item.value;
        super.didChangeDependencies();
    }

    @override
    Widget build(BuildContext context) {
        _controller.text = widget._item.value;
        _model = ProfilePageModel.of(context);

        return ScopedModelDescendant(
            builder: (BuildContext context, _, ProfilePageModel model) => Expanded(
                flex: 5,
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                    enabled: ProfilePageModel.of(context).isEditing,
                    key: new Key(widget._item.databaseId),
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration(
                        prefixIcon: widget._item.icon ?? null,
                        labelText: widget._item.title,
                    ),
                    focusNode: _focus,
                    controller: _controller,
                    ))));
    }
}

class TimePicker extends StatefulWidget {
    final TimerPickerModel _model;
    TimePicker(this._model);
    _TimePickerState createState() => _TimePickerState();}
    class _TimePickerState extends State<TimePicker> {
    double _itemHeight = 40.0;
    double _pickerHeight = 120.0;
    double _pickerWidth = 50.0;
    bool _initialised = false;
    FixedExtentScrollController _minuteController;
    FixedExtentScrollController _secondController;

    List<Widget> _minutes = new List<Widget>();
    List<Widget> _seconds = new List<Widget>();

    int tickerTimeMs = 500;

    void initState() {
        super.initState();
        widget._model.timeStream.listen(handleTimeChange);
        _minuteController =
            new FixedExtentScrollController(initialItem: widget._model.mins);
        _secondController =
            new FixedExtentScrollController(initialItem: widget._model.seconds);
        Screen.keepOn(true);
        setScollControllers();
    }

    void handleTimeChange(int time) {
        if (widget._model.timerIsActive) {
        setScollControllers();
        }
    }

    void setScollControllers() {
        _minuteController.animateToItem(widget._model.mins,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

        _secondController.animateToItem(widget._model.seconds,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }

    void _resetTimer() {
        widget._model.resetWatch();
        setScollControllers();
    }

    void initialise() {
        if (!_initialised) {
        Functions.oneToFiftynine().forEach((itemText) {
            _minutes.add(Center(
                child: Text(
            itemText.toString(),
            style: Theme.of(context).textTheme.display2,
            )));
        });
        Functions.oneToFiftynine().forEach((itemText) {
            _seconds.add(Center(
                child: Text(
            itemText.toString(),
            style: Theme.of(context).textTheme.display2,
            )));
        });
        _initialised = true;

        setScollControllers();
        }
    }

    @override
    void dispose() { 
        Screen.keepOn(false);
        super.dispose();
    }

    @override
    Widget build(BuildContext context) => StreamBuilder<int>(
        stream: widget._model.timeStream,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> time) => StreamBuilder<
                bool>(
            stream: widget._model.isTimerActiveStream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> active) {
                initialise();

                return StreamBuilder<bool>(
                    stream: widget._model.timerRunningStreamContoller,
                    initialData: false,
                    builder: (BuildContext context, AsyncSnapshot<bool> isRunning) {
                    return Container(
                        child: Container(
                            child: SizedBox(
                                height: 200.0,
                                width: double.infinity,
                                child: Column(children: <Widget>[
                                Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.black,
                                    color: Theme.of(context).accentColor,
                                    type: MaterialType.card,
                                    child: Container(
                                        height: 40.0,
                                        width: double.infinity,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                            FlatButton(
                                                onPressed: () => _resetTimer(),
                                                child: Icon(Icons.restore)),
                                            FlatButton(
                                                onPressed: () => isRunning.data
                                                    ? widget._model.stopWatch()
                                                    : widget._model.startWatch(),
                                                child: isRunning.data
                                                    ? Icon(Icons.stop)
                                                    : Icon(Icons.play_arrow)),
                                            Expanded(
                                                child: Container(),
                                            ),
                                            FlatButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Done')),
                                            ],
                                        ))),
                                SizedBox(
                                    height: 160.0,
                                    width: double.infinity,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                        /// Minutes picker
                                        Row(
                                            children: <Widget>[
                                            SizedBox(
                                                height: _pickerHeight,
                                                width: _pickerWidth,
                                                child: CupertinoPicker(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    scrollController:
                                                        _minuteController,
                                                    useMagnifier: true,
                                                    onSelectedItemChanged: (value) {
                                                    if (!isRunning.data) {
                                                        widget._model.mins = value;
                                                    }
                                                    },
                                                    itemExtent: _itemHeight,
                                                    children: _minutes),
                                            ),
                                            Text('m')
                                            ],
                                        ),

                                        Padding(padding: EdgeInsets.all(20.0)),

                                        /// Seconds picker
                                        Row(
                                            children: <Widget>[
                                            SizedBox(
                                                height: _pickerHeight,
                                                width: _pickerWidth,
                                                child: CupertinoPicker(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    scrollController:
                                                        _secondController,
                                                    useMagnifier: true,
                                                    onSelectedItemChanged: (value) {
                                                    if (!isRunning.data) {
                                                        widget._model.seconds =
                                                            value;
                                                    }
                                                    },
                                                    itemExtent: _itemHeight,
                                                    children: _seconds),
                                            ),
                                            Text('s'),
                                            ],
                                        )
                                        ],
                                    ))
                                ]))),
                    );
                    });
            }));
}

class CountryPickerDiolog extends StatelessWidget {
    final ProfilePageModel model;

    CountryPickerDiolog(this.model, {Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
        body: new Center(
            child: CountryPicker(
                dense: true,
                onChanged: (Country country) {
                    model.setProfileItemValue(DatabaseIds.country, country.name);
                },
                selectedCountry: Country.AQ
                //  Country.ALL.firstWhere((c) { return c.name ==  model.getItemValue(DatabaseIds.country) ?? Country.ZZ ;}
                )),
        );
    }
}

/// Popups


class ProfileListDiolog extends StatefulWidget {
    final ProfileType _profileType;
    final bool isOnOverviewScreeen;
    ProfileListDiolog(this._profileType, this.isOnOverviewScreeen);
    _ProfileListDiologState createState() => _ProfileListDiologState();}
    class _ProfileListDiologState extends State<ProfileListDiolog> {
    ScrollController _scrollController;

    void initState() {
        _scrollController = new ScrollController();
        super.initState();
    }

    void handleProfileselectionResult(dynamic result) {
        if (result is bool) {
        if (result != false) {
            Navigator.pop(context);
        }
        } else if (result is Profile) {
        Navigator.pop(context, result);
        }
    }

    void createNewProfilePage(ProfileType profileType) async {
        var result = await Routes.openProfilePage(
            context, '', profileType, false, true, false, false, true, '123412534');

        /// Result to be passed back
        handleProfileselectionResult(result);
    }

    @override
    Widget build(BuildContext context) => Container(
        color: AppColors.getColor(ColorType.primarySwatch),
        child: SafeArea(
            child: Material(
                color: AppColors.getColor(ColorType.lightBackground),
                child: new NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                        new SliverAppBar(
                            backgroundColor:
                                const Color.fromARGB(250, 209, 140, 92),
                            centerTitle: true,
                            brightness:
                                Theme.of(context).brightness == Brightness.light
                                    ? Brightness.dark
                                    : Brightness.light,
                            titleSpacing: 0,
                            automaticallyImplyLeading: false,
                            leading: RawMaterialButton(
                                child: Icon(
                                Icons.arrow_back,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                                ),
                                onPressed: () {
                                Navigator.pop(context, false);
                                },
                            ),
                            actions: <Widget>[
                                MaterialButton(
                                key: UniqueKey(),
                                onPressed: () =>
                                    createNewProfilePage(widget._profileType),
                                child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Colors.black,
                                ),
                                ),
                            ],
                            title: DataListFilterBar(false,
                                profileType: widget._profileType),
                            pinned: false,
                            floating: true,
                            forceElevated: innerBoxIsScrolled)
                        ];
                    },
                    body: Container(
                        height: 400.0,
                        width: 300.0,
                        child: ProfileList(
                            widget._profileType,
                            widget.isOnOverviewScreeen,
                            giveProfile: (sentProfile) {
                            handleProfileselectionResult(sentProfile);
                            },
                        ))))));
}

class DataListFilterBar extends StatelessWidget {
    final bool _fromOverviewScreen;
    final double _padding = 6;
    final ProfileType profileType;

    DataListFilterBar(this._fromOverviewScreen, {this.profileType});

    @override
    Widget build(BuildContext context) {
        var searchbar = _fromOverviewScreen
            ? new DataListSearchBar()
            : ProfileListSearchBar(profileType);
        var sortingbutton = _fromOverviewScreen
            ? DataListSortingOptionsButton()
            : ProfileListSortingOptionsButton(profileType);

        return Container(
            key: UniqueKey(),
            height: 60,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Padding(padding: EdgeInsets.all(3)),
                Icon(Icons.search,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white54
                        : Colors.black54),
                Padding(padding: EdgeInsets.all(4)),
                searchbar,
                Padding(padding: EdgeInsets.all(_padding)),
                sortingbutton,
                Padding(padding: EdgeInsets.all(3)),
                ],
            ),
        );
    }
}

class ProfileListSearchBar extends StatefulWidget {
  final ProfileType _profileType;

  ProfileListSearchBar(this._profileType);
  _ProfileListSearchBarState createState() => _ProfileListSearchBarState();
}
class _ProfileListSearchBarState extends State<ProfileListSearchBar> {
    final Key _k1 = new Key('profile search bar input text');
            static final _orderFormKey = GlobalKey<FormFieldState<String>>();

    @override
    Widget build(BuildContext context) => Expanded(
        key: UniqueKey(),
        child: TextField(
            key: _orderFormKey,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white54
                    : Colors.black54),
            onChanged: (value) => MainBloc.of(context)
                .overviewBloc
                .profileDataList(widget._profileType)
                .sendQuery = value,
            decoration: InputDecoration.collapsed(
                hintText: MainBloc.of(context)
                        .overviewBloc
                        .profileDataList(widget._profileType)
                        .title ??
                    '',
                hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white54
                        : Colors.black54)),
        ));
}

class DataListSearchBar extends StatefulWidget {
  @override
  _DataListSearchBarState createState() => _DataListSearchBarState();
}
class _DataListSearchBarState extends State<DataListSearchBar> {
 
    static final _orderFormKey = GlobalKey<FormFieldState<String>>();

    @override
    Widget build(BuildContext context) => ScopedModelDescendant<MainBloc>(
        rebuildOnChange: false,
        builder: (BuildContext context, _, model) => Expanded(
            key: UniqueKey(),
            child: StreamBuilder<int>(
                stream: model.overviewBloc.getCurrentProfileDataListStream(),
                initialData: 0,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    bool checkModel() {
                    return model.overviewBloc.dataLists == null ||
                        model.overviewBloc.dataLists.length < 1;
                    }

                    return TextField(
                            key: _orderFormKey,
                            style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.white70
                                    : Colors.black87),
                            onChanged: (String value) => checkModel()
                                ? () {}
                                : model.overviewBloc.dataLists[snapshot.data].sendQuery =
                                    value,
                            decoration: InputDecoration.collapsed(
                                hintText: checkModel()
                                    ? ''
                                    : model.overviewBloc.dataLists[snapshot.data].title ??
                                        '',
                                hintStyle: TextStyle(
                                    color:
                                        Theme.of(context).brightness == Brightness.light
                                            ? Colors.white54
                                            : Colors.black54)
                            ),
                    );
                }
            )
        )
    );
}

class DataListSortingOptionsButton extends StatelessWidget {
    @override
    Widget build(BuildContext context) => ScopedModelDescendant<MainBloc>(
        builder: (BuildContext context, _, model) => StreamBuilder<int>(
            stream: model.overviewBloc.getCurrentProfileDataListStream(),
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (model.overviewBloc.dataLists == null ||
                    model.overviewBloc.dataLists.length < 1) {
                return MaterialButton(
                    key: UniqueKey(), child: Text(''), onPressed: () {});
                } else {
                return StreamBuilder<ListSortingOptions>(
                    stream: model
                        .overviewBloc.dataLists[snapshot.data].sortTypeStream,
                    initialData: ListSortingOptions.mostRecent,
                    builder: (BuildContext context,
                        AsyncSnapshot<ListSortingOptions> sortType) {
                        bool checkModel() {
                        return model.overviewBloc.dataLists == null ||
                            model.overviewBloc.dataLists.length < 1;
                        }

                        return Container(
                            key: UniqueKey(),
                            margin: EdgeInsets.all(3),
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: RawMaterialButton(
                                    constraints:
                                        BoxConstraints(maxHeight: 10, maxWidth: 10),
                                    shape: CircleBorder(),
                                    fillColor: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white70
                                        : Colors.black87,
                                    key: UniqueKey(),
                                    child: Text(
                                    Functions.getIconValueOfSortingMethod(
                                        sortType.data),
                                    style: TextStyle(
                                        color: AppColors.getColor(
                                            ColorType.primarySwatch),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 10,
                                    ),
                                    ),
                                    onPressed: () => PopUps.selectSortTypeDiolog(
                                        context,
                                        checkModel()
                                            ? () {}
                                            : model
                                                .overviewBloc
                                                .dataLists[snapshot.data]
                                                .setSortType, 
                                                options: ListSortingOptions.values.toSet()))));
                    });
                }
            }));
}

class ProfileListSortingOptionsButton extends StatelessWidget {
    final ProfileType _profileType;

    ProfileListSortingOptionsButton(this._profileType);

    @override
    Widget build(BuildContext context) => StreamBuilder<ListSortingOptions>(
        stream: MainBloc.of(context)
            .overviewBloc
            .profileDataList(_profileType)
            .sortTypeStream,
        initialData: ListSortingOptions.mostRecent,
        builder: (BuildContext context, AsyncSnapshot<ListSortingOptions> sortType) {
        return Container(
            key: UniqueKey(),
            margin: EdgeInsets.all(2),
            child: AspectRatio(
                aspectRatio: 1,
                child: RawMaterialButton(
                    constraints: BoxConstraints(maxHeight: 10, maxWidth: 10),
                    shape: CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.white70
                        : Colors.black87,
                    key: UniqueKey(),
                    child: Text(
                      Functions.getIconValueOfSortingMethod(sortType.data),
                      style: TextStyle(
                        color: AppColors.getColor(ColorType.primarySwatch),
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                    ),
                    onPressed: () => PopUps.selectSortTypeDiolog(
                        context,
                        MainBloc.of(context)
                            .overviewBloc
                            .profileDataList(_profileType)
                            .setSortType, 
                            options: ListSortingOptions.values.toSet()))));
        }
    );
}

class ForgottonPasswordDialog extends StatefulWidget {
  _ForgottonPasswordDialogState createState() =>
      _ForgottonPasswordDialogState();
}

class _ForgottonPasswordDialogState extends State<ForgottonPasswordDialog> {
  TextEditingController _controller = new TextEditingController();

    void submitButtonPressed() async {
        String message = await Dbf.forgottonPassword(_controller.text.trim());
        PopUps.showAlert('Submitted', message, 'OK', finishAction, context);
    }

    void finishAction() {
        Navigator.pop(context);
        Navigator.pop(context);
    }

    @override
    Widget build(BuildContext context) => SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            titlePadding: EdgeInsets.all(20),
            title: Text('Reset Password'),
            contentPadding: EdgeInsets.all(20),
            children: <Widget>[
                Text('Enter your email address'),
                TextField(
                controller: _controller,
                ),
                Padding(padding: EdgeInsets.all(20)),
                RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                key: Key('Submit button'),
                onPressed: submitButtonPressed,
                child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                ),
                )
            ]);
}

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
                    color: Colors.black,
                    blurRadius: 1.0, // has the effect of softening the shadow
                    spreadRadius: 1.0, // has the effect of extending the shadow
                    offset: Offset(
                    1.0, // horizontal, move right 10
                    1.0, // vertical, move down 10
                    ),
                )
                ], borderRadius: BorderRadius.circular(_cornerRadius)),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(_cornerRadius)),
                    child: Image.asset(
                    Images.cherries,
                    fit: BoxFit.cover,
                    )));
    }
}

/// Date input card
class DateTimeInputCard extends StatefulWidget {
    final double _padding = 10.0;
    final double _margin = 10.0;
    final String dateFormat;
    final DateTime _dateTime;
    final Function(DateTime) onDateChanged;
    final String _title;

    DateTimeInputCard(this._title, this._dateTime, this.onDateChanged,
        {this.dateFormat = "MMMM d, yyyy 'at' h:mma"});

    _DateTimeInputCardState createState() => new _DateTimeInputCardState();
}

class _DateTimeInputCardState extends State<DateTimeInputCard> {
    TextEditingController _controller = new TextEditingController();
    FocusNode _focus = new FocusNode();
    DateFormat _dateFormat;

    @override
    void initState() {
        _dateFormat = DateFormat(widget.dateFormat);
        _controller.text = _dateFormat.format(widget._dateTime);
        _focus = new FocusNode();
        _focus.addListener(handleTextfieldFocus);
        super.initState();
    }

    @override
    void didUpdateWidget(DateTimeInputCard oldWidget) {
        _controller.text = _dateFormat.format(widget._dateTime);
        super.didUpdateWidget(oldWidget);
    }

    void handleTextfieldFocus() async {
        if (_focus.hasFocus) {
        DateTime date = await getDateTimeInput(
            context, widget._dateTime, TimeOfDay.fromDateTime(widget._dateTime));
        setState(() {
            if (date != null) {
            _controller.text = _dateFormat.format(date);
            widget.onDateChanged(date);
            _focus.unfocus();
            }
        });
        }
    }

    Future<DateTime> getDateTimeInput(
        BuildContext context, DateTime initialDate, TimeOfDay initialTime) async {
        var date = await showDatePicker(
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        context: context,
        initialDate: initialDate,
        );
        if (date != null) {
        final time = await showTimePicker(
            context: context,
            initialTime: initialTime ?? TimeOfDay.now(),
        );
        if (time != null) {
            date = date.add(Duration(hours: time.hour, minutes: time.minute));
        }
        }
        return date;
    }

    @override
    Widget build(BuildContext context) {
        return Card(
        child: Container(
            padding: EdgeInsets.all(widget._padding),
            margin: EdgeInsets.all(widget._margin),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Expanded(
                        child: TextFormField(
                            enabled: ProfilePageModel.of(context).isEditing,
                            controller: _controller,
                            focusNode: _focus,
                            decoration: InputDecoration(
                                icon: Icon(Icons.date_range),
                                labelText: widget._title),
                        ),
                        ),
                    ],
                    ),
                ])),
        );
    }
}

class DateTimeTextField extends StatefulWidget {
    final double _padding = 10.0;
    final double _margin = 10.0;
    final String dateFormat;
    final bool justDate;
    final DateTime _dateTime;
    final Function(DateTime) onDateChanged;
    final String _title;

    DateTimeTextField(this._title, this._dateTime, this.onDateChanged,
        {this.dateFormat = "MMMM d, yyyy 'at' h:mma", this.justDate = false});

  _DateTimeTextFieldState createState() => new _DateTimeTextFieldState();}
  class _DateTimeTextFieldState extends State<DateTimeTextField> {
    TextEditingController _controller = new TextEditingController();
    FocusNode _focus = new FocusNode();
    DateFormat _dateFormat;

    @override
    void initState() {
        _dateFormat = DateFormat(widget.dateFormat);
        _controller.text = _dateFormat.format(widget._dateTime);
        _focus = new FocusNode();
        _focus.addListener(handleTextfieldFocus);
        super.initState();
    }

    @override
    void didUpdateWidget(DateTimeTextField oldWidget) {
        _controller.text = _dateFormat.format(widget._dateTime);
        super.didUpdateWidget(oldWidget);
    }

    void handleTextfieldFocus() async {
        if (_focus.hasFocus) {
        DateTime date = await getDateTimeInput(
            context, widget._dateTime, TimeOfDay.fromDateTime(widget._dateTime));
        setState(() {
            if (date != null) {
            _controller.text = _dateFormat.format(date);
            widget.onDateChanged(date);
            _focus.unfocus();
            }
        });
        }
    }

    Future<DateTime> getDateTimeInput(
        BuildContext context, DateTime initialDate, TimeOfDay initialTime) async {
        var date = await showDatePicker(
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        context: context,
        initialDate: initialDate,
        );
        if (!widget.justDate) {
        if (date != null) {
            final time = await showTimePicker(
            context: context,
            initialTime: initialTime ?? TimeOfDay.now(),
            );
            if (time != null) {
            date = date.add(Duration(hours: time.hour, minutes: time.minute));
            }
        }
        }
        return date;
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(5.0),
            child: TextField(
            enabled: ProfilePageModel.of(context).isEditing,
            controller: _controller,
            focusNode: _focus,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.date_range), labelText: widget._title),
            ));
    }
}

///TextField Value input
class TextFieldWithInitalValue extends StatefulWidget {
    final _textFieldWidth;
    final Function(dynamic) _giveValue;
    final dynamic _initalValue;
    final String _titleLabel;
    final String _hintText;
    final TextInputType _inputType;
    final bool _isEditing;

    TextFieldWithInitalValue(
        this._inputType,
        this._titleLabel,
        this._hintText,
        this._initalValue,
        this._giveValue,
        this._textFieldWidth,
        this._isEditing);

    _TextFieldWithInitalValueState createState() =>
        _TextFieldWithInitalValueState();
}

class _TextFieldWithInitalValueState extends State<TextFieldWithInitalValue> {
    TextEditingController _controller;

    @override
    void initState() {
        _controller =
            new TextEditingController(text: widget._initalValue.toString());
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            width: widget._textFieldWidth,
            child: TextField(
            enabled: widget._isEditing,
            controller: _controller,
            textAlign: TextAlign.start,
            keyboardType: widget._inputType,
            decoration: new InputDecoration(
                labelText: widget._titleLabel,
                hintText: widget._hintText,
            ),
            onChanged: widget._giveValue,
            ));
    }
}

///TextField Item input
class TextFieldItemWithInitalValue extends StatefulWidget {
    final double width;
    final Item _item;
    final List<TextInputFormatter> textInputFormatters;
    final TextAlign textAlign;

    TextFieldItemWithInitalValue(
        this._item,
        {
        this.width = 140, 
        this.textInputFormatters,
        this.textAlign = TextAlign.start,
    });

    _TextFieldItemWithInitialValueState createState() =>
        _TextFieldItemWithInitialValueState();
}

class _TextFieldItemWithInitialValueState
    extends State<TextFieldItemWithInitalValue> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = new TextEditingController(text: widget._item.value.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, _, ProfilePageModel model) => Expanded(
            flex: 5,
            child: Container(
                width: widget.width,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.all(5.0),
                child: TextField(
                    enabled: ProfilePageModel.of(context).isEditing,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: false,
                    inputFormatters:
                        widget.textInputFormatters ?? <TextInputFormatter>[],
                    controller: _controller,
                    textAlign: widget.textAlign,
                    keyboardType: widget._item.keyboardType,
                    decoration: new InputDecoration(
                      prefixIcon: widget._item.icon ?? null,
                      labelText: widget._item.title,
                      hintText: widget._item.placeHolderText,
                    ),
                    onChanged: (value) => setState(() {
                          if (widget._item.databaseId ==
                                  DatabaseIds.brewingDose ||
                              widget._item.databaseId == DatabaseIds.yielde ||
                              widget._item.databaseId ==
                                  DatabaseIds.brewWeight) {
                            model.setProfileItemValue(widget._item.databaseId,
                                value.split('').reversed.join());
                          } else if (widget._item.databaseId ==
                              DatabaseIds.tds) {
                            if (Functions.countChacters(value, '.') > 1) {
                              PopUps.showAlert(
                                  StringLabels.error,
                                  'Only one decimel can be used.',
                                  StringLabels.ok, () {
                                Navigator.pop(context);
                              }, context);
                            }
                            model.setProfileItemValue(
                                widget._item.databaseId, value);
                          } else {
                            model.setProfileItemValue(
                                widget._item.databaseId, value);
                          }
                        })))));
  }
}

///TextField Item input
class TextFieldSpanItemWithInitalValue extends StatefulWidget {
    final Function(dynamic) _giveValue;
    final Item _item;

    TextFieldSpanItemWithInitalValue(
        this._item,
        this._giveValue,
    );

    _TextFieldSpanItemWithInitalValueState createState() =>
        _TextFieldSpanItemWithInitalValueState();
    }

    class _TextFieldSpanItemWithInitalValueState
        extends State<TextFieldSpanItemWithInitalValue> {
    TextEditingController _controller;

    @override
    void initState() {
        _controller = new TextEditingController(text: widget._item.value);
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            child: TextField(
        controller: _controller,
        textAlign: TextAlign.start,
        keyboardType: widget._item.keyboardType,
        decoration: new InputDecoration(
            labelText: widget._item.title,
            hintText: widget._item.placeHolderText,
        ),
        onChanged: widget._giveValue,
        ));
    }
}

///TextfieldWithFixedValue
class TextfieldWithFixedValue extends StatefulWidget {
    final dynamic _initalValue;
    final String _titleLabel;
    final double width;
    final TextAlign textAlign;
    final double labelFontSize;

    TextfieldWithFixedValue(this._titleLabel, this._initalValue, {this.width, this.textAlign, this.labelFontSize});

    _TextfieldWithFixedValueState createState() =>
        _TextfieldWithFixedValueState();
}

class _TextfieldWithFixedValueState extends State<TextfieldWithFixedValue> {
    TextEditingController _controller = new TextEditingController();

    @override
    void didUpdateWidget(TextfieldWithFixedValue oldWidget) {
        _controller.text = widget._initalValue.toString();
        super.didUpdateWidget(oldWidget);
    }

    @override
    Widget build(BuildContext context) {
        _controller.text = widget._initalValue.toString();
        return Container(
            width: widget.width ?? 100.0,
            child: TextFormField(
            controller: _controller,
            enabled: false,
            textAlign: widget.textAlign ?? TextAlign.center,
            decoration: new InputDecoration(
                enabled: false,
                labelText: widget._titleLabel,
                // labelStyle: TextStyle(fontSize: 10.0)
            )
            )
        );
    }
}

/// Follow  button
class FollowButton extends StatefulWidget {
    final String userId;
    FollowButton(this.userId);
    _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
    final double _unfollowBorder = 2;
    final double _paddingVert = 10;
    final double _paddingHori = 3;
    final double _shadowBlur = 1;

    @override
    Widget build(BuildContext context) {
        return ScopedModelDescendant<MainBloc>(
            rebuildOnChange: true,
            builder: (context, _, model) => StreamBuilder<UserProfile>(
                stream: model.userProfileStream,
                builder:
                    (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
                bool isUserFollowing = model.isUserFollowing(widget.userId);
                BoxShadow shadow = new BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 0.1),
                    blurRadius: _shadowBlur);
                Color buttonColor =
                    Theme.of(context).brightness == Brightness.light
                        ? isUserFollowing
                            ? Colors.white
                            : Theme.of(context).accentColor
                        : isUserFollowing
                            ? Colors.black
                            : Theme.of(context).accentColor;

                BoxDecoration decoration = isUserFollowing
                    ? BoxDecoration(
                        border: new Border.all(
                            color: Theme.of(context).primaryColor,
                            width: _unfollowBorder,
                        ),
                        color: buttonColor,
                        boxShadow: [shadow],
                        borderRadius: new BorderRadius.circular(25.0))
                    : BoxDecoration(
                        color: buttonColor,
                        boxShadow: [shadow],
                        borderRadius: new BorderRadius.circular(25.0));

                return InkWell(
                    key: UniqueKey(),
                    onTap: () {
                        MainBloc.of(context)
                            .followOrUnfollow(widget.userId, ((isFollowing) {}));
                    },
                    child: AnimatedContainer(
                        curve: Curves.elasticIn,
                        duration: Duration(milliseconds: 10),
                        width: 80,
                        padding: EdgeInsets.symmetric(
                            horizontal: _paddingHori, vertical: _paddingVert),
                        decoration: decoration,
                        child: new Center(
                            child: new ScalableWidget(
                        Text(
                            isUserFollowing
                                ? StringLabels.unFollow
                                : StringLabels.follow,
                            style: TextStyle(
                            fontWeight: isUserFollowing
                                ? FontWeight.w600
                                : FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? isUserFollowing
                                        ? Theme.of(context).accentColor
                                        : Colors.white
                                    : isUserFollowing
                                        ? Theme.of(context).accentColor
                                        : Colors.black,
                            ),
                        ),
                        )),
                    ));
                }));
    }
}

class FeedRefresher extends StatelessWidget {
    final RefreshController _refreshController = new RefreshController();
    final Widget _child;
    final FeedType _feedtype;

    FeedRefresher(this._child, this._feedtype);

    void _onRefresh(bool up, MainBloc model) async {
        if (up) {
        //headerIndicator callback
        model.getSocialFeed(_feedtype);
        new Future.delayed(const Duration(seconds: 2)).then((val) {
            _refreshController.sendBack(true, RefreshStatus.completed);
        });
        } else {
        //footerIndicator Callback
        }
    }

    @override
    Widget build(BuildContext context) {
        return ScopedModelDescendant<MainBloc>(
            builder: (BuildContext context, _, MainBloc model) => SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: (up) => _onRefresh(up, model),
                child: _child,
                ));
    }
}

class ProfileRefresher extends StatelessWidget {
    final RefreshController _refreshController = new RefreshController();
    final Widget _child;

    ProfileRefresher(this._child);

    void _onRefresh(bool up) async {
        if (up) {
        //headerIndicator callback
        new Future.delayed(const Duration(seconds: 2)).then((val) {
            _refreshController.sendBack(true, RefreshStatus.completed);
        });
        } else {
        //footerIndicator Callback
        }
    }

    @override
    Widget build(BuildContext context) {
        return ScopedModelDescendant<MainBloc>(
            builder: (BuildContext context, _, MainBloc model) => SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: (up) => _onRefresh(up),
                child: _child,
                ));
    }
}

class CopyProfileButton extends StatelessWidget {
    final Profile _profile;

    CopyProfileButton(this._profile);

    @override
    Widget build(BuildContext context) {
        return IconButton(
            icon: Icon(
            Icons.content_copy,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            ),
            onPressed: () async {
            var result = Routes.copyProfilePage(context, _profile.objectId,
                _profile.type, false, true, false, true, true, profile: _profile);
            if (result is Profile) {
                Navigator.pop(context);
            }
            });
    }
}

class DeleteProfileButton extends StatelessWidget {
    final Profile _profile;

    DeleteProfileButton(this._profile);

    @override
    Widget build(BuildContext context) {
        return IconButton(
            icon: Icon(
            Icons.delete,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            ),
            onPressed: () async {
            MainBloc.of(context).delete(_profile);
            Navigator.pop(context);
            });
    }
}

class MainMenuDrawer extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return ScopedModelDescendant<MainBloc>(
        builder: (BuildContext context, _, MainBloc model) => Drawer(
                child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                    DrawerHeader(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment(-1, 1),
                        child: Text('Options',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .apply(color: Colors.white))),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                    ),
                    ),
                    ListTile(
                        title: Text('Edit user profile'),
                        onTap: () {
                        UserDetails userdetails = UserDetails(
                            idIn: model.userdetails.id ?? 'error',
                            userNameIn: model.userdetails.userName ?? 'error',
                            emailIn: model.userdetails.email ?? 'error',
                            photoIn: model.userdetails.photoUrl ?? null,
                            mottoIn: model.userdetails.motto ?? 'error ');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => CustomScaffold(
                                    UserInputDetails(userdetails),
                                    title: 'User Details'),
                            )).then((_) {
                            model.refreshUser();
                            Navigator.pop(context);
                        });
                        }),

                    Divider(),

                    ListTile(
                    title: Text('Take tour'),
                    onTap: () {
                        Navigator.pushNamed(context, RouteIds.welcome);
                    },
                    ),

                    Divider(),

                    ListTile(
                    title: Text('Send Feedback'),
                    onTap: () { MainBloc.of(context).sendFeedback(); },
                    ),
                ],
                ),
            ),
        );
    }
}

class CenterdCircularProgressIndicator extends StatelessWidget {
    @override
    Widget build(BuildContext context) =>
        Center(child: CircularProgressIndicator());
}

class CenterdLineaProgressIndicator extends StatelessWidget {
    @override
    Widget build(BuildContext context) =>
        Center(child: LinearProgressIndicator());
}

class SelectSortTypeDiolog extends StatelessWidget {
    final Function(ListSortingOptions) _sortType;
    final Set<ListSortingOptions> options;

    SelectSortTypeDiolog(this._sortType, {@required this.options});

    final EdgeInsetsGeometry _padding = EdgeInsets.all(5);

    void _optionPressed(BuildContext context, ListSortingOptions method) {
        _sortType(method);
        Navigator.pop(context);
    }

    @override
    Widget build(BuildContext context) {
        List<Widget> _list = new List<Widget>();

        options.forEach((method) {
        _list.add(new ListTile(
            key: UniqueKey(),
            title: Text(Functions.getStringValueOfSortingMethod(method)),
            trailing: Icon(Icons.arrow_forward_ios),
            contentPadding: _padding,
            onTap: () => _optionPressed(context, method),
        ));
        _list.add(Divider());
        });

        return SimpleDialog(
            key: UniqueKey(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
              'Sort List',
              style: Theme.of(context).textTheme.title,
              ),
            ),
            titlePadding: _padding,
            contentPadding: _padding,
            children: _list);
    }
}

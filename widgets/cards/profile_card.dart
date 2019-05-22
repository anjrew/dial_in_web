import 'main_bloc.dart';
import 'error_reporting.dart';
import 'profile.dart';
import 'database_functions.dart';
import 'routes.dart';
import 'custom_widgets.dart';
import 'popups.dart';
import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

class ProfileCard extends StatefulWidget {
  final Function(Profile, BuildContext, String) _giveprofile;
  final Function(Profile, BuildContext, String) _deleteProfile;
  final Profile _profile;
  final Animation<double> _animation;
  final bool selected;
  final String _heroTag;
  final bool isDeletable;

  ProfileCard(this._heroTag, this._profile, this._giveprofile,
      this._deleteProfile, this._animation,
      {this.selected = false, @required this.isDeletable})
      : assert(selected != null),
        super(key: Key(_profile.objectId));

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard>
    with TickerProviderStateMixin {
  Function(Profile, BuildContext, String) _giveprofile;
  Profile _profile;
  bool selected;
  String _heroTag;
  bool isDeletable;
  bool isDeleted = false;
  int height = 0;

  Animation<int> _animation;
  AnimationController _animationcontroller;
  Animation _animationCurve;

  @override
  void initState() {
    _giveprofile = widget._giveprofile;
    _profile = widget._profile;
    _animationcontroller =
        new AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animationCurve =
        CurvedAnimation(parent: _animationcontroller, curve: Curves.easeIn);
    _animation = new IntTween(
            begin: _profile.type == ProfileType.recipe ||
                    _profile.type == ProfileType.coffee
                ? 120
                : 95,
            end: 0)
        .animate(_animationCurve);
    selected = widget.selected;
    _heroTag = widget._heroTag;
    isDeletable = widget.isDeletable;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profile = widget._profile;
  }

  final _dateFormat = DateFormat('d/M/yyy');

  void _editProfile(BuildContext context) async {
    Routes.openProfilePage(context, _profile.objectId, _profile.type, false,
        true, true, false, false, _heroTag);
  }

  @override
  Widget build(BuildContext context) {
    print(_animation.value);
    _profile = widget._profile;
    String _topLeftText = '';
    String _middleleftText = '';
    String _bottomleftText = '';
    Widget _topLeftWidget;
    Widget _middleleftWidget;
    Widget _bottomleftWidget;
    List<Widget> _details = new List<Widget>();


    switch (_profile.type) {
      case ProfileType.recipe:
        String coffee = _profile.getProfileProfileTitleValue(
            profileDatabaseId: DatabaseIds.coffee);
        String method = _profile.getProfileProfileTitleValue(
                profileDatabaseId: DatabaseIds.brewingEquipment) ??
            '';

        bool hasMethod = method != null && method != '';

        String valueIfMethod = coffee + ' on ' + method;
        String noMethod = ' ' + coffee;

        DateTime brewdate = _profile.getItemValue(DatabaseIds.date);

        if (hasMethod) {
          _topLeftText = valueIfMethod;
        } else {
          _topLeftText = noMethod;
        }
        _middleleftText = _dateFormat.format(brewdate);

        _topLeftWidget = Container(
            child: ScalableWidget(Text( _topLeftText,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .display2,
                )
            )
        );

        _middleleftWidget = Container(
                padding: EdgeInsets.fromLTRB( 0, 3, 0, 0),
                child: Text(_middleleftText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Colors.grey),
            )
        );

        _bottomleftWidget = Container(
            child: ScalableWidget(
                FiveStarRating(_profile
                        .getTotalScore()
                        .toInt()))
                );

        _details.addAll([
            _topLeftWidget,
            Padding(padding: EdgeInsets.all(3),),
            _middleleftWidget,
            _bottomleftWidget
        ]);

        break;

      case ProfileType.coffee:

        _topLeftText =  _profile.getItemValue(DatabaseIds.coffeeId);
        _middleleftText = _dateFormat.format(_profile.getItemValue(DatabaseIds.roastDate));
        _bottomleftText = _profile.getItemValue(DatabaseIds.country);
         _topLeftWidget = Container(
            child: ScalableWidget(Text( _topLeftText,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .display2,
                )
            )
        );

        _middleleftWidget = Container(
                padding: EdgeInsets.fromLTRB( 0, 3, 0, 0),
                child: Text(_middleleftText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Colors.grey),
            )
        );

        _bottomleftWidget = Text(_bottomleftText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
        );
        
        if (_topLeftText != null && _topLeftText != ''){
            _details.add(_topLeftWidget);
        }          
        if (_middleleftText != null && _middleleftText != ''){
            _details.add(Padding(padding: EdgeInsets.all(2),),);
            _details.add(_middleleftWidget);
        }  
        if (_bottomleftText != null && _bottomleftText != ''){
            _details.add( Padding(padding: EdgeInsets.all(3),),);
            _details.add(_bottomleftWidget);
        }  

        break;

      case ProfileType.water:

        if (_profile.getItemValue(DatabaseIds.waterID) == '' ||
            _profile.getItemValue(DatabaseIds.waterID) == null) {
          _topLeftText = '';
        } else {
          _topLeftText = _profile.getItemValue(DatabaseIds.waterID);
        }
        _topLeftWidget = Container(
            child: ScalableWidget(Text( _topLeftText,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .display2,
                )
            )
        );

        _details.add(_topLeftWidget);

        break;

      case ProfileType.equipment:
        _topLeftText = _profile.getItemValue(DatabaseIds.equipmentId);
        _middleleftText = _profile.getItemValue(DatabaseIds.type);
        _topLeftWidget = Container(
            child: ScalableWidget(Text( _topLeftText,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .display2,
                )
            )
        );

        _middleleftWidget = Container(
                padding: EdgeInsets.fromLTRB( 0, 3, 0, 0),
                child: Text( _middleleftText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Colors.grey),
            )
        );

        if (_topLeftText != null && _topLeftText != ''){
            _details.add(_topLeftWidget);
        }          
        if (_middleleftText != null && _middleleftText != ''){
            _details.add(Padding(padding: EdgeInsets.all(3),),);
            _details.add(_middleleftWidget);
        } 

        break;

      case ProfileType.grinder:
        _topLeftText = _profile.getItemValue(DatabaseIds.grinderId);
        _bottomleftText = _profile.getItemValue(DatabaseIds.burrs);
        _topLeftWidget = Container(
            child: ScalableWidget(Text( _topLeftText,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .display2,
                )
            )
        );

        _middleleftWidget = Container(
                padding: EdgeInsets.fromLTRB( 0, 3, 0, 0),
                child: Text( _bottomleftText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Colors.grey),
            )
        );

        if (_topLeftText != null && _topLeftText != ''){
            _details.add(_topLeftWidget);
        }          
        if (_middleleftText != null && _middleleftText != ''){
            _details.add(Padding(padding: EdgeInsets.all(3),),);
            _details.add(_middleleftWidget);
        } 
        break;

      case ProfileType.barista:
        _topLeftText = _profile.getItemValue(DatabaseIds.name);
        _bottomleftText = _profile.getItemValue(DatabaseIds.notes);
        _topLeftWidget = Container(
            child: ScalableWidget(Text( _topLeftText,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .display2,
                )
            )
        );

        _middleleftWidget = Container(
                padding: EdgeInsets.fromLTRB( 0, 3, 0, 0),
                child: Text( _bottomleftText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Colors.grey),
            )
        );

        if (_topLeftText != null && _topLeftText != ''){
            _details.add(_topLeftWidget);
        }          
        if (_middleleftText != null && _middleleftText != ''){
            _details.add(Padding(padding: EdgeInsets.all(3),),);
            _details.add(_middleleftWidget);
        } 
        break;

      default:
        Error();

        break;
    }

    List<Widget> sliders = <Widget>[
          new IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _deleteProfile(_profile, context, _heroTag),
          ),
          new IconSlideAction(
            caption: 'Edit',
            color: Colors.yellow,
            icon: Icons.edit,
            onTap: () => _editProfile(context),
          ),
          new IconSlideAction(
            caption: 'Copy',
            color: Colors.blue,
            icon: Icons.content_copy,
            onTap: () => Routes.copyProfilePage(context, _profile.objectId,
                _profile.type, false, true, false, true, true,
                profile: this._profile),
          )
    ];

    if (_profile.type != ProfileType.recipe) { 
        sliders.add(new IconSlideAction(
            caption: 'Recipe with this',
            color: Colors.green,
            icon: Icons.plus_one,
            onTap: () => Routes.openRecipeProfilePageWithOtherProfile(
              context,
              _profile.objectId,
              _profile.type,
              false,
              true,
              false,
              false,
              true,
              89787987,
              heroTag: '')
          )
          );
    }

    return AnimatedBuilder(
            key: new Key(_profile.objectId + 'profileCard'),
            animation: _animation,
            builder: (BuildContext context, Widget child) => Slidable(
        enabled: isDeletable,
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        secondaryActions: sliders,
        child: Container(
          height: _animation.value.toDouble(),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                  margin: _profile.type == ProfileType.recipe
                      ? EdgeInsets.fromLTRB(10, 5, 10, 5)
                      : EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () => _giveprofile(_profile, context, _heroTag),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      _profile.type == ProfileType.recipe
                          ? Padding(
                              padding: EdgeInsets.all(3),
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),

                      ///
                      /// Profile picture
                      ///
                      CircularCachedProfileImage(
                          _profile.placeholder,
                          _profile.imageUrl,
                          _profile.type == ProfileType.recipe ||
                                  _profile.type == ProfileType.coffee
                              ? 80
                              : 60,
                          _heroTag),

                      Padding(padding: EdgeInsets.all(5.0)),

                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                        ///
                        /// Main name and secondnary details
                        ///
                        Expanded(
                            flex: 8,
                            child: Container(
                                padding: _profile.type == ProfileType.recipe
                                    ? EdgeInsets.fromLTRB(5, 10, 5, 0)
                                    : EdgeInsets.all(5.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: _details))),
                      ]))
                    ]),
                  ))),
        )));
  }

    void _deleteProfile(Profile profile, BuildContext contextIn, String index) {

        PopUps.yesOrNoDioLog(
            context,
            'Warning',
            'Are you sure you want to delete this profile?',
            (isYes) {
                if (isYes) {
                    MainBloc.of(context).overviewBloc.profileDataList(_profile.type).deleteProfile(profile);
                    Navigator.pop(context);
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Profile deleted"),
                        duration: Duration(seconds: 2),
                    ));

                    _animationcontroller.forward()
                    .then((_){
                        setState(() {
                            Dbf.deleteProfile(profile);

                        });
                    })
                .catchError(Sentry.report);
                } else {
                    Navigator.pop(context);
                }
            });
           
           
    }

    @override
    void dispose() {
        _animationcontroller.dispose();
        super.dispose();
    }
}

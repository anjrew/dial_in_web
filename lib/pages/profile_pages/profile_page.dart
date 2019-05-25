import 'package:dial_in_v1/widgets/cards/profile_card.dart';
import 'package:dial_in_v1/widgets/popups.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:dial_in_v1/data/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:dial_in_v1/pages/profile_pages/recipe_profile_page.dart';
import 'package:dial_in_v1/pages/profile_pages/water_profile_page.dart';
import 'package:dial_in_v1/pages/profile_pages/equipment_profile_page.dart';
import 'package:dial_in_v1/pages/profile_pages/barista_profile_page.dart';
import 'package:dial_in_v1/pages/profile_pages/coffee_profile_page.dart';
import 'package:dial_in_v1/pages/profile_pages/grinder_profile_page.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'dart:async';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:dial_in_v1/pages/profile_pages/profile_page_model.dart';
import 'package:dial_in_v1/classes/error_reporting.dart';
import 'package:dial_in_v1/theme/appColors.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dial_in_v1/widgets/popups_widgets.dart';
import 'package:dial_in_v1/routes/routes.dart';

class ProfilePage extends StatefulWidget {
  final ProfilePageModel _model;
  ProfilePage(this._model);
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  List<Widget> _appBarActions = [Container()];
  AssetImage _background;
  Key _headerKey;

  void initState() {
    _background = MainBloc.of(context)
        .images
        .getProFileTypeBackgroundPhoto(widget._model.type);
    assert(widget._model.isFromUserFeed != null, 'isFromUserFeed is null');
    _headerKey = UniqueKey();
    super.initState();
  }

    @override
    Widget build(BuildContext context) => ScopedModel<ProfilePageModel>(
        model: widget._model,
        child: GestureDetector(
    onTap: () { FocusScope.of(context).requestFocus(FocusNode()); },
    behavior: HitTestBehavior.translucent,
    child: Material(
                color: AppColors.getColor(ColorType.lightBackground),
                child: CustomScrollView(
                slivers: <Widget>[
                    ProfilePageAppBar(),
                    SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                        ProfileHeaderWidget(
                            key: _headerKey,
                            isFromUserFeed: widget._model.isFromUserFeed,
                            image: _background,
                            getImage: _getImage),
                        ProfilePageBody(),
                        widget._model.type == ProfileType.recipe
                            ? Container(
                                width: 0,
                                height: 0,
                            )
                            : RelatedProfilesList()
                    ]),
                    ),
                    SliverToBoxAdapter(key: Key('bottomBar'), child: ProfilePageBottomBar()), 
                ],
                ),
            )
        )
    );

    Future _getImage() async {
        var filePath = await showDialog(
            context: context,
            builder: (BuildContext context) {
            return CupertinoImagePicker();
            }).catchError(Sentry.report);

        if (filePath != null && filePath is String) {
        PopUps.showCircularProgressIndicator(context);

        String url = await Dbf.upLoadFileReturnUrl(File(filePath), [
            DatabaseIds.user,
            widget._model.userId,
            DatabaseIds.images,
            widget._model.databaseId
        ])
            .timeout(databaseTimeoutDuration,
                onTimeout: () => onImageTimeout(context))
            .catchError((error) {
            if (error is TimeoutException) {
            onImageTimeout(context);
            } else {
            Sentry.report(error);
            }
        });

        /// Wait until image has saved
        if (widget._model.imageUrl != null && widget._model.imageUrl != '') {
            MainBloc.of(context).cache.setFile(url, File(filePath));
        }
        setState(() {
            widget._model.imageUrl = url;
        });
        Navigator.pop(context);
        } else if (filePath is ResetImageRequest) {
        setState(() {
            widget._model.imageUrl = '';
        });
        } else {
        ///Nothing selected
        }
  }

  void onImageTimeout(BuildContext context) {
    Navigator.pop(context);
    PopUps.showAlert(
        'Slow ay?',
        "The picture is taking waaaaaay to long to upload. Maybe it's your internet connection ",
        'ok',
        () => Navigator.pop(context),
        context);
  }
}

class RelatedProfilesList extends StatelessWidget {
  RelatedProfilesList({Key key}) : super(key: key);

  void _giveProfile(
      Profile profile, BuildContext context, String herotag) async {
    Routes.openProfilePage(
        context,
        profile.objectId,
        profile.type,
        ProfilePageModel.of(context).isFromUserFeed,
        false,
        true,
        false,
        false,
        herotag);
  }

  void _deleteProfile(Profile profile, BuildContext context, String herotag) {
    PopUps.yesOrNoDioLog(
        context, 'Warning', 'Are you sure you want to delete this profile?',
        (isYes) {
      if (isYes) {
        MainBloc.of(context)
            .overviewBloc
            .profileDataList(ProfilePageModel.of(context).type)
            .deleteProfile(profile);
        Navigator.pop(context);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Profile deleted"),
          duration: Duration(seconds: 2),
        ));
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Profile>(
      stream: ProfilePageModel.of(context).profileStream,
      builder: (BuildContext streamContext, AsyncSnapshot<Profile> snapshot) =>
          !snapshot.hasData
              ? BlankWidget()
              : ProfilePageModel.of(context).relatedProfilesListBloc == null ||
                      !ProfilePageModel.of(context)
                          .relatedProfilesListBloc
                          .initialised ||
                      ProfilePageModel.of(context)
                              .relatedProfilesListBloc
                              .length <=
                          0
                  ? BlankWidget()
                  : StreamBuilder<List<Profile>>(
                      stream: ProfilePageModel.of(context)
                          .relatedProfilesListBloc
                          .profilesStream,
                      builder: (BuildContext streamContext,
                          AsyncSnapshot<List<Profile>> profiles) {

                        List<ProfileCard> cards = List<ProfileCard>();
                        for (var i = 0; i < profiles.data.length; i++) {
                          cards.add(ProfileCard(i.toString()+'related', profiles.data[i],
                              _giveProfile, _deleteProfile, null,
                              isDeletable: !ProfilePageModel.of(context)
                                  .isFromUserFeed));
                        }

                        return profiles.hasData
                            ? Container(
                                child: Column(children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Recipes that used this ${ProfilePageModel.of(context).profileTypeTitle}',
                                      style:
                                          Theme.of(context).textTheme.display4,
                                      textAlign: TextAlign.center,
                                    )),
                                Column(children: cards)
                              ]))
                            : NoDataIndicator();
                      }));
}

class RelatedProfilesListBloc extends Model {
  Profile _profile;
  MainBloc _mainBloc;
  bool _isCurrentUserProfile;
  bool initialised = false;

  BehaviorSubject<List<Profile>> _incomingProfilesObservable =
      new BehaviorSubject<List<Profile>>();
  BehaviorSubject<List<Profile>> _outgoingProfilesObservable =
      new BehaviorSubject<List<Profile>>();

  RelatedProfilesListBloc(
      this._mainBloc, this._profile, this._isCurrentUserProfile) {
    assert(_profile != null, '_profile is null');
    if (_isCurrentUserProfile) {
      _incomingProfilesObservable
          .addStream(_mainBloc.getProfilesStream(ProfileType.recipe));
      _incomingProfilesObservable.listen(incomingProfilesListener);
    } else {
      getRecipesFromOtherUser();
    }
  }

  int get length => _outgoingProfilesObservable.value.length;

  void getRecipesFromOtherUser() async {
    List<Profile> otherUserProfiles = await Dbf
            .getListOfPublicRecipeProfilesForNOTcurrentUser(_profile.userId)
        .catchError(Sentry.report)
        .timeout(databaseTimeoutDuration, onTimeout: () => new List<Profile>());
    incomingProfilesListener(otherUserProfiles);
  }

  void incomingProfilesListener(List<Profile> profiles) {
    if (profiles != null) {
      List<Profile> editedList = new List<Profile>.from(profiles);

      editedList.removeWhere((p) {
        Profile compareProfile = p.getProfileProfile(_profile.type);
        return compareProfile.objectId != _profile.objectId;
      });
      _outgoingProfilesObservable.add(editedList);
      initialised = true;
    }
  }

  Stream<List<Profile>> get profilesStream =>
      _outgoingProfilesObservable.stream;

  void dispose() {
    _incomingProfilesObservable.close();
  }

  static RelatedProfilesListBloc of(BuildContext context) =>
      ScopedModel.of<RelatedProfilesListBloc>(context);
}

class ProfilePageBottomBar extends StatelessWidget {
    @override
    Widget build(BuildContext context) => ScopedModelDescendant<ProfilePageModel>(
        builder: (BuildContext context, _, ProfilePageModel model) =>
            StreamBuilder<Profile>(
                stream: ProfilePageModel.of(context).profileStream,
                builder: (BuildContext context, AsyncSnapshot<Profile> profile) {
                    Widget _bottomBar;

                    if (model.isOldProfile && !model.isFromUserFeed) {
                    return Material(
                        color: Theme.of(context).cardColor,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                                CopyProfileButton(profile.data),
                                model.type != ProfileType.recipe
                                    ? MakeNewRecipeButton()
                                    : BlankWidget(),
                                DeleteProfileButton(profile.data)
                            ],
                        ),
                    );
                    }
                    return _bottomBar ??
                        Container(
                        width: 0,
                        height: 0,
                        );
                }));
}

class MakeNewRecipeButton extends StatelessWidget {
  MakeNewRecipeButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.plus_one,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        onPressed: () async {
          Routes.openRecipeProfilePageWithOtherProfile(
              context,
              ProfilePageModel.of(context).objectId,
              ProfilePageModel.of(context).type,
              false,
              true,
              false,
              false,
              true,
              89787987,
              heroTag: '');
          Navigator.pop(context);
        });
  }
}

class ProfileHeaderWidget extends StatelessWidget {
  final bool isFromUserFeed;
  final AssetImage image;
  final Function getImage;

  ProfileHeaderWidget(
      {Key key,
      @required this.isFromUserFeed,
      @required this.image,
      @required this.getImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.cover)),
        child: Container(
            decoration: new BoxDecoration(
                color: AppColors.getColor(ColorType.lightBackground)
                    .withAlpha(200)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Spacer
                Expanded(
                  child: Container(),
                ),

                // Profile Image
                ProfilePageImage(getImage),

                /// Public Switch
                PublicProfileSwitch()
              ],
            )),
      );
}

class ProfilePageImage extends StatelessWidget {
  final Function onPressed;

  ProfilePageImage(this.onPressed);

  @override
  Widget build(BuildContext context) => ScopedModelDescendant(
      rebuildOnChange: false,
      builder: (BuildContext modelContext, _, ProfilePageModel model) =>
          Container(
              padding: EdgeInsets.all(20.0),
              child: InkWell(
                  child: CircularCachedProfileImage(
                      model.placeholder, model.imageUrl, 200, model.heroTag),
                  onTap: () {
                    if (model.isEditing) {
                      onPressed();
                    }
                  })));
}

class ProfilePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfilePageModel _model = ProfilePageModel.of(context);

    return StreamBuilder<bool>(
        stream: _model.isEditingStream,
        builder: (BuildContext context, AsyncSnapshot<bool> isediting) =>
            StreamBuilder<Profile>(
                stream: _model.profileStream,
                builder:
                    (BuildContext context, AsyncSnapshot<Profile> profile) {
                  if (profile.hasData) {
                    _model.fullyInitilised = true;
                    return _returnPageStructure(_model);
                  }
                  else{
                      return CenterdCircularProgressIndicator();
                  }
                  
                }));
  }

  /// page structure
  Widget _returnPageStructure(ProfilePageModel model) {
    Widget _structure;

    switch (model.type) {
      case ProfileType.barista:
        _structure = BaristaPage();
        break;

      case ProfileType.coffee:
        _structure = CoffeeProfilePage();
        break;

      case ProfileType.equipment:
        _structure = EquipmentPage();
        break;

      case ProfileType.water:
        _structure = WaterPage();
        break;

      case ProfileType.recipe:
        _structure = RecipePage();
        break;

      case ProfileType.grinder:
        _structure = GrinderPage();
        break;

      default:
        break;
    }

    return Container(child: _structure);
  }
}

class PublicProfileSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
      stream: ProfilePageModel.of(context).isPublicStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> isPublic) =>
          StreamBuilder<bool>(
              stream: ProfilePageModel.of(context).isEditingStream,
              initialData: false,
              builder: (BuildContext streamContext,
                      AsyncSnapshot<bool> isEditing) =>
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutBack,
                    child: !isEditing.data
                        ? Expanded(child: BlankWidget())
                        : Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    isPublic.data
                                        ? StringLabels.public
                                        : 'Private',
                                    style: Theme.of(context).textTheme.body2),
                                Switch(
                                  inactiveThumbColor: Colors.white,
                                  activeColor: Colors.white,
                                  activeTrackColor: AppColors.getColor(
                                      ColorType.primarySwatch),
                                  inactiveTrackColor: Colors.black54,
                                  onChanged: (on) {
                                    ProfilePageModel.of(context).isPublic = on;
                                  },
                                  value: isPublic.data,
                                ),
                              ],
                            ),
                          ),
                  )));
}

class ProfilePageAppBar extends StatefulWidget {
  ProfilePageAppBar();
  _ProfilePageAppBarState createState() => _ProfilePageAppBarState();
}

class _ProfilePageAppBarState extends State<ProfilePageAppBar> {
  List<Widget> _appBarActions = [
    MaterialButton(
      onPressed: () {},
    )
  ];

  void setupAppBarActions(
      ProfilePageModel model, Profile profile, bool isEditing) {
    if (!model.isFromUserFeed) {
      if (isEditing != null) {
        isEditing
            ? _appBarActions[0] = RawMaterialButton(
                child: Icon(
                  Icons.save_alt,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () => saveFunction(model, profile))
            : _appBarActions[0] = RawMaterialButton(
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    model.isEdtingSink.add(true);
                  });
                });
      } else {
        _appBarActions[0] = CopyProfileButton(profile);
      }
    } else {
      _appBarActions[0] = IconButton(
          icon: Icon(
            Icons.warning,
            color: AppColors.getColor(ColorType.textLight),
          ),
          onPressed: () => PopUps.showReportContentDiolog(
              context, profile.objectId, profile.userId));
    }
  }

  /// save button function
  void saveFunction(ProfilePageModel model, Profile profile) async {
    ProfileSavePermission request = model.isValidForSave;
    if (request.sucess) {
      if (model.isOldProfile) {
        PopUps.showCircularProgressIndicator(context);
        await Dbf.updateProfile(profile);
        Navigator.pop(context, profile);
        Navigator.pop(context, profile);
      } else {
        PopUps.showCircularProgressIndicator(context);
        var newProfile = await model.saveProfile(profile);
        Navigator.pop(context, newProfile);
        Navigator.pop(context, newProfile);
      }
    } else {
      PopUps.showAlert(
          'Oops', request.message, 'ok', () => Navigator.pop(context), context);
    }
  }

  dynamic setupLeading(dynamic isEditing, ProfilePageModel model) {
    if (isEditing != null) {
      return model.isOldProfile
          ? isEditing
              ? RawMaterialButton(
                  child: Icon(
                    Icons.cancel,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () => setState(() {
                        model.isEdtingSink.add(false);
                      }))
              : GoBackAppBarButton()
          : GoBackAppBarButton();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<ProfilePageModel>(
          builder: (BuildContext context, _, model) {
        return StreamBuilder<Profile>(
            stream: model.profileStream,
            builder: (BuildContext context, AsyncSnapshot<Profile> profile) {
              return StreamBuilder<bool>(
                stream: model.isEditingStream,
                builder: (BuildContext context, AsyncSnapshot<bool> isEditing) {
                  setupAppBarActions(model, profile.data, isEditing.data);

                  return SliverAppBar(
                    floating: true,
                    backgroundColor: const Color.fromARGB(250, 209, 140, 92),
                    centerTitle: true,
                    brightness: Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light,
                    titleSpacing: 0,
                    automaticallyImplyLeading: false,
                    title: Text(model.appBarTitle(isEditing.data),
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                        )),
                    leading: setupLeading(isEditing.data, model),
                    actions: _appBarActions,
                  );
                },
              );
            });
      });
}

class GoBackAppBarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<ProfilePageModel>(
      rebuildOnChange: true,
      builder: (BuildContext context, _, ProfilePageModel model) =>
          RawMaterialButton(
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () {
              if (!model.isOldProfile) {
                if (model.imageUrl != null && model.imageUrl != '') {}
              }
              Navigator.pop(context, false);
            },
          )
        );
}

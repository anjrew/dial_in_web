import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dial_in_v1/widgets/custom_widgets.dart';
import 'package:dial_in_v1/data/strings.dart';
import 'package:dial_in_v1/data/mini_classes.dart';
import 'package:dial_in_v1/data/images.dart';
import 'package:dial_in_v1/data/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dial_in_v1/routes/routes.dart';
import 'package:dial_in_v1/database_functions.dart';
import 'package:dial_in_v1/blocs/main_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:shimmer/shimmer.dart';

class UserProfilePage extends StatefulWidget {
  final UserProfile _userProfile;
  final bool isCurrentUser;
  final String tag;

  UserProfilePage(this._userProfile, this.isCurrentUser, {this.tag});
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserProfile _userProfile;
  bool isCurrentUser;
  String tag;
  final double gridTileHeight = 200;
  BehaviorSubject<List<Profile>> _profiles =
      new BehaviorSubject<List<Profile>>();

  @override
  void initState() {
    _userProfile = widget._userProfile;
    isCurrentUser = widget.isCurrentUser;
    tag = widget.tag;
    getprofiles();
    super.initState();
  }

  /// UI Build
  @override
  Widget build(BuildContext context) => CustomScrollView(slivers: <Widget>[
       SliverList(
              delegate: SliverChildListDelegate(<Widget>[
        Container(color: Colors.white),
        Stack(
          children: <Widget>[
            Center(
                child: Container(
                    color: Theme.of(context).cardColor,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),

                        Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.all(15.0),
                            child: Center(
                                child: CircularCachedProfileImage(Images.user,
                                    _userProfile.imageUrl, 180, tag))),

                        /// User name
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            _userProfile.userName ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .display4
                                .apply(fontSizeFactor: 2),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        //MOTTO
                        _userProfile.motto == null || _userProfile.motto == ''
                            ? Padding(
                                padding: EdgeInsets.all(10),
                              )
                            : Container(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  '"' + _userProfile.motto + '"' ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display4
                                      .apply(fontWeightDelta: 2),
                                  textAlign: TextAlign.center,
                                )),

                        // Following button Logic
                        isCurrentUser
                            ? BlankWidget()
                            : FollowButton(_userProfile.id),

                        Counts(_userProfile),

                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                      ],
                    )))
          ],
        ),

        Padding(
          padding: EdgeInsets.all(5),
        ),
      

        isCurrentUser
            ? StreamBuilder<List<Profile>>(
                stream: MainBloc.of(context).recipeProfilesStream,
                builder: (BuildContext streamContext,
                        AsyncSnapshot<List<Profile>> snapshot) =>
                    snapshot.hasData
                        ? GridView.builder(
                                shrinkWrap: true,
                                cacheExtent: 10,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.length,
                                key: UniqueKey(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  mainAxisSpacing: 5.0,
                                  crossAxisSpacing: 5.0,
                                  childAspectRatio: 1.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  String _herotag =
                                      snapshot.data[index].objectId +
                                          index.toString() +
                                          'userPage';
                                  return Container(
                                      child: InkWell(
                                          onTap: () =>
                                              Routes.openExistingProfile(
                                                  context,
                                                  snapshot.data[index],
                                                  !isCurrentUser,
                                                  _herotag),
                                          child: SquareCachedProfileImage(
                                            heroTag: _herotag,
                                            imageUrl:
                                                snapshot.data[index].imageUrl,
                                            placeholder: snapshot
                                                .data[index].placeholder,
                                          )));
                                })
                        : CenterdLineaProgressIndicator())
            : StreamBuilder<List<Profile>>(
                stream: _profiles,
                builder: (BuildContext streamContext,
                        AsyncSnapshot<List<Profile>> snapshot) =>
                    snapshot.hasData
                        ? Container(
                            color: Colors.white,
                            height: (snapshot.data.length).toDouble() *
                                gridTileHeight,
                            child: GridView.builder(
                                cacheExtent: 20,
                                itemCount: snapshot.data.length,
                                key: UniqueKey(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: gridTileHeight,
                                  mainAxisSpacing: 5.0,
                                  crossAxisSpacing: 5.0,
                                  childAspectRatio: 1.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  String _herotag =
                                      snapshot.data[index].objectId +
                                          index.toString() +
                                          Random().nextInt(1000).toString();
                                  return Container(
                                      child: InkWell(
                                          onTap: () =>
                                              Routes.openExistingProfile(
                                                  context,
                                                  snapshot.data[index],
                                                  !isCurrentUser,
                                                  _herotag),
                                          child: SquareCachedProfileImage(
                                            heroTag: _herotag,
                                            imageUrl:
                                                snapshot.data[index].imageUrl,
                                            placeholder: snapshot
                                                .data[index].placeholder,
                                          )));
                                }))
                        : CenterdLineaProgressIndicator())

        ]
      ),
      ),
    ]
  );

  void getprofiles() async {
    List<Profile> newProfiles =
        await Dbf.getListOfPublicRecipeProfilesForNOTcurrentUser(
            _userProfile.id);
    newProfiles.removeWhere(
        (profile) => profile.imageUrl == null || profile.imageUrl == '');
    if (!_profiles.isClosed) {
      _profiles.add(newProfiles);
    }
  }

  @override
  void dispose() {
    _profiles.close();
    super.dispose();
  }
}

class SquareCachedProfileImage extends StatelessWidget {
  final dynamic imageUrl;
  final String heroTag;
  final String placeholder;

  SquareCachedProfileImage(
      {@required this.placeholder,
      @required this.imageUrl,
      @required this.heroTag});

  @override
  Widget build(BuildContext context) {
    Widget _child = BlankWidget();

    if (imageUrl == null || imageUrl == '') {
      _child = Image.asset(placeholder);
    } else if (imageUrl is String) {
      _child = CachedNetworkImage(
        placeholder: (BuildContext context, String string) =>
            Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Container(
                  color: Colors.white54,
                )),
        errorWidget: (BuildContext context, String message, Object error) =>
            Image.asset(placeholder, key: Key('placeholder')),
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      );
    } else {
      _child = Image.asset(placeholder);
    }

    assert(_child != null, 'Child is null');

    return Hero(key: UniqueKey(), tag: heroTag, child: _child);
  }
}

class CountBlock extends StatelessWidget {
  final String _count;
  final String _label;

  CountBlock(this._count, this._label);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        children: <Widget>[CountLabel(_count), Text(_label)],
      ),
    );
  }
}

class Counts extends StatelessWidget {
  final UserProfile _userProfile;

  Counts(this._userProfile);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Brew count
              FutureBuilder(
                  future: _userProfile.getRecipeCount(),
                  initialData: '',
                  builder: (context, snapshot) => CountBlock(
                        snapshot.data.toString(),
                        StringLabels.brewCount,
                      )),

              Padding(
                padding: EdgeInsets.all(10.0),
              ),

              /// Bean Stash
              FutureBuilder(
                  future: _userProfile.getcoffeeCount(),
                  initialData: '',
                  builder: (context, snapshot) => CountBlock(
                        snapshot.data.toString(),
                        StringLabels.beanStash,
                      )),

              Padding(
                padding: EdgeInsets.all(10.0),
              ),

              /// Followers
              CountBlock(
                _userProfile.followers.length.toString(),
                StringLabels.followers,
              ),

              Padding(
                padding: EdgeInsets.all(10.0),
              ),

              /// Following
              CountBlock(
                _userProfile.following.length.toString(),
                StringLabels.following,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

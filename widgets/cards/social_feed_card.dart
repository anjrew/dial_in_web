import 'data/images.dart';
import 'data/mini_classes.dart';
import 'database_functions.dart';
import 'theme/shimmers.dart';
import 'widgets/custom_widgets.dart';
import 'package:flutter_web/material.dart';
import 'package:intl/intl.dart';

///Social card
class SocialFeedCard extends StatelessWidget {
  final Function(UserProfile, String) _giveUserProfile;
  final Function(FeedProfileData, String) _giveprofile;
  final FeedProfileData _profile;
  final _dateFormat = DateFormat('d/M/yyyy');
  final String _tag;

  SocialFeedCard(
      this._profile, this._giveprofile, this._giveUserProfile, this._tag);

  @override
  Widget build(BuildContext context) {
    Widget _description;
    String _descriptionText =
        _profile.profile.getItemValue(DatabaseIds.descriptors);
    _descriptionText.replaceAll(new RegExp(r','), ', ');
    String _notes = _profile.profile.getItemValue(DatabaseIds.notes);

    String coffee = _profile.profile
        .getProfileProfileTitleValue(profileDatabaseId: DatabaseIds.coffee);
    String method = _profile.profile.getProfileProfileTitleValue(
            profileDatabaseId: DatabaseIds.brewingEquipment) ??
        '';

    bool hasMethod = method != null && method != '';

    String valueIfMethod = coffee + ' on ' + method;
    String noMethod = ' ' + coffee;

    String title = hasMethod ? valueIfMethod : noMethod;

    if ((_descriptionText == '' || _descriptionText == null) &&
        (_notes == '' || _notes == null)) {
      _description = Container(
        width: 0.0,
        height: 0.0,
      );
    } else {
      String finalText;

      if (_descriptionText == '' || _descriptionText == null) {
        finalText = _notes;
      } else {
    finalText = _descriptionText + '. ' + _notes;
      }

      _description = Container(
        margin: EdgeInsets.all(5.0),
        child: Text(
          finalText,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Card(
        key: UniqueKey(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          color: Colors.white.withAlpha(0),
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.all(5)),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// User picture
                  Container(
                      child: InkWell(
                    onTap: () => _giveUserProfile(_profile.userProfile, _profile.userProfile.id + _tag.toString()),
                    child: CircularCachedProfileImage(
                        Images.user,
                        _profile.userProfile.imageUrl ?? Images.userFirebase,
                        50.0,
                        _profile.userProfile.id + _tag.toString()),
                  )),

                  Padding(
                    padding: EdgeInsets.all(5),
                  ),

                  Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///User Name
                          Container(
                            margin: EdgeInsets.all(5.0),
                            child: Text(
                              _profile.userProfile.userName ?? '',
                              maxLines: 1,
                              style: Theme.of(context).textTheme.display2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          /// Date
                          Container(
                            margin: EdgeInsets.all(5.0),
                            child: Text(
                                _dateFormat.format(_profile.profile
                                    .getItemValue(DatabaseIds.date)),
                                maxLines: 1),
                          ),
                        ]),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1),
                  ),

                  FollowButton(_profile.userProfile.id),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(3)),
            InkWell(
                onTap: () => _giveprofile(_profile, _profile.profile.objectId),
                child: Column(
                  children: <Widget>[
                    /// Recipe picture
                    CoverProfileCachedImage(
                        _profile.profile, _profile.profile.objectId),

                    Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            /// Coffee Name
                            Container(
                              margin: EdgeInsets.all(5.0),
                              child: Text(
                                title,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.display3,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            /// Notes
                            _description,

                            ///Score
                            FiveStarRating(
                                _profile.profile.getTotalScore().toInt()),
                          ],
                        )),
                  ],
                ))
          ]),
        ));
  }
}


class BlankSocialFeedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
        key: UniqueKey(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          color: Colors.white.withAlpha(0),
          child: Column(children: <Widget>[
            Padding(padding: EdgeInsets.all(5)),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /// User picture
                  Container(
                    child: ShapedBox(
                      Shimmers.standerd,
                    50,
                    Shape.circle)),

                  Padding(
                    padding: EdgeInsets.all(5),
                  ),

                  Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ///User Name
                          Container(
                            height: 16,
                            width: 200, 
                            margin: EdgeInsets.all(5.0),
                            child:  Shimmers.standerd
                          ),

                          /// Date
                          Container(
                            height: 16,
                            width: 150, 
                            margin: EdgeInsets.all(5.0),
                            child:  Shimmers.standerd
                          ),
                        ]),
                  ),

                  Padding(
                    padding: EdgeInsets.all(1),
                  ),

                  // Follow button
                  Container(
                            height: 16,
                            width: 150, 
                            margin: EdgeInsets.all(5.0),
                            child:  Shimmers.standerd
                          ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(3)),
            Column(
                  children: <Widget>[
                    /// Recipe picture
                    Container(
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
                      child: Container(
                            height: double.infinity,
                            width: double.infinity, 
                            margin: EdgeInsets.all(5.0),
                            child:  Shimmers.standerd
                          ),
                    ),

                    Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            /// Coffee Name
                            Container(
                              height: 16,
                              width: 200, 
                              margin: EdgeInsets.all(5.0),
                              child:  Shimmers.standerd
                            ),

                            /// Notes
                            Container(
                              height: 16,
                              width: 200, 
                              margin: EdgeInsets.all(5.0),
                              child:  Shimmers.standerd
                            ),

                            ///Score
                            Container(
                              height: 16,
                              width: 200, 
                              margin: EdgeInsets.all(5.0),
                              child:  Shimmers.standerd
                            ),
                          ],
                        )),
                  ],
                )
          ]),
        ));
}

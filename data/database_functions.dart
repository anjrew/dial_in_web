import 'flavour_descriptors.dart';
import 'dart:async';
import 'package:flutter_web/material.dart';
import 'profile.dart';
import 'functions.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'strings.dart';
import 'mini_classes.dart';
import 'package:flutter_web/services.dart';


const Duration databaseTimeoutDuration = Duration(seconds: 15);

class Dbf {
  static Future<bool> checkNotOnOldParseSystem(String email) async {
    bool returnVal = false;

    // QuerySnapshot doc = await Firestore.instance.collection(DatabaseIds.User).where( DatabaseIds.email, isEqualTo: email ).getDocuments();
    // if ( doc.documents.length > 0) {

    //   FirebaseAuth.nextHandle.
    //   returnVal = true ;}

    return returnVal ?? false;
  }

  static void updateAllProfilesWithField(String keyIn, dynamic valueIn) {
    ProfileType.values.forEach((type) {
      Firestore.instance
          .collection(Functions.getProfileTypeDatabaseId(type))
          .getDocuments()
          .then((QuerySnapshot snapshot) {
            if (snapshot.documents.isNotEmpty) {
              if (snapshot.documents.length > 0) {
                snapshot.documents.forEach((document) {
                  if (document.exists) {
                    if (document.data.isNotEmpty) {
                      if (document.data.length > 0) {
                        if (document.data[keyIn] == null) {
                          Dbf.updateField(
                                  Functions.getProfileTypeDatabaseId(type),
                                  document.documentID,
                                  keyIn,
                                  valueIn)
                              .catchError(Sentry.report)
                              .timeout(databaseTimeoutDuration,
                                  onTimeout: () => throw (TimeoutException(
                                      'Took too long to finish update',
                                      databaseTimeoutDuration)));
                        } else {
                          document.data.forEach((keyFile, valueFile) {
                            if (keyIn == keyFile) {
                              if (valueFile == null) {
                                Dbf.updateField(
                                        Functions.getProfileTypeDatabaseId(
                                            type),
                                        document.documentID,
                                        keyIn,
                                        valueIn)
                                    .catchError(Sentry.report)
                                    .timeout(databaseTimeoutDuration,
                                        onTimeout: () => throw (TimeoutException(
                                            'Took too long to finish update',
                                            databaseTimeoutDuration)));
                              }
                            }
                          });
                        }
                      }
                    }
                  }
                });
              }
            }
          })
          .catchError(Sentry.report)
          .timeout(databaseTimeoutDuration);
    });
  }

  // static Duration databaseTimeoutDuration = Duration(seconds: 15);

  static Future addFollower(
      String currentUser, String follow, Function(bool) completion) async {
    /// Add following
    Firestore.instance
        .collection(DatabaseIds.User)
        .document(currentUser)
        .get()
        .then((newDoc) {
      if (newDoc.exists) {
        /// Add following

        if (newDoc.data.containsKey(DatabaseIds.following)) {
          if (!((newDoc.data[DatabaseIds.following]) as List)
              .contains(follow)) {
            List<dynamic> newFollowingList =
                new List<String>.from(newDoc.data[DatabaseIds.following]);
            newFollowingList.add(follow);

            Dbf.updateField(DatabaseIds.User, currentUser,
                    DatabaseIds.following, newFollowingList)
                .whenComplete(() {
              completion(true);
              print('Successfully updated current user$currentUser follower');
            });
          }
        } else {
          List<String> newFollowingList = [follow];

          Dbf.updateField(DatabaseIds.User, currentUser, DatabaseIds.following,
                  newFollowingList)
              .whenComplete(() {
            completion(true);
            print('Successfully updated current user$currentUser follower');
          });
        }
      } else {
        print('No document found with ID $currentUser');
      }
    });

    /// Add followers

    Firestore.instance
        .collection(DatabaseIds.User)
        .document(follow)
        .get()
        .then((newDoc) {
          if (newDoc.exists) {
            if (newDoc.data.containsKey(DatabaseIds.followers)) {
              if (!((newDoc.data[DatabaseIds.followers]) as List)
                  .contains(currentUser)) {
                List<dynamic> newFollowersList =
                    new List<String>.from(newDoc.data[DatabaseIds.followers]);
                newFollowersList.add(currentUser);

                Map<String, dynamic> data = {
                  DatabaseIds.followers: newFollowersList
                };

                Firestore.instance
                    .collection(DatabaseIds.User)
                    .document(follow)
                    .updateData(data)
                    .whenComplete(() {
                  completion(true);
                  print('Successfully updated follower $follow follower');
                }).catchError((error) {
                  Sentry.report(error);
                }).timeout(databaseTimeoutDuration,
                        onTimeout: () => throw (TimeoutException(
                            'Adding follower', databaseTimeoutDuration)));
              }
            } else {
              List<String> newFollwersList = [currentUser];

              newDoc.data[DatabaseIds.followers] = {
                DatabaseIds.followers: newFollwersList
              };

              Firestore.instance
                  .collection(DatabaseIds.User)
                  .document(follow)
                  .updateData(newDoc.data[DatabaseIds.followers])
                  .catchError((error) {
                Sentry.report(error);
              }).timeout(databaseTimeoutDuration,
                      onTimeout: () => throw (TimeoutException(
                          'Adding follower', databaseTimeoutDuration)));
            }

            /// Document does not exist
          } else {
            print('No document found with ID $currentUser');
          }
        })
        .catchError((e) => Sentry.report(e))
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Adding follower', databaseTimeoutDuration)));
  }

  static Future unFollow(
      String currentUser, String unFollow, Function(bool) completion) async {
    Firestore.instance
        .collection(DatabaseIds.User)
        .document(currentUser)
        .get()
        .then((newDoc) {
          if (newDoc.exists) {
            if (newDoc.data.containsKey(DatabaseIds.following)) {
              if ((newDoc.data[DatabaseIds.following] as List)
                  .contains(unFollow)) {
                List<dynamic> newFollowingList =
                    new List<String>.from(newDoc.data[DatabaseIds.following]);
                newFollowingList.remove(unFollow);

                Dbf.updateField(DatabaseIds.User, currentUser,
                        DatabaseIds.following, newFollowingList)
                    .whenComplete(() {
                  completion(true);
                  print('Successfully removed follower $unFollow follower');
                });
              }
            } else {
              newDoc.data[DatabaseIds.following] = Map<String, dynamic>();

              Dbf.updateField(DatabaseIds.User, currentUser,
                      DatabaseIds.following, Map<String, dynamic>())
                  .whenComplete(() {
                completion(true);
                print('Successfully removed follower $unFollow follower');
              });
            }
          } else {
            print('No document found with ID $currentUser');
          }
        })
        .catchError((e) => Sentry.report(e))
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timeout unfollowing user', databaseTimeoutDuration)));

    /// Remove current User from Collection

    Firestore.instance
        .collection(DatabaseIds.User)
        .document(unFollow)
        .get()
        .then((newDoc) {
          if (newDoc.exists) {
            if (newDoc.data.containsKey(DatabaseIds.followers)) {
              if ((newDoc.data[DatabaseIds.followers] as List)
                  .contains(currentUser)) {
                List<dynamic> newFollowersList =
                    new List<String>.from(newDoc.data[DatabaseIds.followers]);
                newFollowersList.remove(currentUser);
                Map<String, dynamic> data = {
                  DatabaseIds.followers: newFollowersList
                };

                Firestore.instance
                    .collection(DatabaseIds.User)
                    .document(unFollow)
                    .updateData(data)
                    .whenComplete(() {
                  completion(true);
                  print('Successfully removed following $currentUser follower');
                }).catchError((error) {
                  Sentry.report(error);
                }).timeout(databaseTimeoutDuration,
                        onTimeout: () => throw (TimeoutException(
                            'Timedout unfollowing user',
                            databaseTimeoutDuration)));
              }
            } else {
              /// Create blank field for following
              Map<String, dynamic> data = {
                DatabaseIds.following: List<dynamic>()
              };

              Firestore.instance
                  .collection(DatabaseIds.User)
                  .document(unFollow)
                  .updateData(data)
                  .then((_) {
                completion(true);
                print(
                    'Successfully added following field to $unFollow document');
              }).catchError((error) {
                Sentry.report(error);
              }).timeout(databaseTimeoutDuration,
                      onTimeout: () => throw (TimeoutException(
                          'Timedout unfollowing user',
                          databaseTimeoutDuration)));
            }
          } else {
            print('No document found with ID $unFollow');
          }
        })
        .catchError((e) => Sentry.report(e))
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timedout unfollowing user', databaseTimeoutDuration)));
  }

  // Firestore fireStore;

  ///Login
  static Future<void> logIn(String emailUser, String password,
      Function(bool, String) completion) async {
    FirebaseUser user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailUser, password: password)
        // .timeout(databaseTimeoutDuration, onTimeout: throw( TimeoutException('Timed out when trying to log in', databaseTimeoutDuration)))
        .catchError((e) {
      if (e is PlatformException) {
        completion(false, e.message.toString());
      } else {
        completion(false, e.toString());
      }
    }).timeout(databaseTimeoutDuration,
            onTimeout: () => completion(
                false, 'Took to log to log in. More than after 15 seconds'));

    if (user != null) {
      completion(true, StringLabels.loggedIn);
    }
  }

  static Stream<FirebaseUser> getCurrentUserStream() {
    return FirebaseAuth.instance.onAuthStateChanged;
  }

  static Future<UserDetails> getCurrentUserDetails() async {
    FirebaseUser user = await FirebaseAuth.instance
        .currentUser()
        .catchError((error) => Sentry.report(error))
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timedout getting current user details',
                databaseTimeoutDuration)));

    UserDetails userDetails = UserDetails(
      idIn: user.uid,
      emailIn: user.email,
    );

    assert(userDetails != null, 'userDetails is null');
    return userDetails;
  }

  /// SignUp
  static Future<void> signUp(String userName, String emailUser, String password,
      String imageUrl, Function(bool, String) completion) async {
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailUser, password: password)
          .then((user) async {
        Map<String, dynamic> data = {
          DatabaseIds.userId: user.uid,
          DatabaseIds.userName: userName,
          DatabaseIds.imageUrl: imageUrl,
          DatabaseIds.following: List<String>()
        };

        await Firestore.instance
            .collection(DatabaseIds.User)
            .document(user.uid)
            .setData(data);

        completion(true, StringLabels.signedYouUp);
      }).timeout(databaseTimeoutDuration,
              onTimeout: () => throw (TimeoutException(
                  'Timedout trying to sign up user', databaseTimeoutDuration)));
    } catch (e) {
      completion(false, e.message);
    }
  }

  static Future<String> getCurrentUserEmail() async {
    FirebaseUser user = await FirebaseAuth.instance
        .currentUser()
        .catchError((error) => Sentry.report(error))
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timedout trying to get Current User Email',
                databaseTimeoutDuration)));
    String email = user.email;
    return email;
  }

  Future deleteCurrectUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete().then((_) {
      print('User deleted');
      return true;
    }).catchError((e) {
      Sentry.report(e);
      return false;
    }).timeout(databaseTimeoutDuration,
        onTimeout: () => throw (TimeoutException(
            'Timedout trying to delete current user',
            databaseTimeoutDuration)));
  }

  /// Logout
  static Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    print('Logged out');
  }

  /// Get User Image
  static Future<String> getUserImage() async {
    String userId = await getCurrentUserId();

    return await getValueFromFireStoreWithDocRef(
            DatabaseIds.User, userId, DatabaseIds.imageUrl) ??
        '';
  }

  /// Get User Name
  static Future<String> getCurrentyUserName() async {
    Future<String> username;

    getCurrentUserId()
        .then((String userId) {
          getValueFromFireStoreWithDocRef(
                  DatabaseIds.User, userId, DatabaseIds.userName)
              .then((userName) {
                username = userName;
              })
              .catchError((error) => Sentry.report(error))
              .timeout(databaseTimeoutDuration,
                  onTimeout: () => throw (TimeoutException(
                      'Timedout trying to get current user name',
                      databaseTimeoutDuration)));
        })
        .catchError((error) => Sentry.report(error))
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timedout trying to get current user name',
                databaseTimeoutDuration)));

    Future.wait([username]).timeout(Duration(seconds: 5));
    assert(username != null, 'username is null');

    return username;
  }

  static Future<String> getAnotherUserNameById(String userId) async {
    String value = await getValueFromFireStoreWithDocRef(
            DatabaseIds.User, userId, DatabaseIds.userName)
        .catchError((error) => Sentry.report(error))
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timedout trying to get current user name',
                databaseTimeoutDuration)));
    return value;
  }

  static Future<String> forgottonPassword(String email) async {
    String message = StringLabels.resetPassword;

    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .catchError((error) {
      message = (error as PlatformException).message;
    }).timeout(databaseTimeoutDuration,
            onTimeout: () =>
                'The process timed out, You may have a bad connection');

    return message;
  }

  static Future updateUserProfile(UserDetails userdetails) async {
    FirebaseUser user =
        await FirebaseAuth.instance.currentUser().catchError(Sentry.report);
    // .timeout(databaseTimeoutDuration, onTimeout: throw('Timed out when trying to get current User'));

    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    if (userdetails.userName != null || userdetails.userName != "") {
      userUpdateInfo.displayName = userdetails.userName;
    }
    if (userdetails.photoUrl != null || userdetails.photoUrl != "") {
      userUpdateInfo.photoUrl = userdetails.photoUrl;
    }

    if (userdetails.password != null && userdetails.password != "") {
      user
          .updatePassword(userdetails.password)
          .catchError(Sentry.report)
          .timeout(databaseTimeoutDuration,
              onTimeout: () => print(
                  'The process timed out, You may have a bad connection'));
    }

    if (userdetails.email != null && userdetails.email != "") {
      user.updateEmail(userdetails.email).catchError(Sentry.report).timeout(
          databaseTimeoutDuration,
          onTimeout: () =>
              print('The process timed out, You may have a bad connection'));
    }

    String imageUrl = userdetails.photoUrl;

    await user
        .updateProfile(userUpdateInfo)
        .then((_) async {
          Map<String, dynamic> data = {
            DatabaseIds.userId: user.uid,
            DatabaseIds.userName: userdetails.userName,
            DatabaseIds.imageUrl: imageUrl,
            DatabaseIds.motto: userdetails.motto
          };

          Map<String, dynamic> newData = Map<String, dynamic>();

          newData[DatabaseIds.userId] = user.uid;

          userdetails.values.forEach((key, value) {
            if (key == DatabaseIds.userName ||
                key == DatabaseIds.imageUrl ||
                key == DatabaseIds.motto) {
              newData[key] = value;
            }
          });

          Firestore.instance
              .collection(DatabaseIds.User)
              .document(user.uid)
              .get()
              .then((doc) {
            if (doc.exists) {
              Firestore.instance
                  .collection(DatabaseIds.User)
                  .document(user.uid)
                  .updateData(data)
                  .then((_) => print('sucessfully updated user'))
                  .catchError((e) {
                print('Error updating user $e');
                Sentry.report(e);
              }).timeout(Duration(seconds: 5));
            } else {
              Firestore.instance
                  .collection(DatabaseIds.User)
                  .document(user.uid)
                  .setData(data)
                  .then((_) => print('sucessfully updated user '))
                  .catchError((e) {
                print('Error updating user $e');
                Sentry.report(e);
              }).timeout(Duration(seconds: 5));
            }
          });
        })
        .catchError((error) => Sentry.report(error))
        .timeout(
          databaseTimeoutDuration,
        );

    if (imageUrl != null && imageUrl != userdetails.photoUrl) {
      Dbf.updateField(DatabaseIds.User, user.uid, DatabaseIds.imageUrl, null)
          .catchError(Sentry.report)
          .timeout(databaseTimeoutDuration);
      // Dbf.deleteFireBaseStorageItem(userdetails.photoUrl);
    }
  }

  // Get current User from firebase
  static Future<String> getCurrentUserId() async {
    FirebaseUser user = await FirebaseAuth.instance
        .currentUser()
        .catchError((error) => Sentry.report(error))
        .timeout(Duration(seconds: 5));
    return user.uid.toString();
  }

  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance
        .currentUser()
        .catchError((error) => Sentry.report(error))
        .timeout(Duration(seconds: 5));
    return user;
  }

  /// Dowload file from Firebase
  static Future<File> downloadFile(String httpPath) async {
    String fileName = getImageNameFromFullUrl(httpPath);

    final Directory tempDir = Directory.systemTemp;

    try {
      final File file = File('${tempDir.path}/$fileName');
      final StorageReference firebaseStorageReferance =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageFileDownloadTask downloadTask =
          firebaseStorageReferance.writeToFile(file);

      await downloadTask.future;
      return file;
    } catch (e) {
      throw ('e');
    }
  }

  static Future<bool> checkImageFileExists(String httpPath) async {
    String fileName = getImageNameFromFullUrl(httpPath);
    String value;
    try {
      value =
          await FirebaseStorage.instance.ref().child(fileName).getDownloadURL();
    } on PlatformException catch (pe) {
      if (pe.code == "Error -13010") {
        print(pe.message);
      } else {
        throw (pe);
      }
    } catch (e) {
      throw (e);
    }

    bool hasValue;

    if (value != null) {
      hasValue = true;
    } else {
      hasValue = false;
    }
    assert(hasValue is bool, 'value is not bool');
    assert(hasValue != null, 'value is null');

    return hasValue;
  }

  static String getImageNameFromFullUrl(String httpPath) {
    final RegExp regExpPng = RegExp('([^?/]*\.(png))');
    final RegExp regExpjpg = RegExp('([^?/]*\.(jpg))');
    String fileName;

    if (httpPath.contains(RegExp('png'))) {
      fileName = regExpPng.stringMatch(httpPath);
    } else if (httpPath.contains(RegExp('jpg'))) {
      fileName = regExpjpg.stringMatch(httpPath);
    } else {
      throw ('No matching file type');
    }

    assert(fileName != null);
    return fileName;
  }

  /// Update document with referance
  static Future<void> updateProfile(Profile profile) async {
    Map<String, dynamic> _documentProperties =
        await prepareProfileForFirebaseUpload(profile);

    Firestore.instance
        .collection(profile.databaseId)
        .document(profile.objectId)
        .updateData(_documentProperties)
        .whenComplete(() {
      print('Successfully updated ${profile.objectId}');
    }).catchError((error) {
      print(error);
      Sentry.report(error);
    }).timeout(Duration(seconds: 5));
  }

  static Future updateField(
      String collection, String documentRef, String key, dynamic value) async {
    Firestore.instance
        .collection(collection)
        .document(documentRef)
        .updateData({key: value})
        .whenComplete(() {
          print('Successfully updated $documentRef');
        })
        .catchError(Sentry.report)
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timed out when trying to update the database')));
  }

  // static Future<dynamic>

  /// Upload file to Firebase
  static Future<dynamic> upLoadFileReturnUrl(File file, List<String> folders,
      {Function(String) errorHandler}) async {
    StorageReference ref;
    if (folders.length == 0) {
      ref = FirebaseStorage.instance.ref().child(path.basename(file.path));
    } else if (folders.length == 1) {
      ref = FirebaseStorage.instance
          .ref()
          .child(folders[0])
          .child(path.basename(file.path));
    } else if (folders.length == 2) {
      ref = FirebaseStorage.instance
          .ref()
          .child(folders[0])
          .child(folders[1])
          .child(path.basename(file.path));
    } else if (folders.length == 3) {
      ref = FirebaseStorage.instance
          .ref()
          .child(folders[0])
          .child(folders[1])
          .child(folders[2])
          .child(path.basename(file.path));
    } else if (folders.length == 4) {
      ref = FirebaseStorage.instance
          .ref()
          .child(folders[0])
          .child(folders[1])
          .child(folders[2])
          .child(folders[3])
          .child(path.basename(file.path));
    } else {
      ref = FirebaseStorage.instance.ref().child(path.basename(file.path));
    }

    final StorageUploadTask uploadTask = ref.putFile(file);
    uploadTask.events.listen((event) {
      double _progress = event.snapshot.bytesTransferred.toDouble() /
          event.snapshot.totalByteCount.toDouble();
      print(_progress);
    }).onError(Sentry.report);

    var url = await (await uploadTask.onComplete)
        .ref
        .getDownloadURL()
        .catchError((error) {
      errorHandler(error);
    }).timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timed out when trying to Upload the file')));

    assert(url != null, 'url is null');
    assert(url is String, 'url is not a string');
    return url;
  }

  static void deleteFireBaseStorageItem(String fileUrl) {
    if (fileUrl != null && fileUrl != '') {
      String filePath = fileUrl.replaceAll(
          new RegExp(
              r'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/'),
          '');

      filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

      filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

      StorageReference storageReferance = FirebaseStorage.instance.ref();

      storageReferance
          .child(filePath)
          .delete()
          .then((_) => print('Successfully deleted $filePath storage item'))
          .catchError(Sentry.report)
          .timeout(databaseTimeoutDuration,
              onTimeout: () => throw (TimeoutException(
                  'Timed out when trying to delete a Firebase storage item')));
    }
  }

  /// Prepare Profile for FirebaseUpload or Update
  static Future<Map<String, dynamic>> prepareProfileForFirebaseUpload(
      Profile profile) async {
    var imageUrl;

    Map<String, dynamic> _properties = new Map<String, dynamic>();

    for (var i = 0; i < profile.properties.length; i++) {
      _properties[profile.properties[i].databaseId] =
          profile.properties[i].value;
    }

    if (imageUrl != null) {
      _properties[DatabaseIds.imageUrl] = profile.imageUrl;
    }

    String userId = await Dbf.getCurrentUserId();

    if (profile.imageUrl != null) {
      _properties[DatabaseIds.imageUrl] = profile.imageUrl;
    }
    _properties[DatabaseIds.orderNumber] = profile.orderNumber;
    _properties[DatabaseIds.user] = userId;
    _properties[DatabaseIds.public] = profile.isPublic;
    _properties[DatabaseIds.likes] = profile.likes;
    _properties[DatabaseIds.comments] = profile.comments;
    _properties[DatabaseIds.isDeleted] = profile.isDeleted;
    // profile.imageFilePath != null ? _properties[DatabaseIds.imagePath]  = profile.imageFilePath : print("profile.imageFilePath == null");
    profile.imageUrl != null
        ? _properties[DatabaseIds.imageUrl] = profile.imageUrl
        : print("profile.imageFilePath == null");

    if (profile.type == ProfileType.recipe) {
      _properties[DatabaseIds.coffeeId] = profile.getProfileProfileRefernace(
          profileDatabaseId: DatabaseIds.coffee);
      _properties[DatabaseIds.waterID] = profile.getProfileProfileRefernace(
          profileDatabaseId: DatabaseIds.water);
      _properties[DatabaseIds.grinderId] = profile.getProfileProfileRefernace(
          profileDatabaseId: DatabaseIds.grinder);
      _properties[DatabaseIds.barista] = profile.getProfileProfileRefernace(
          profileDatabaseId: DatabaseIds.Barista);
      _properties[DatabaseIds.equipmentId] = profile.getProfileProfileRefernace(
          profileDatabaseId: DatabaseIds.brewingEquipment);
    }

    return _properties;
  }

  /// Delete profile
  static Future<void> deleteProfile(Profile profile) async {
    Firestore.instance
        .collection(profile.databaseId)
        .document(profile.objectId)
        .delete()
        .catchError((e) {
      print(e);
      Sentry.report(e);
    }).timeout(Duration(seconds: 5));
  }

  static void archiveProfile(Profile profile) async {
    Dbf.updateField(
            profile.databaseId, profile.objectId, DatabaseIds.isDeleted, true)
        .catchError(Sentry.report)
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timed out when trying to archive profile')));
  }

  /// Save profile
  static Future<Profile> saveProfile(Profile profile) async {
    Map<String, dynamic> _properties =
        await Dbf.prepareProfileForFirebaseUpload(profile);

    DocumentReference documentReference = await Firestore.instance
        .collection(profile.databaseId)
        .add(_properties)
        .catchError((error) {
      print(error);
      Sentry.report(error);
    }).timeout(Duration(seconds: 5));

    final String docId = documentReference.documentID;

    print('profile $docId was saved successfully');

    profile.objectId = docId;

    return profile;
  }

  static Future<int> getCount(ProfileType profileType, String userId) async {
    var snaps = Firestore.instance
        .collection(Functions.getProfileTypeDatabaseId(profileType))
        .where(DatabaseIds.user, isEqualTo: userId)
        .where(DatabaseIds.isDeleted, isEqualTo: false);

    var querySnapshot = await snaps.getDocuments();

    var totalEquals = querySnapshot.documents.length;

    return totalEquals ?? 0;
  }

  static Future<int> getUserSessionsCount(String userId) async {
    QuerySnapshot snaps = await Firestore.instance
        .collection(DatabaseIds.User)
        .where(DatabaseIds.User, isEqualTo: userId)
        .getDocuments()
        .catchError(Sentry.report);

    int count;

    if (snaps.documents.length > 0) {
      count = snaps.documents[0].data[DatabaseIds.logIns] ?? 0;
    } else {
      count = 0;
    }

    return count ?? 0;
  }

  /// Get Image from assets
  static void getImageFromAssets(String id, Function completion(Image image)) {
    Image pic = Image.asset(id);
    completion(pic);
  }

  static FutureOr printFuture(String message) async {
    print(message);
  }

  /// Get profiles from from store with doc referance
  static Future<Profile> getProfileFromFireStoreWithDocRef(
      String collectionDataBaseId, String docRefernace) async {
    Profile _profile;

    if (docRefernace != '') {
      DocumentSnapshot doc = await Firestore.instance
          .collection(collectionDataBaseId)
          .document(docRefernace)
          .get()
          .catchError(Sentry.report)
          .timeout(Duration(seconds: 15),
              onTimeout: () => throw (TimeoutException(
                  'Took too long to get a profile from Firebase',
                  databaseTimeoutDuration)));

      if (doc.exists) {
        _profile = await Dbf.createProfileFromDocumentSnapshot(
                collectionDataBaseId, doc)
            .catchError(Sentry.report);
      } else {
        _profile = await Profile.createBlankProfile(
                Functions.getProfileDatabaseIdType(collectionDataBaseId))
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      }
    } else {


        List<dynamic> completed = await Future.wait([
            Profile.createBlankProfile(
                Functions.getProfileDatabaseIdType(collectionDataBaseId))
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration))),
            Dbf.getCurrentUserId()
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)))
       ]);  
      _profile = completed[0];

      _profile.userId = completed[1];
    }

    return _profile;
  }

  static Future<List<Profile>> convertStreamToListOfProfiles(
      QuerySnapshot stream, String databaseId) async {
    final futureProfiles = stream.documents
        .map((doc) => Dbf.createProfileFromDocumentSnapshot(databaseId, doc));

    return await Future.wait(futureProfiles).catchError(Sentry.report).timeout(
        databaseTimeoutDuration,
        onTimeout: () => throw (TimeoutException(
            'Took too long to get a profile from Firebase',
            databaseTimeoutDuration)));
  }

  /// Get stream with one argument
  static Stream<QuerySnapshot> getFlavourDescriptorStreamFromFireStore() {
    return Firestore.instance
        .collection(DatabaseIds.flavourDescriptors)
        .snapshots();
  }

  /// Get stream with one argument
  static Stream<dynamic> getStreamFromFireStoreOneArg(
      String collection, String whereKey, dynamic isEqualTo) {
    return Firestore.instance
        .collection(collection)
        .where(whereKey, isEqualTo: isEqualTo)
        .where(DatabaseIds.isDeleted, isEqualTo: false)
        .where(DatabaseIds.isDeleted, isEqualTo: null)
        .snapshots();
  }

  /// Get stream with two arguments
  static Stream<dynamic> getStreamFromFireStoreTwoArgs(
      String collection,
      String whereKeyOne,
      dynamic isEqualToOne,
      String whereKeyTwo,
      dynamic isEqualToTwo) {
    return Firestore.instance
        .collection(collection)
        .where(whereKeyOne, isEqualTo: isEqualToOne)
        .where(whereKeyTwo, isEqualTo: isEqualToTwo)
        .snapshots();
  }

  static Future<List<Profile>> getListOfPublicRecipeProfilesForNOTcurrentUser(
      String userId) async {
    QuerySnapshot docs = await Firestore.instance
        .collection(DatabaseIds.recipe)
        .where(DatabaseIds.user, isEqualTo: userId)
        .where(DatabaseIds.public, isEqualTo: true)
        .where(DatabaseIds.isDeleted, isEqualTo: false)
        .getDocuments()
        .catchError(Sentry.report);

    List<Profile> profiles =
        await Dbf.convertStreamToListOfProfiles(docs, DatabaseIds.recipe);
    assert(profiles != null, 'The list of profiles in null');

    return List<Profile>.from(profiles.reversed);
  }

  static Future<UserProfile> getUserProfileFromFireStoreWithDocRef(
      String docRefernace) async {
    UserProfile _userProfile;

    if (docRefernace != '') {
      DocumentSnapshot doc = await Firestore.instance
          .collection(DatabaseIds.User)
          .document(docRefernace)
          .get()
          .catchError(Sentry.report)
          .timeout(databaseTimeoutDuration,
              onTimeout: () => throw (TimeoutException(
                  'getUserProfileFromFireStoreWithDocRef',
                  databaseTimeoutDuration)));

      if (doc.exists) {
        /// For following
        List<dynamic> following = List<dynamic>.from(
                doc.data[DatabaseIds.following] ?? List<dynamic>()) ??
            List<dynamic>();

        List<String> followingRevisedList = new List<String>();

        following.forEach((follow) {
          if (follow is String) {
            followingRevisedList.add(follow);
          }
        });

        /// For followers
        List<dynamic> followers = List<dynamic>.from(
                doc.data[DatabaseIds.followers] ?? List<dynamic>()) ??
            List<dynamic>();

        List<String> followersRevisedList = new List<String>();

        followers.forEach((follow) {
          if (follow is String) {
            followersRevisedList.add(follow);
          }
        });

        _userProfile = new UserProfile(
            docRefernace,
            doc.data[DatabaseIds.userName] ?? '',
            doc.data[DatabaseIds.imageUrl] ?? '',
            followingRevisedList ??= List<String>(),
            followersRevisedList ??= List<String>(),
            doc.data[DatabaseIds.motto] ?? '',
            logInsIn: doc.data[DatabaseIds.logIns] ?? 0);

        assert(_userProfile != null, '_userProfile == null');
      }
    }
    assert(_userProfile != null, '_userProfile == null');
    return _userProfile;
  }

  /// Get value from collection with key
  static Future<dynamic> getValueFromFireStoreWithDocRef(
      String collectionDataBaseId, String docRefernace, String key) async {
    dynamic _value;

    if (docRefernace != '') {
      DocumentSnapshot doc = await Firestore.instance
          .collection(collectionDataBaseId)
          .document(docRefernace)
          .get()
          .catchError(Sentry.report);

      if (doc.exists) {
        if (doc.data.length > 0) {
          _value = doc.data[key];
        } else {
          _value = '';
        }
      } else {
        throw Error();
      }
    } else {
      throw Error();
    }

    return _value;
  }

  /// Convert profiles from data snapshot
  static Future<List<Profile>> createProfilesFromDataSnapshot(
      String databaseId, List<DocumentSnapshot> data) async {
    List<Profile> documents = new List<Profile>();

    data.forEach((document) {
      createProfileFromDocumentSnapshot(databaseId, document).then(((profile) {
        documents.add(profile);
      }));
    });

    return documents;
  }

  /// Convert profile from document snapshot
  static Future<Profile> createProfileFromDocumentSnapshot(
      String databaseId, DocumentSnapshot document) async {
    Profile newProfile = await Profile.createBlankProfile(
            Functions.getProfileDatabaseIdType(databaseId))
        .catchError(Sentry.report)
        .timeout(Duration(seconds: 8), onTimeout: () {
      throw (TimeoutException('Took too long to get a profile from Firebase',
          databaseTimeoutDuration));
    });

    DateTime _updatedAt;
    if (document[DatabaseIds.updatedAt] != null) {
      _updatedAt = (document[DatabaseIds.updatedAt] as Timestamp).toDate() ??
          DateTime.now();
    } else {
      _updatedAt = DateTime.now();
    }

    String _user = document[DatabaseIds.user] ?? '';
    String _objectId = document.documentID ?? '';
    int _orderNumber = document[DatabaseIds.orderNumber] ?? 0;
    String _image = document[DatabaseIds.imageUrl] ?? '';
    bool _ispublic = document.data[DatabaseIds.public] ?? false;

    List<dynamic> likesIn = document.data[DatabaseIds.likes] ?? List<dynamic>();
    List<String> likes = List<String>.from(likesIn);

    bool isDeleted = document.data[DatabaseIds.isDeleted] ?? false;

    List<Map<String, String>> comments;
    if (document.data[DatabaseIds.comments] != null) {
      comments =
          List<Map<String, String>>.from(document.data[DatabaseIds.comments]) ??
              List<dynamic>();
    } else {
      comments = List<Map<String, String>>();
    }

    Future<Profile> _coffee;
    Future<Profile> _barista;
    Future<Profile> _equipment;
    Future<Profile> _grinder;
    Future<Profile> _water;

    if (document.data.containsKey(DatabaseIds.updatedAt)) {
      _updatedAt = (document[DatabaseIds.updatedAt] as Timestamp).toDate();
    } else {
      _updatedAt = DateTime.now();
    }
    if (document.data.containsKey(DatabaseIds.orderNumber)) {
      _orderNumber = document.data[DatabaseIds.orderNumber];
    } else {
      _orderNumber = 0;
    }

    if (databaseId == DatabaseIds.recipe) {
      if (document.data.containsKey(DatabaseIds.coffeeId) &&
          document.data[DatabaseIds.coffeeId] != "") {
        _coffee = Dbf.getProfileFromFireStoreWithDocRef(
                DatabaseIds.coffee, document.data[DatabaseIds.coffeeId])
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      } else {
        _coffee = Profile.createBlankProfile(ProfileType.coffee)
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      }

      if (document.data.containsKey(DatabaseIds.barista) &&
          document.data[DatabaseIds.barista] != "") {
        _barista = Dbf.getProfileFromFireStoreWithDocRef(
                DatabaseIds.Barista, document.data[DatabaseIds.barista])
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      } else {
        _barista = Profile.createBlankProfile(ProfileType.barista)
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      }

      if (document.data.containsKey(DatabaseIds.equipmentId) &&
          document.data[DatabaseIds.Barista] != "") {
        _equipment = Dbf.getProfileFromFireStoreWithDocRef(
                DatabaseIds.brewingEquipment,
                document.data[DatabaseIds.equipmentId])
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      } else {
        _equipment = Profile.createBlankProfile(ProfileType.equipment)
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      }

      if (document.data.containsKey(DatabaseIds.grinderId) &&
          document.data[DatabaseIds.grinderId] != "") {
        _grinder = Dbf.getProfileFromFireStoreWithDocRef(
                DatabaseIds.grinder, document.data[DatabaseIds.grinderId])
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      } else {
        _grinder = Profile.createBlankProfile(ProfileType.grinder)
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      }

      if (document.data.containsKey(DatabaseIds.waterID) &&
          document.data[DatabaseIds.waterID] != "") {
        _water = Dbf.getProfileFromFireStoreWithDocRef(
                DatabaseIds.water, document.data[DatabaseIds.waterID])
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      } else {
        _water = Profile.createBlankProfile(ProfileType.water)
            .catchError(Sentry.report)
            .timeout(databaseTimeoutDuration,
                onTimeout: () => throw (TimeoutException(
                    'Took too long to get a profile from Firebase',
                    databaseTimeoutDuration)));
      }
    }

    List<Profile> subProfiles;

    if (databaseId == DatabaseIds.recipe) {
        subProfiles =  await Future.wait([ 
            _coffee,
            _barista,
            _equipment,
            _grinder,
            _water,
        ]); 
    } else {
        subProfiles = new List<Profile>();
    } 
        

        document.data.forEach((key, value) {
        if (key != DatabaseIds.updatedAt) {
            if (key != DatabaseIds.orderNumber) {
            if (key != DatabaseIds.imageUrl) {
                if (key != DatabaseIds.public) {
                if (key != DatabaseIds.user) {
                    newProfile.properties.forEach((item) {
                    if (item.databaseId == key) {
                        if (value == Timestamp || value is Timestamp) {
                        item.value = (value as Timestamp).toDate();
                        } else {
                        item.value = value;
                        }
                    }
                    });
                }
                }
            }
            }
        }
        });

        Profile _returnProfile;

        switch (databaseId) {
        case DatabaseIds.recipe:
            return new Profile(
                isDeleted: isDeleted,
                comments: comments,
                likes: likes,
                userId: _user,
                isPublic: _ispublic,
                updatedAt: _updatedAt,
                objectId: _objectId,
                type: ProfileType.recipe,
                imageUrl: _image,
                // imageFilePath: _imagePath,
                databaseId: databaseId,
                orderNumber: _orderNumber,
                properties: newProfile.properties,
                profiles: subProfiles);
            break;

      case DatabaseIds.coffee:
        _returnProfile = new Profile(
            isDeleted: isDeleted,
            comments: comments,
            likes: likes,
            userId: _user,
            isPublic: _ispublic,
            updatedAt: DateTime.now(),
            objectId: _objectId,
            type: ProfileType.coffee,
            imageUrl: _image,
            databaseId: databaseId,
            orderNumber: _orderNumber,
            properties: newProfile.properties);
        break;

      case DatabaseIds.grinder:
        _returnProfile = new Profile(
            isDeleted: isDeleted,
            comments: comments,
            likes: likes,
            userId: _user,
            isPublic: _ispublic,
            updatedAt: DateTime.now(),
            objectId: _objectId,
            type: ProfileType.grinder,
            imageUrl: _image,
            databaseId: databaseId,
            orderNumber: _orderNumber,
            properties: newProfile.properties);
        break;

      case DatabaseIds.brewingEquipment:
        _returnProfile = new Profile(
            isDeleted: isDeleted,
            comments: comments,
            likes: likes,
            userId: _user,
            isPublic: _ispublic,
            updatedAt: DateTime.now(),
            objectId: _objectId,
            type: ProfileType.equipment,
            imageUrl: _image,
            databaseId: databaseId,
            orderNumber: _orderNumber,
            properties: newProfile.properties);
        break;

      case DatabaseIds.water:
        _returnProfile = new Profile(
            isDeleted: isDeleted,
            comments: comments,
            likes: likes,
            userId: _user,
            isPublic: _ispublic,
            updatedAt: DateTime.now(),
            objectId: _objectId,
            type: ProfileType.water,
            imageUrl: _image,
            databaseId: databaseId,
            orderNumber: _orderNumber,
            properties: newProfile.properties);
        break;

      case DatabaseIds.Barista:
        _returnProfile = new Profile(
            isDeleted: isDeleted,
            comments: comments,
            likes: likes,
            userId: _user,
            isPublic: _ispublic,
            updatedAt: DateTime.now(),
            objectId: _objectId,
            type: ProfileType.barista,
            imageUrl: _image,
            databaseId: databaseId,
            orderNumber: _orderNumber,
            properties: newProfile.properties);
        break;

      default:
        Error();
        break;
    }

    assert(_returnProfile != null, "The return profile is null");

    return _returnProfile;
  }

  /// Give user profile name and photo
  static Future<void> updateUserProfileWithNameAndPhoto(
    String displayName,
    String photoUrl,
  ) async {
    var user = await FirebaseAuth.instance.currentUser();

    UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = displayName;
    info.photoUrl = photoUrl;
    user.updateProfile(info).then((a) {
      // Update successful.
      print('Sucessfully updated $user');
    }).catchError((error) {
      // An error happened.
      Sentry.report(error);
      print(error);
    }).timeout(databaseTimeoutDuration,
        onTimeout: () => throw (TimeoutException(
            'updateUserProfileWithNameAndPhoto', databaseTimeoutDuration)));
  }

  static Future<bool> saveFlavourDescriptor(
      FlavourDescriptor descriptor) async {
    bool wasSuccessfull = false;
    Map<String, dynamic> values = descriptor.values;
    values[DatabaseIds.type] = descriptor.typeString;

    QuerySnapshot docs = await Firestore.instance
        .collection(DatabaseIds.flavourDescriptors)
        .where(DatabaseIds.name, isEqualTo: descriptor.name)
        .where(DatabaseIds.name, isEqualTo: descriptor.name.toLowerCase())
        .where(DatabaseIds.name, isEqualTo: descriptor.name.toUpperCase())
        .getDocuments();

    if (docs.documents.length == 0) {
               DocumentReference doc = await Firestore.instance
                    .collection(DatabaseIds.flavourDescriptors)
                    .add(descriptor.values);
                print('Saved flavour descriptor ${doc.documentID}');
                wasSuccessfull = true;
        
    }else{
        for (var i = 0; i < docs.documents.length; i++) {
            if (docs.documents[i].data['name'].toString().toLowerCase() == descriptor.name.toLowerCase()) {
               DocumentReference doc = await Firestore.instance
                    .collection(DatabaseIds.flavourDescriptors)
                    .add(descriptor.values);
                print('Saved flavour descriptor ${doc.documentID}');
                wasSuccessfull = true;
            }
        }
    }
    return wasSuccessfull ?? false;
    }
}

class CurrentUserDetailsStream {
  Stream<FirebaseUser> userStream;
  BehaviorSubject<UserDetails> userDetailsStreamcontroller =
      BehaviorSubject<UserDetails>();

  CurrentUserDetailsStream() {
    userStream = Dbf.getCurrentUserStream();
    userStream.listen(forUserDetails);
  }

  Stream<UserDetails> get userDetailsStream =>
      userDetailsStreamcontroller.stream;

  void dipose() {
    userDetailsStreamcontroller.close();
  }

  void forUserDetails(FirebaseUser user) {
    if (user != null) {
      UserDetails userDetails = UserDetails(
        idIn: user.uid,
        emailIn: user.email,
      );
      userDetailsStreamcontroller.add(userDetails);
    }
  }
}

class CurrentUserProfileStream {
  Stream<UserDetails> userStream;
  BehaviorSubject<UserProfile> userProfileStreamcontroller =
      BehaviorSubject<UserProfile>();

  CurrentUserProfileStream(Stream<UserDetails> userDetailsStream) {
    userStream = userDetailsStream;
    userStream.listen(forUserProfile);
  }

  Stream<UserProfile> get userProfileStream =>
      userProfileStreamcontroller.stream;

  void dipose() {
    userProfileStreamcontroller.close();
  }

  void forUserProfile(UserDetails user) {
    Stream<DocumentSnapshot> userSnapshotStream = Firestore.instance
        .collection(DatabaseIds.User)
        .document(user.id)
        .snapshots();

    userSnapshotStream.listen((doc) {
      if (doc.exists) {
        List<String> newFollowingList;
        List<String> newFollowersList;

        doc.data[DatabaseIds.following] != null
            ? newFollowingList = List<String>.from(
                doc.data[DatabaseIds.following] as List<dynamic>)
            : newFollowingList = List<String>();
        doc.data[DatabaseIds.followers] != null
            ? newFollowersList = List<String>.from(
                doc.data[DatabaseIds.followers] as List<dynamic>)
            : newFollowersList = List<String>();

        UserProfile userProfile = new UserProfile(
            doc.data[DatabaseIds.user] as String ??
                'Error: submit feedback database_functions.dart => line 976',
            doc.data[DatabaseIds.userName] as String ??
                'Error: submit feedback database_functions.dart => line 977',
            doc.data[DatabaseIds.imageUrl] as String ??
                'Error: submit feedback database_functions.dart => line 778',
            newFollowingList,
            newFollowersList,
            doc.data[DatabaseIds.motto] as String ??
                'Error: submit feedback database_functions.dart => line 981w',
            logInsIn: doc.data[DatabaseIds.logIns] ?? 0);
        userProfileStreamcontroller.add(userProfile);
      }
    });
  }
}

class LocalStorage {
  static deleteFile(File file) async {
    if (await file.exists()) {
      file.delete(recursive: true).catchError(Sentry.report).timeout(
          databaseTimeoutDuration,
          onTimeout: () => throw (TimeoutException(
              'Timed out on saving local file', databaseTimeoutDuration)));
    }
  }

  static Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> get localFile async {
    final path = await localPath;
    return File('$path/');
  }

    static Future<String> readData() async {
        try {
        final file = await localFile;
        String body = await file.readAsString();

        return body;
        } catch (e) {
        return e.toString();
        }
    }

  static Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }

  static Future<String> saveFileToDeviceReturnPath(File image) async {
    File oldImage = image;
    final String locaPath = await LocalStorage.localPath;

    String fileType = Functions.getFileType(image.path);

    String fileName = Functions.getRandomNumber();

    final String path = '$locaPath/$fileName.$fileType';

    final File newImage = await oldImage
        .copy(path)
        .catchError((e) => Sentry.report(e))
        .timeout(databaseTimeoutDuration,
            onTimeout: () => throw (TimeoutException(
                'Timed out on saving local file', databaseTimeoutDuration)));

    return newImage.path;
  }
}

class DatabaseIds {
  static const String lrr = 'lrr';
  static const String stoneFruit = 'stoneFruit';
  static const String citrus = 'citrus';
  static const String malic = 'malic';
  static const String tropical = 'tropical';
  static const String referance = 'referance';
  static const String description = 'description';
  static const String acidity = 'acidity';
  static const String floral = 'floral';
  static const String fruity = 'fruity';
  static const String roast = 'roast';
  static const String spicey = 'spicey';
  static const String vegetal = 'vegetal';
  static const String grain = 'grain';
  static const String flavourType = 'flavourType';
  static const String flavourDescriptors = 'FlavourDescriptors';
  static const String isDeleted = 'isDeleted';
  static const String currentVersion = 'currentVersion';
  static const String updates = 'Updates';
  static const String images = 'images';
  static const String motto = 'motto';
  static const String comments = 'comments';
  static const String likes = 'likes';
  static const String followers = 'followers';
  static const String userId = 'userId';
  static const String logIns = 'logIns';
  static const String success = 'success';
  static const String community = 'communtiy';
  static const String following = 'following';
  static const String roasterName = 'roasterName';
  static const String harvest = 'harvest';
  static const String feed = 'feed';
  static const String strength = 'strength';
  static const String friends = 'friends';
  static const String public = 'public';
  static const String age = 'age';
  static const String viewContollerId = 'viewContollerId';
  static const String type = 'type';
  static const String databaseId = 'databaseId';
  static const String coreDataId = 'coreDataId';
  static const String updatedAt = 'updatedAt';
  static const String userName = 'userName';
  static const String email = 'email';
  static const String currentUser = 'currentUser';
  static const String password = 'password';
  static const String objectId = 'objectId';
  static const String brewWeight = 'brewWeight';
  static const String Barista = 'Barista';
  static const String name = 'name';
  static const String data = 'data';
  static const String User = 'User';
  static const String altitude = 'altitude';
  static const String method = 'method';
  static const String density = 'density';
  static const String moisture = 'moistureContent';
  static const String aW = 'waterActivity';
  static const String notes = 'notes';
  static const String level = 'level';
  static const String barista = 'barista';
  static const String date = 'date';
  static const String totalScore = 'totalScore';
  static const String recipeId = 'recipeId';
  static const String tasteBalance = 'tasteBalance';
  static const String tactile = 'tactile';
  static const String sweet = 'sweet';
  static const String acidic = 'acidic';
  static const String flavour = 'flavour';
  static const String bitter = 'bitter';
  static const String weight = 'weight';
  static const String texture = 'texture';
  static const String finish = 'finish';
  static const String grindSetting = 'grindSetting';
  static const String descriptors = 'descriptors';
  static const String body = 'body';
  static const String balance = 'balance';
  static const String afterTaste = 'afterTaste';
  static const String water = 'Water';
  static const String brewingEquipment = 'BrewingEquipment';
  static const String coffee = 'Coffee';
  static const String grinder = 'Grinder';
  static const String creationDate = 'createdAt';
  static const String recipe = 'Recipe';
  static const String brewingDose = 'dose';
  static const String yielde = 'yield';
  static const String time = 'time';
  static const String temparature = 'temparature';
  static const String tds = 'tds';
  static const String score = 'score';
  static const String preinfusion = 'preInfusion';
  static const String coffeeId = 'coffeeID';
  static const String producer = 'producer';
  static const String lot = 'lot';
  static const String farm = 'farm';
  static const String region = 'region';
  static const String country = 'country';
  static const String beanType = 'beanType';
  static const String beanSize = 'beanSize';
  static const String roastProfile = 'roastProfile';
  static const String roastDate = 'roastDate';
  static const String processingMethod = 'processingMethod';
  static const String roasteryName = 'roasteryName';
  static const String grinderId = 'grinderId';
  static const String grinderMake = 'grinderMake';
  static const String grinderModel = 'grinderModel';
  static const String equipmentMake = 'equipmentMake';
  static const String equipmentModel = 'equipmentModel';
  static const String burrs = 'burrs';
  static const String testTemparature = 'testTemparature';
  static const String gh = 'gh';
  static const String kh = 'kh';
  static const String ppm = 'ppm';
  static const String ph = 'ph';
  static const String equipmentId = 'equipmentId';
  static const String equipmentType = 'equipmentType';
  static const String waterID = 'waterId';
  static const String user = 'user';
  static const String userImage = 'userPicture';
  static const String brewingEquipmentImage = 'brewingEquipmentImage';
  static const String coffeeImage = 'coffeeImage';
  static const String grinderImage = 'grinderImage';
  static const String recipeImage = 'recipeImage';
  static const String waterImage = 'waterImage';
  static const String picture = 'picture';
  static const String imagePath = 'imagePath';
  static const String imageUrl = 'image';
  static const String orderNumber = 'orderNumber';
}

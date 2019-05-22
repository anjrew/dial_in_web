import 'profile_card.dart';
import 'social_feed_card.dart';
import 'package:flutter_web/cupertino.dart';
import 'database_functions.dart';
import 'strings.dart';
import 'package:flutter_web/material.dart';
import 'profile.dart';
import 'dart:math' as math;
import 'dart:io';
import 'dart:async';
import 'package:flutter_web/services.dart';
import 'dart:typed_data';
import 'dart:io' as Io;
import 'mini_classes.dart';
import 'images.dart';

class Functions {

  static String getFileType(String path){
    
    final RegExp regExpPng = RegExp(r'(png)');
    final RegExp regExpjpg = RegExp(r'jpg');
    String fileName;

    if (path.contains(regExpPng)){ fileName = 'png';}
    else if (path.contains(regExpjpg)){ fileName = 'jpg';}
    else {throw('No matching file type') ;}
    
    assert(fileName != null);
    return fileName;
  }

  static String getProfileImagePlaceholder(ProfileType profileType){

    String placeHolder;

    switch(profileType){

      case ProfileType.barista : placeHolder = Images.user; break;           
      case ProfileType.coffee : placeHolder = Images.coffeeBeans; break;
      case ProfileType.equipment : placeHolder = Images.aeropressSmaller512x512; break;
      case ProfileType.grinder : placeHolder = Images.grinder; break;
      case ProfileType.recipe : placeHolder = Images.recipeSmaller; break;
      case ProfileType.water : placeHolder = Images.water; break; 
    }

    assert(placeHolder != null, 'placeHolder is null');

    return placeHolder?? '';
  }

   static int getIntValue(dynamic item){

    int value;
    
    if (item == null){value = 0;}
    else if (item is String && item == ''){value = 0;}
    else if (item is String && item != '')
    { double trans = double.parse(item);
      value = trans.toInt();}
    else if (item is double){value = item.round().toInt();}
    else if (item is !int || item is !double){value = 0;}
    else{value = item.value;}

    return value;
   }

  static double getDoubleValue(dynamic item){

    int value = Functions.getIntValue(item);
    
    assert(value != null ,'Value is null');

    return value.toDouble();
   }

  static String convertSecsToMinsAndSec(int timeInput){
        
        int timeSecs = timeInput;
        
        int minutes = (timeSecs / 60).floor();
        int seconds = timeSecs % 60;
            
        return "$minutes minutes and $seconds seconds";
    }



    static String convertSecsmmss(int timeInput){
        
        int timeSecs = timeInput;
        String timeString;
        
        int minutes = (timeSecs / 60).floor();
        int seconds = timeSecs % 60;
        
        if (minutes < 10 && seconds < 10){
            
            timeString = "0$minutes:0$seconds";
            
        }else if (minutes < 10) {
            
            timeString = "0$minutes:$seconds";
            
        }else if (seconds < 10) {
            
            timeString = "$minutes:0$seconds";
            
            
        } else {
            
            timeString = "$minutes:$seconds";
            
        }
        return timeString;
    }
/// Get Numbers 0 to fifity nine
  static List<int> oneToFiftynine(){

    List<int> numbers = new List<int>();

    for (var i = 0; i < 60; i++) {
        numbers.add(i);
    }
    return numbers;
  }


  static String getTwoNumberRatio(int first, int second){

    List<int> newNumbers = getRatio([first,second]);

    return '${newNumbers[0]} : ${newNumbers[1]}';

  }

/// Get ratio
  static List<int> getRatio (List<int> numbers){

    List<int> numbersSorted = numbers;

    // numbersSorted.sort((a, b) => a.compareTo(b));

    List<List<int>> factorList = new List<List<int>>();

    /// Find factors for each number

    /// Find matching values
    for (var i = 0; i < numbersSorted.length; i++) {

      List<int> factors = new  List<int>();

      for (var x = 0 ; x <= numbersSorted[i]; x++) {

        if (numbersSorted[i].toDouble() % x.toDouble() == 0){factors.add(x);}
      }
      factors.add(numbersSorted[i]);
      factorList.add(factors);
    }

    List<int> commonFactors = new List<int>();

    /// Find matching values
    for (var i = 0; i < factorList.length - 1; i++) {

      for (var x = 0; x < factorList[i].length; x++){

       for (var y = 0; y < factorList[i + 1].length; y++){

          if(factorList[i][x] == factorList[i + 1][y]){

            if (i > 0){
              for (var z = 0; z < factorList[i - 1].length ; z++) {
                
                if(factorList[i][x] == factorList[i - 1][z]){

                  commonFactors.add(factorList[i][x]);

                }
              }
            }else{
                  commonFactors.add(factorList[i][x]);
            }
         }
       }
      }
    }

    if (commonFactors.length > 0){
      
      int highestDemoniator = commonFactors.reduce((current, next){

        if (current > next){return current;}
        else{ return next; }

      });

    if (highestDemoniator > 0){

      List<int> newNumbers =  new List<int>();

     for (var x = 0; x < numbersSorted.length; x++){

       int number = numbersSorted[x] ~/ highestDemoniator;
       newNumbers.add(number);

      }
      return newNumbers;}
      else{  return numbersSorted; }
    }

    else{ return numbersSorted;}
     
  }  

  static File fileToPng(File file){
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  Image.Image image = Image.decodeImage(file.readAsBytesSync());

  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  Image.Image thumbnail = Image.copyResize(image, 120);
  final String filename = '${math.Random().nextInt(10000)}.png';
  // Save the thumbnail as a PNG.
  File returnFile =new Io.File(filename) ..writeAsBytesSync(Image.encodePng(thumbnail));

  return returnFile;      
}

  
  static File fileToJpg(File file){
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  Image.Image image = Image.decodeImage(file.readAsBytesSync());

  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  Image.Image thumbnail = Image.copyResize(image, 120);
  final String filename = '${math.Random().nextInt(10000)}.jpg';
  // Save the thumbnail as a PNG.
  File returnFile =new Io.File(filename) ..writeAsBytesSync(Image.encodeJpg(thumbnail));

  return returnFile;      
 } 

  
  static Future<File> getPictureFile(String filePath) async {
    // get the path to the document directory.
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = appDocDir.path;
    return new File('/Users/earyzhe/Dropbox/dev/flutter_webProjects/dial_in_web/$filePath');
  }

  static Future<File> getFile(String filepath)async{
    final ByteData bytes = await rootBundle.load(filepath);
    final Directory tempDir = Directory.systemTemp;
    final String filename = '${math.Random().nextInt(10000)}.png';
    final File file = File('${tempDir.path}/$filename');
    file.writeAsBytes(bytes.buffer.asUint8List(), mode: FileMode.write);
    return file;
  }

  static String getRandomNumber(){
    var rng = new math.Random();
    var code = rng.nextInt(900000) + 100000;
    return code.toString();
  }

  static Profile setProfileItemValue({Profile profile, String keyDatabaseId, dynamic value}) {
    for (var i = 0; i < profile.properties.length; i++) {
      if (profile.properties[i].databaseId == keyDatabaseId) {
        profile.properties[i].value = value;
      }
    }
    return profile;
  }

  static String getProfileTypeString(ProfileType type) {

    switch (type) {

      case ProfileType.recipe:
        return StringLabels.recipe;
        break;

      case ProfileType.coffee:
        return StringLabels.coffee;
        break;

      case ProfileType.water:
        return StringLabels.water;
        break;

      case ProfileType.equipment:
        return StringLabels.method;
        break;

      case ProfileType.grinder:
        return StringLabels.grinder;
        break;

      case ProfileType.barista:
        return StringLabels.barista;
        break;

      default:
        return StringLabels.error;
        break;
    }
  }

  static String getProfileTypeDatabaseId(ProfileType type) {

    String returnValue;

    switch (type) {

      case ProfileType.recipe:
        returnValue = DatabaseIds.recipe;
        break;

      case ProfileType.coffee:
        returnValue = DatabaseIds.coffee;
        break;

      case ProfileType.water:
        returnValue = DatabaseIds.water;
        break;

      case ProfileType.equipment:
        returnValue = DatabaseIds.brewingEquipment;
        break;

      case ProfileType.grinder:
        returnValue = DatabaseIds.grinder;
        break;

      case ProfileType.barista:
        returnValue = DatabaseIds.Barista;
        break;

      default:
        assert(true, 'No match in switch statement' );
        break;
    }
    assert(returnValue != null, 'returnValue is null' );
    return returnValue;
  }

  static ProfileType getProfileDatabaseIdType(String type) {

    ProfileType result;

    switch (type) {
      case DatabaseIds.recipe:
        result = ProfileType.recipe;
        break;

      case DatabaseIds.coffee:
        result = ProfileType.coffee;
        break;

      case DatabaseIds.water:
        result = ProfileType.water;
        break;

      case DatabaseIds.brewingEquipment:
        result = ProfileType.equipment;
        break;

      case DatabaseIds.grinder:
        result = ProfileType.grinder;
        break;

      case DatabaseIds.Barista:
        result = ProfileType.barista;
        break;

      default: Error();
        break;
    }

    assert(result != null , 'result is null');

    return result;
  }

  static String convertDatabaseIdToTitle(String databaseId) {
    switch (databaseId) {
      case DatabaseIds.recipe:
        return StringLabels.recipe;
        break;

      case DatabaseIds.coffee:
        return StringLabels.coffee;
        break;

      case DatabaseIds.water:
        return StringLabels.water;
        break;

      case DatabaseIds.brewingEquipment:
        return StringLabels.method;
        break;

      case DatabaseIds.grinder:
        return StringLabels.grinder;
        break;

      case DatabaseIds.Barista:
        return StringLabels.barista;
        break;

      case DatabaseIds.method:
        return StringLabels.method;
        break;

      default:
        return 'Error';
        break;
    }
  }

 
 
  static Future<List<Widget>> buildFeedCardArray(
     BuildContext context, AsyncSnapshot documents, Function(FeedProfileData, String) giveProfile, Function(UserProfile, String) _giveUserProfile, String index) async {

    List<Widget> _cardArray = new List<Widget>();

     if (documents.data.documents != null || documents.data.documents.length != 0) {

        for(var document in documents.data.documents){  /// <<<<==== changed line
            Widget result = await buildFeedCardFromDocument(context, document, giveProfile, _giveUserProfile, index);
            _cardArray.add(result);
        }
     }
      return _cardArray;
  }
  
  /// Create feed Profile from profile
  static Future<FeedProfileData> createFeedProfileFromProfile(Profile profile)async{

    UserProfile userProfile = await Dbf.getUserProfileFromFireStoreWithDocRef(profile.userId);

    assert(userProfile != null , 'UserProfile is null');

    return FeedProfileData(profile, userProfile);
  }

      // Method that return count of the given 
    // character in the string 
  static int countChacters(String string, String c) 
    { 
        int res = 0; 
  
        for (int i=0; i< string.length; i++) 
        { 
            // checking character in string 
            if (string[i] == c) 
            res++; 
        }  
        return res; 
    } 


  static Future<Widget> buildFeedCardFromProfile
  (Profile profile, Function(FeedProfileData, String) giveprofile, Function(UserProfile, String) _giveUserProfile, String index) async {
    
    FeedProfileData feedProfile = await Functions.createFeedProfileFromProfile(profile);

    return SocialFeedCard(feedProfile, giveprofile, _giveUserProfile, index);
  }

  static Future<Widget> buildFeedCardFromDocument
  (BuildContext context, DocumentSnapshot document, Function(FeedProfileData, String) giveprofile, Function(UserProfile, String) _giveUserProfile, String index) async {
    
    Profile profile = await Dbf.createProfileFromDocumentSnapshot(DatabaseIds.recipe, document);
    FeedProfileData feedProfile = await Functions.createFeedProfileFromProfile(profile);
    return SocialFeedCard(feedProfile, giveprofile, _giveUserProfile, index);
  }
  
  static Future<Widget> buildProfileCardFromDocument(DocumentSnapshot document, String databaseId, Function(Profile, BuildContext, String) giveprofile, Function(Profile, BuildContext, String) deleteProfile, Animation<double> animation, String index, bool isDeletable) async {
    
    Profile profile = await Dbf.createProfileFromDocumentSnapshot(databaseId, document);

    return ProfileCard(index, profile, giveprofile, deleteProfile, animation, isDeletable:isDeletable );
  }

  static Future<List<Widget>> buildProfileCardArrayFromAsyncSnapshot( BuildContext context, AsyncSnapshot<List<Widget>> snapshot, String databaseId, Function(Profile) giveProfile, Function(Profile) deleteProfile) async {
      
    List<Widget> _cardArray = new List<Widget>();

     if (snapshot.data != null || snapshot.data.length != 0) {

        for(var document in snapshot.data){  /// <<<<==== changed line        
            _cardArray.add(document);
        }
     }
      return _cardArray;
  }

  static Future<List<Widget>> buildProfileCardArrayFromProfileList(List<Profile> profileList, String databaseId, Function(Profile,BuildContext, String) giveProfile, Function(Profile, BuildContext, String) deleteProfile, Animation<double> animation, String index, bool isDeletable) async {

    List<Widget> _cardArray = new List<Widget>();

     if (profileList != null || profileList.length != 0) {

        for(var profile in profileList){  /// <<<<==== changed line
            Widget result = ProfileCard(index, profile, giveProfile, deleteProfile, animation, isDeletable: isDeletable,);
            _cardArray.add(result);
        }
     }
      return _cardArray;
    }

    static String getStringValueOfSortingMethod(ListSortingOptions type){
    String returnValue;

    switch (type) {
      case ListSortingOptions.alphabeticallyAcending:  returnValue = 'Alphabetically Acending'; break;
      case ListSortingOptions.alphabeticallyDecending: returnValue = 'Alphabetically Decending'; break;
      case ListSortingOptions.valueAcending: returnValue = 'Value decending'; break;
      case ListSortingOptions.valueDecending: returnValue = 'Value acending'; break;
      case ListSortingOptions.mostRecent: returnValue = 'Most recent'; break;
      case ListSortingOptions.oldest: returnValue = 'Oldest'; break;
    }
    assert(returnValue != null , 'Return value is null');
    return returnValue;
  }

      static String getIconValueOfSortingMethod(ListSortingOptions type){
    String returnValue;

    switch (type) {
      case ListSortingOptions.alphabeticallyAcending:  returnValue = 'ABC'; break;
      case ListSortingOptions.alphabeticallyDecending: returnValue = 'ZYX'; break;
      case ListSortingOptions.valueAcending: returnValue = '123'; break;
      case ListSortingOptions.valueDecending: returnValue = '321'; break;
      case ListSortingOptions.mostRecent: returnValue = '<'; break;
      case ListSortingOptions.oldest: returnValue = '>'; break;
    }
    assert(returnValue != null , 'Return value is null');
    return returnValue;
  }
}




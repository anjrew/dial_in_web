import 'package:flutter_web/material.dart';
import 'item.dart';
import 'database_functions.dart';
import 'strings.dart';
import 'images.dart';
import 'country.dart';
import 'images.dart';

class Profile {
  @required
  String userId;
  @required
  DateTime updatedAt;
  @required
  String objectId;
  @required
  String databaseId;
  @required
  List<Item> properties;
  String _imageUrl;
  String tempPath;
  String localimageAssetPlaceholder;
  String _onlineImagdPLaceholder;
  @required
  ProfileType type;
  @required
  int referanceNumber;
  @required
  int orderNumber = 0;
  @required
  bool isPublic = true;
  List<Profile> profiles;
  List<Map<String,String>> comments = List<Map<String,String>>();
  List<String> likes = List<String>();
  String label;
  bool isDeleted;

  Profile({
      @required this.isDeleted,
      this.likes,
      this.comments,
      @required this.userId,
      @required this.updatedAt,
      @required this.objectId,
      @required this.type,
      this.properties,
      @required String imageUrl,
      this.localimageAssetPlaceholder,
      @required this.databaseId,
      @required this.orderNumber,
      this.profiles,
      @required this.isPublic 
      }) {

      _imageUrl = imageUrl;  
    switch (type) {

      case ProfileType.recipe:
        this.referanceNumber = 0;
        this.label = StringLabels.recipe;
        this.localimageAssetPlaceholder = Images.recipeSmaller;
        this._onlineImagdPLaceholder = Images.recipeSmallerFirebase;
        
        break;

      case ProfileType.coffee:
        this.referanceNumber = 1;
        this.label = StringLabels.coffee;
        this.localimageAssetPlaceholder = Images.coffeeBeans;
        this._onlineImagdPLaceholder = Images.coffeeBeansFirebase;
        break;

      case ProfileType.grinder:
        this.referanceNumber = 2;
        this.label = StringLabels.grinder;
        this.localimageAssetPlaceholder = Images.grinder;
        this._onlineImagdPLaceholder = Images.grinderFirebase;
        break;

      case ProfileType.equipment:
        this.referanceNumber = 3;
        this.label = StringLabels.method;
        this.localimageAssetPlaceholder = Images.aeropressSmaller512x512;
        this._onlineImagdPLaceholder = Images.aeropressSmaller512x512Firebase;
        break;

      case ProfileType.water:
        this.referanceNumber = 4;
        this.label = StringLabels.water;
        this.localimageAssetPlaceholder = Images.water;
        this._onlineImagdPLaceholder = Images.dropFirebase; 
        break;

      case ProfileType.barista:
        this.referanceNumber = 5;
        this.label = StringLabels.barista;
        this.localimageAssetPlaceholder = Images.user;
        this._onlineImagdPLaceholder = Images.userFirebase;
        break;

      default:
        break;
    }
  }

  //  Profile.clone(Profile cloningProfile):
  //   super( 
  //     cloningProfile.isDeleted,
  //     cloningProfile.likes,
  //     cloningProfile.comments,
  //     cloningProfile.userId,
  //     cloningProfile.updatedAt,
  //     cloningProfile.objectId,
  //     cloningProfile.type,
  //     cloningProfile.properties,
  //     cloningProfile.imageUrl,
  //     cloningProfile.localimageAssetPlaceholder,
  //     cloningProfile.databaseId,
  //     cloningProfile.orderNumber,
  //     cloningProfile.profiles,
  //     cloningProfile.isPublic );
    

  String get imageUrl => _imageUrl;
  String get realImageUrl => _imageUrl;
  set imageUrl(String url) => _imageUrl = url;
  String get placeholder => getImagePlaceholder();
  
  double getExtractionYield(){

    dynamic lrr = this.getProfileProfile(ProfileType.equipment).getItemValue(DatabaseIds.lrr) == '' ? 2.1: 
        double.parse(this.getProfileProfile(ProfileType.equipment).getItemValue(DatabaseIds.lrr).toString());

    dynamic tds = this.getItemValue(DatabaseIds.tds) == '' ? 0.0:
        double.parse(this.getItemValue(DatabaseIds.tds));

    dynamic dose = this.getItemValue(DatabaseIds.brewingDose) == '' ? 0.0:
        double.parse(this.getItemValue(DatabaseIds.brewingDose));

    dynamic yielde = this.getItemValue(DatabaseIds.yielde) == '' ? 0.0:
        double.parse(this.getItemValue(DatabaseIds.yielde));

    double extractionYield = 0.0;

    double coffeeInCoffee = tds * (yielde + (dose * lrr));
    extractionYield = coffeeInCoffee / dose;

    double returnValue = double.parse(extractionYield.toStringAsFixed(2));
    return returnValue; 
  }

  void setItemValue(String itemDatabaseId, dynamic value) {
    if (value != null){
      for (var i = 0; i < this.properties.length; i++) {
        if (this.properties[i].databaseId == itemDatabaseId) {

          if(this.properties[i].value is int && value is String){ this.properties[i].value = int.parse(value);}
          else if(this.properties[i].value is double && value is String){ this.properties[i].value = double.parse(value);}
          else if(this.properties[i].value is String && value is int){ this.properties[i].value = value.toString();}
          else if(this.properties[i].value is String && value is double){ this.properties[i].value = value.toString();}
          else{this.properties[i].value = value;}   
        }
      }
    }  
  }


   String getImagePlaceholder(){

    String placeHolder;

    switch(this.type){

      case ProfileType.barista : placeHolder = Images.user; break; 

      case ProfileType.coffee : 

        placeHolder = Images.coffeeBeans; 

        var country = this.getItemValue(DatabaseIds.country);
      
        if (country != null && country != ''){
          Country.ALL.forEach((c){
            if (country == c.name){
              placeHolder = c.asset;
            }
          });
        }
        
        break;


      case ProfileType.equipment :
      
       placeHolder = Images.aeropressSmaller512x512;
       
        break;


      case ProfileType.grinder :
       placeHolder = Images.grinder; 
       break;


      case ProfileType.recipe : 

      placeHolder = Images.recipeSmaller; 
      
      var country = this.getProfileProfile(ProfileType.coffee).getItemValue(DatabaseIds.country);
      
        if (country != null && country != ''){
          Country.ALL.forEach((c){
            if (country == c.name){
              placeHolder = c.asset;
            }
          });
        }
      break;


      case ProfileType.water : 
      placeHolder = Images.water; 
      break; 
    }

    assert(placeHolder != null, 'placeHolder is null');

    return placeHolder?? '';
  }

  dynamic getItemValue(String itemDatabaseId) {
    
    dynamic value;
    for (var i = 0; i < this.properties.length; i++) {
      if (this.properties[i].databaseId == itemDatabaseId) {
        value = this.properties[i].value;
      }
    }

    if (value == null) {
      if(itemDatabaseId == DatabaseIds.date || itemDatabaseId == DatabaseIds.roastDate)
      { return DateTime.now();}
      else{return '';}
   
    } else {
      return value;
    }
  }

  Item getItem(String itemDatabaseId){
    
    Item item;
    for (var i = 0; i < this.properties.length; i++) {
      if (this.properties[i].databaseId == itemDatabaseId) {
        item = this.properties[i];
      }
    }

    if (item == null) {
      return Item();
    } else {
      return item;
    }
  } 

  String getProfileTypeTitle(){

    String value =  '';

    switch (this.type) {
        case ProfileType.barista:
          value = StringLabels.barista;
        break;
        case ProfileType.coffee:
          value = StringLabels.coffee;
        break;
        case ProfileType.equipment:
          value = StringLabels.method;
        break;
        case ProfileType.grinder:
          value = StringLabels.grinder;
        break;
        case ProfileType.recipe:
          value = StringLabels.recipe;
        break;
        case ProfileType.water:
          value = StringLabels.water;
        break;
        case ProfileType.barista:
        break;
      default:
    }
    return value ?? '';
  }

  void setProfileProfileTitleValue({String profileDatabaseId, String profileDatabaseIdref}) {
    for (var i = 0; i < this.profiles.length; i++) {
      if (this.profiles[i].databaseId == profileDatabaseId) {
        switch (profileDatabaseId) {
          case DatabaseIds.recipe:
            setItemValue(
                 DatabaseIds.recipeId,
                 profileDatabaseIdref);
            break;

          case DatabaseIds.coffee:
            setItemValue(
                 DatabaseIds.coffeeId,
                 profileDatabaseIdref);
            break;

          case DatabaseIds.water:
            setItemValue(
                 DatabaseIds.waterID,
                 profileDatabaseIdref);
            break;

          case DatabaseIds.brewingEquipment:
            setItemValue(
                 DatabaseIds.equipmentId,
                 profileDatabaseIdref);
            break;

          case DatabaseIds.grinder:
            setItemValue(
                 DatabaseIds.grinderId,
                 profileDatabaseIdref);
            break;

          case DatabaseIds.barista:
            setItemValue(
                 DatabaseIds.name,  profileDatabaseIdref);
            break;

          default:
            break;
        }
      }
    }
  }

Future<String> getUserImage ()async{
  
  String imageUrl = await Dbf.getValueFromFireStoreWithDocRef(DatabaseIds.User, this.userId, DatabaseIds.imageUrl);

  return imageUrl ?? '';
} 

 dynamic getProfileProfileItemValue(ProfileType profiletype, String itemDatabaseId) {
  dynamic value = '';
   if (this.profiles != null) {
      for (var i = 0; i < this.profiles.length; i++) {
        if (this.profiles[i].type == profiletype) {
          for (var x = 0; x < this.profiles[i].properties.length; x++) {
            if (this.profiles[i].properties[x].databaseId == itemDatabaseId){
              value = this.profiles[i].properties[x].value;
            }
          }
        }
      }
   }
   return value;
 }

 Item getProfileProfileItem(ProfileType profiletype, String itemDatabaseId) {
  Item value;
   if (this.profiles != null) {
      for (var i = 0; i < this.profiles.length; i++) {
        if (this.profiles[i].type == profiletype) {
          for (var x = 0; x < this.profiles[i].properties.length; x++) {
            if (this.profiles[i].properties[x].databaseId == itemDatabaseId){
              value = this.profiles[i].properties[x];
            }
          }
        }
      }
   }
   return value;
 }

 dynamic getProfileProfileImage(ProfileType profiletype) {
  dynamic value;
   if (this.profiles != null) {
      for (var i = 0; i < this.profiles.length; i++) {
        if (this.profiles[i].type == profiletype) {
              value = this.profiles[i]._imageUrl == '' ? this.profiles[i]._onlineImagdPLaceholder : this.profiles[i]._imageUrl;
        }
      }
   }
   return value;
 }

 Profile getProfileProfile(ProfileType profiletype) { 
  Profile value;
   if (this.profiles != null) {
      for (var i = 0; i < this.profiles.length; i++) {
        if (this.profiles[i].type == profiletype) {
              value = this.profiles[i];
        }
      }
   }
   return value;
 }

 Future<String> getProfileUserName()async{
   
  String userName = await Dbf.getValueFromFireStoreWithDocRef(DatabaseIds.User, this.userId, DatabaseIds.userName);

  return userName ?? 'Error: Could not find userName';
 }

  String getProfileProfileTitleValue({String profileDatabaseId}) {
    String value = 'Error';

    if (this.profiles != null) {
      for (var i = 0; i < this.profiles.length; i++) {
        if (this.profiles[i].databaseId == profileDatabaseId) {
          switch (profileDatabaseId) {
            case DatabaseIds.recipe:
              value = this.profiles[i].getItemValue( DatabaseIds.recipeId);
              break;

            case DatabaseIds.coffee:
              value = this.profiles[i].getItemValue( DatabaseIds.coffeeId);
              break;

            case DatabaseIds.water:
              value = this.profiles[i].getItemValue( DatabaseIds.waterID);
              break;

            case DatabaseIds.brewingEquipment:
              value = this.profiles[i].getItemValue( DatabaseIds.equipmentId);
              break;

            case DatabaseIds.grinder:
              value = this.profiles[i].getItemValue( DatabaseIds.grinderId);
              break;

            case DatabaseIds.Barista:
              value = this.profiles[i].getItemValue( DatabaseIds.name);
              break;

            case DatabaseIds.score:
              value = (this.profiles[i].getItemValue( DatabaseIds.strength) +
                      this.profiles[i].getItemValue( DatabaseIds.balance) +
                      this.profiles[i].getItemValue( DatabaseIds.flavour) +
                      this.profiles[i].getItemValue( DatabaseIds.body) +
                      this.profiles[i].getItemValue( DatabaseIds.afterTaste)).toString();
              break;  

            default:
              value = 'Error';
              break;
          }
        }
      }
    }
    return value;
  }
  
  String getProfileTitleValue() {
  String value = 'Error';
   switch (this.databaseId) {
            case DatabaseIds.recipe:
              value = this.getProfileProfile( ProfileType.coffee ).getProfileTitleValue();
              break;

            case DatabaseIds.coffee:
              value = this.getItemValue( DatabaseIds.coffeeId);
              break;

            case DatabaseIds.water:
              value = this.getItemValue( DatabaseIds.waterID);
              break;

            case DatabaseIds.brewingEquipment:
              value = this.getItemValue( DatabaseIds.equipmentId);
              break;

            case DatabaseIds.grinder:
              value = this.getItemValue( DatabaseIds.grinderId);
              break;

            case DatabaseIds.Barista:
              value = this.getItemValue( DatabaseIds.name);
              break;

            case DatabaseIds.score:
            value = (this.getItemValue( DatabaseIds.strength) +
                      this.getItemValue( DatabaseIds.balance) +
                      this.getItemValue( DatabaseIds.flavour) +
                      this.getItemValue( DatabaseIds.body) +
                      this.getItemValue( DatabaseIds.afterTaste)).toString();
              break;  
   }
   return value;
 }

  String getProfileProfileRefernace({String profileDatabaseId}) {
    String value = '';

    if (this.profiles != null) {
      for (var i = 0; i < this.profiles.length; i++) {
        if (this.profiles[i].databaseId == profileDatabaseId) {
              value = this.profiles[i].objectId;
        }
      }
    }
    return value;
  }

  void setSubProfile(Profile profile) {
    if (this.profiles != null){
      for (var i = 0; i < this.profiles.length; i++) {
        if (this.profiles[i].type == profile.type) {
          this.profiles[i] = profile;
        }
      }
    }
  }

   static Future<Profile> createBlankProfile(ProfileType profileType)async{
    switch (profileType) {

      case ProfileType.recipe:
        return new Profile(
            isDeleted: false,
            comments: null,
            likes: null,
            imageUrl: null,
            userId: '',
            isPublic: true,
            updatedAt: DateTime.now(),
            objectId: UniqueKey().toString(),
            databaseId: DatabaseIds.recipe,
            type: ProfileType.recipe,
            localimageAssetPlaceholder: Images.recipeSmaller,
            orderNumber: 0,
            properties: [
              createBlankItem(DatabaseIds.barista),
              createBlankItem(DatabaseIds.date),
              createBlankItem(DatabaseIds.grindSetting),
              createBlankItem(DatabaseIds.temparature),
              createBlankItem(DatabaseIds.brewingDose),
              createBlankItem(DatabaseIds.preinfusion),
              createBlankItem(DatabaseIds.yielde),
              createBlankItem(DatabaseIds.brewWeight),
              createBlankItem(DatabaseIds.time),
              createBlankItem(DatabaseIds.tds),
              createBlankItem(DatabaseIds.notes),
              createBlankItem(DatabaseIds.flavour),
              createBlankItem(DatabaseIds.body),
              createBlankItem(DatabaseIds.balance),
              createBlankItem(DatabaseIds.afterTaste),
              createBlankItem(DatabaseIds.strength),
              createBlankItem(DatabaseIds.descriptors),
            ],
            profiles: [
              await createBlankProfile(ProfileType.coffee),
              await createBlankProfile(ProfileType.barista),
              await createBlankProfile(ProfileType.equipment),
              await createBlankProfile(ProfileType.grinder),
              await createBlankProfile(ProfileType.water),
            ]);
        break;

      case ProfileType.water:
        return new Profile(
          isDeleted: false,
          comments: null,
          likes: null,
          imageUrl: null,
          profiles: null,
          userId: '',
          isPublic: true,
          updatedAt: DateTime.now(),
          objectId: UniqueKey().toString(),
          databaseId: DatabaseIds.water,
          localimageAssetPlaceholder: Images.drop,
          type: ProfileType.water,
          orderNumber: 0,
          properties: [
            createBlankItem(DatabaseIds.waterID),
            createBlankItem(DatabaseIds.date),
            createBlankItem(DatabaseIds.ppm),
            createBlankItem(DatabaseIds.gh),
            createBlankItem(DatabaseIds.kh),
            createBlankItem(DatabaseIds.ph),
            createBlankItem(DatabaseIds.notes),
          ]);
        break;

      case ProfileType.coffee:
        return new Profile(
            isDeleted: false,
            comments: null,
            likes: null,
            imageUrl: null,
            profiles: null,
            userId: '',
            isPublic: true,
            updatedAt: DateTime.now(),
            objectId: UniqueKey().toString(),
            localimageAssetPlaceholder: Images.coffeeBeans,
            databaseId: DatabaseIds.coffee,
            type: ProfileType.coffee,
            orderNumber: 0,
            properties: [
              createBlankItem(DatabaseIds.coffeeId),
              createBlankItem(DatabaseIds.country),
              createBlankItem(DatabaseIds.region),
              createBlankItem(DatabaseIds.farm),
              createBlankItem(DatabaseIds.producer),
              createBlankItem(DatabaseIds.lot),
              createBlankItem(DatabaseIds.altitude),
              createBlankItem(DatabaseIds.roastDate),
              createBlankItem(DatabaseIds.roastProfile),
              createBlankItem(DatabaseIds.roasteryName),
              createBlankItem(DatabaseIds.beanType),
              createBlankItem(DatabaseIds.beanSize),
              createBlankItem(DatabaseIds.processingMethod),
              createBlankItem(DatabaseIds.density),
              createBlankItem(DatabaseIds.aW),
              createBlankItem(DatabaseIds.moisture),
              createBlankItem(DatabaseIds.roasterName),
              createBlankItem(DatabaseIds.harvest),
              createBlankItem(DatabaseIds.referance),

            ]);
        break;

      case ProfileType.equipment:
        return new Profile(
          isDeleted: false,
          comments: null,
          likes: null,
          imageUrl: null,
          profiles: null,
          userId: '',
          isPublic: true,
          updatedAt: DateTime.now(),
          objectId: UniqueKey().toString(),
          localimageAssetPlaceholder: Images.aeropressSmaller512x512,
          databaseId: DatabaseIds.brewingEquipment,
          type: ProfileType.equipment,
          orderNumber: 0,
          properties: [
                createBlankItem(DatabaseIds.equipmentId),
                createBlankItem(DatabaseIds.equipmentMake),
                createBlankItem(DatabaseIds.equipmentModel),
                createBlankItem(DatabaseIds.method),
                createBlankItem(DatabaseIds.type),
                createBlankItem(DatabaseIds.lrr),
          ],
        );
        break;

      case ProfileType.grinder:
        return new Profile(
          isDeleted: false,
          comments: null,
          likes: null,
          imageUrl: null,
          profiles: null,
          userId: '',
          isPublic: true,
          updatedAt: DateTime.now(),
          objectId: UniqueKey().toString(),
          localimageAssetPlaceholder: Images.grinder,
          databaseId: DatabaseIds.grinder,
          type: ProfileType.grinder,
          orderNumber: 0,
          properties: [
            createBlankItem(DatabaseIds.grinderId),
            createBlankItem(DatabaseIds.grinderMake),
            createBlankItem(DatabaseIds.grinderModel),
            createBlankItem(DatabaseIds.burrs),
            createBlankItem(DatabaseIds.notes),
          ],
        );
        break;

      case ProfileType.barista:
        return new Profile(
          isDeleted: false,
          comments: null,
          likes: null,
          imageUrl: null,
          profiles: null,
          userId: '',
          isPublic: true,
          updatedAt: DateTime.now(),
          objectId: UniqueKey().toString(),
          localimageAssetPlaceholder: Images.user,
          databaseId: DatabaseIds.Barista,
          type: ProfileType.barista,
          orderNumber: 0,
          properties: [
            createBlankItem(DatabaseIds.name),
            createBlankItem(DatabaseIds.level),
            createBlankItem(DatabaseIds.notes)
          ],
        );
        break;

      default: throw('Error - no profile created');
        break;
    }
  }

  
  static Item createBlankItem(String databaseId) {
    Item _item;

    switch (databaseId) {

      /// Recipe
      case DatabaseIds.date:
        _item = new Item(
          title: StringLabels.date,
          value: DateTime.now(),
          databaseId: DatabaseIds.date,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.brewingEquipment:
        _item = new Item(
          title: StringLabels.method,
          value: '',
          databaseId: DatabaseIds.equipmentId,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.grinder:
        _item = new Item(
          title: StringLabels.grinder,
          value: '',
          databaseId: DatabaseIds.grinderId,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.grindSetting:
        _item = new Item(
          title: StringLabels.setting,
          value: '',
          databaseId: DatabaseIds.grindSetting,
          placeHolderText: StringLabels.enterValue,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.waterID:
        _item = new Item(
          title: StringLabels.name,
          value: '',
          databaseId: DatabaseIds.waterID,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.temparature:
        _item = new Item(
          title: StringLabels.degreeC,
          value: '',
          databaseId: DatabaseIds.temparature,
          placeHolderText: StringLabels.enterTemparature,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.brewingDose:
        _item = new Item(
          title: StringLabels.brewingDose,
          value: '',
          databaseId: DatabaseIds.brewingDose,
          placeHolderText: StringLabels.enterValue,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        );
        break;

      case DatabaseIds.preinfusion:
        _item = new Item(
          title: StringLabels.preinfusion,
          value: '',
          databaseId: DatabaseIds.preinfusion,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.yielde:
        _item = new Item(
          title: StringLabels.yielde,
          value: '',
          databaseId: DatabaseIds.yielde,
          placeHolderText: StringLabels.enterValue,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        );
        break;

      case DatabaseIds.brewWeight:
        _item = new Item(
          title: StringLabels.weightG,
          value: '',
          databaseId: DatabaseIds.brewWeight,
          placeHolderText: StringLabels.enterValue,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        );
        break;

      case DatabaseIds.time:
        _item = new Item(
          title: StringLabels.brewTime,
          value: '',
          databaseId: DatabaseIds.time,
          placeHolderText: StringLabels.enterValue,
          keyboardType: TextInputType.number,
          inputViewDataSet: StringDataArrays.minutesAndSeconds,
          icon: Icon(Icons.timer)
        );
        break;

      case DatabaseIds.tds:
        _item = new Item(
          title: StringLabels.tds,
          value: '',
          databaseId: DatabaseIds.tds,
          placeHolderText: StringLabels.enterValue,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.notes:
        _item = new Item(
          title: StringLabels.notes,
          value: '',
          databaseId: DatabaseIds.notes,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
          icon: Icon(Icons.note),
          textInputAction: TextInputAction.newline
        );
        break;

      case DatabaseIds.flavour:
        _item = new Item(
          title: StringLabels.flavour,
          value: '0.0',
          databaseId: DatabaseIds.flavour,
          placeHolderText: StringLabels.flavour,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.body:
        _item = new Item(
          title: StringLabels.body,
          value: '0.0',
          databaseId: DatabaseIds.body,
          placeHolderText: StringLabels.enterValue,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.balance:
        _item = new Item(
          title: StringLabels.balance,
          value: '0.0',
          databaseId: DatabaseIds.balance,
          placeHolderText: StringLabels.enterValue,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.afterTaste:
        _item = new Item(
          title: StringLabels.afterTaste,
          value: '0.0',
          databaseId: DatabaseIds.afterTaste,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.strength:
        _item = new Item(
          title: StringLabels.strength,
          value: '0.0',
          databaseId: DatabaseIds.strength,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.descriptors:
        _item = new Item(
          title: StringLabels.descriptors,
          value: '',
          databaseId: DatabaseIds.descriptors,
          placeHolderText: StringLabels.descriptors,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.coffeeId:
        _item = new Item(
          title: StringLabels.coffee,
          value: '',
          databaseId: DatabaseIds.coffeeId,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
          
        );
        break;

      ///
      /// Water
      ///

      case DatabaseIds.waterID:
        _item = new Item(
          title: StringLabels.waterID,
          value: '',
          databaseId: DatabaseIds.waterID,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.date:
        _item = new Item(
          title: StringLabels.date,
          value: DateTime.now(),
          databaseId: DatabaseIds.date,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.number,
          icon: Icon(Icons.date_range)
        );
        break;

      case DatabaseIds.ppm:
        _item = new Item(
          title: StringLabels.ppm,
          value: '',
          databaseId: DatabaseIds.ppm,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.gh:
        _item = new Item(
          title: StringLabels.gh,
          value: '',
          databaseId: DatabaseIds.gh,
          placeHolderText: StringLabels.gh,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.kh:
        _item = new Item(
          title: StringLabels.kh,
          value: '',
          databaseId: DatabaseIds.kh,
          placeHolderText: StringLabels.kh,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.ph:
        _item = new Item(
          title: StringLabels.ph,
          value: '',
          databaseId: DatabaseIds.ph,
          placeHolderText: StringLabels.ph,
          keyboardType: TextInputType.number,
        );
        break;

        case DatabaseIds.testTemparature:
        _item = new Item(
          title: StringLabels.testTemparature,
          value: '',
          databaseId: DatabaseIds.testTemparature,
          placeHolderText: StringLabels.degreeC,
          keyboardType: TextInputType.number,
        );
        break;

      ///
      /// Coffee
      ///

      case DatabaseIds.country:
        _item = new Item(
          title: StringLabels.country,
          value: '',
          databaseId: DatabaseIds.country,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
          inputViewDataSet: StringDataArrays.countrys,
        );
        break;

      case DatabaseIds.region:
        _item = new Item(
          title: StringLabels.region,
          value: '',
          databaseId: DatabaseIds.region,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.farm:
        _item = new Item(
          title: StringLabels.farm,
          value: '',
          databaseId: DatabaseIds.farm,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.producer:
        _item = new Item(
          title: StringLabels.producer,
          value: '',
          databaseId: DatabaseIds.producer,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.lot:
        _item = new Item(
          title: StringLabels.lot,
          value: '',
          databaseId: DatabaseIds.lot,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.altitude:
        _item = new Item(
          title: StringLabels.altitude,
          value: '',
          databaseId: DatabaseIds.altitude,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.number,
        );
        break;

       case DatabaseIds.harvest:
        _item = new Item(
          title: StringLabels.harvest,
          value: '',
          databaseId: DatabaseIds.harvest,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
          icon: Icon(Icons.nature_people)

        );
        break;

      /// Roasting details

      case DatabaseIds.roastDate:
        _item = new Item(
          title: StringLabels.roastDate,
          value: DateTime.now(),
          databaseId: DatabaseIds.roastDate,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.roastProfile:
        _item = new Item(
          title: StringLabels.roastProfile,
          value: '',
          databaseId: DatabaseIds.roastProfile,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
          inputViewDataSet: StringDataArrays.roastTypes
        );
        break;

      case DatabaseIds.roasteryName:
        _item = new Item(
          title: StringLabels.roasteryName,
          value: '',
          databaseId: DatabaseIds.roasteryName,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.roasterName: 
        _item = new Item(
          title: StringLabels.roasterName,
          value: '',
          databaseId: DatabaseIds.roasterName,
          placeHolderText: StringLabels.enterName,
          keyboardType: TextInputType.text,
        );
        break;

        case DatabaseIds.referance: 
        _item = new Item(
          title: StringLabels.reference,
          value: '',
          databaseId: DatabaseIds.referance,
          placeHolderText: StringLabels.enterReference,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.beanType:
        _item = new Item(
            title: StringLabels.beanType,
            value: '',
            databaseId: DatabaseIds.beanType,
            placeHolderText: StringLabels.enterDescription,
            keyboardType: TextInputType.text,
            inputViewDataSet: StringDataArrays.beanType);
        break;


      case DatabaseIds.beanSize:
        _item = new Item(
            title: StringLabels.beanSize,
            value: '',
            databaseId: DatabaseIds.beanSize,
            placeHolderText: StringLabels.enterDescription,
            keyboardType: TextInputType.text,
            inputViewDataSet: StringDataArrays.beanSize);
        break;

      case DatabaseIds.processingMethod:
        _item = new Item(
            title: StringLabels.processingMethod,
            value: '',
            databaseId: DatabaseIds.processingMethod,
            placeHolderText: StringLabels.enterDescription,
            keyboardType: TextInputType.text,
            inputViewDataSet: StringDataArrays.processingMethods);
        break;

      case DatabaseIds.density:
        _item = new Item(
          title: StringLabels.density,
          value: '',
          databaseId: DatabaseIds.density,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.aW:
        _item = new Item(
          title: StringLabels.aW,
          value: '',
          databaseId: DatabaseIds.aW,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.number,
        );
        break;

      case DatabaseIds.moisture:
        _item = new Item(
          title: StringLabels.moisture,
          value: '',
          databaseId: DatabaseIds.moisture,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.number,
        );
        break;

      ///
      /// Grinder
      ///
      
      case DatabaseIds.grinderId:
        _item = new Item(
          title: StringLabels.name,
          value: '',
          databaseId: DatabaseIds.grinderId,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.burrs:
        _item = new Item(
          title: StringLabels.burrs,
          value: '',
          databaseId: DatabaseIds.burrs,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
          inputViewDataSet: StringDataArrays.burrTypes
        );
        break;

      case DatabaseIds.grinderMake:
        _item = new Item(
          title: StringLabels.make,
          value: '',
          databaseId: DatabaseIds.grinderMake,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.grinderModel:
        _item = new Item(
          title: StringLabels.model,
          value: '',
          databaseId: DatabaseIds.grinderModel,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      ///
      /// Equipment
      ///
      case DatabaseIds.equipmentId:
        _item = new Item(
          title: StringLabels.name,
          value: '',
          databaseId: DatabaseIds.equipmentId,
          placeHolderText: StringLabels.enterName,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.type:
        _item = new Item(
          title: StringLabels.type,
          value: '',
          databaseId: DatabaseIds.type,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
          inputViewDataSet: StringDataArrays.equipmentTypes
        );
        break;

      case DatabaseIds.equipmentModel:
        _item = new Item(
          title: StringLabels.model,
          value: '',
          databaseId: DatabaseIds.equipmentModel,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.equipmentMake:
        _item = new Item(
          title: StringLabels.make,
          value: '',
          databaseId: DatabaseIds.equipmentMake,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.method:
        _item = new Item(
          title: StringLabels.method,
          value: '',
          databaseId: DatabaseIds.method,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;

      case DatabaseIds.lrr:
        _item = new Item(
          title: StringLabels.lrr,
          value: 2.1,
          databaseId: DatabaseIds.lrr,
          placeHolderText: 'Enter the liquid retention ratio..',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        );
        break;

      ///
      /// BaristarTop
      ///
      
      case DatabaseIds.name:
        _item = new Item(
          title: StringLabels.name,
          value: '',
          databaseId: DatabaseIds.name,
          placeHolderText: StringLabels.enterName,
          keyboardType: TextInputType.text,
        );
        break;

        case DatabaseIds.level:
        _item = new Item(
          title: StringLabels.level,
          value: '',
          databaseId: DatabaseIds.level,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;
    
      
      default:
        _item = new Item(
          title: StringLabels.method,
          value: '',
          databaseId: DatabaseIds.method,
          placeHolderText: StringLabels.enterDescription,
          keyboardType: TextInputType.text,
        );
        break;
    }

    return _item;
  }

  double getTotalScore(){
    double finalscore;
    if(this.type == ProfileType.recipe){

    List<double> scores = [
      double.parse(this.getItemValue(DatabaseIds.strength),),
      double.parse(this.getItemValue(DatabaseIds.balance)),
      double.parse(this.getItemValue(DatabaseIds.flavour)),
      double.parse(this.getItemValue(DatabaseIds.body)),
      double.parse(this.getItemValue(DatabaseIds.afterTaste)),
    ];
    
    finalscore = scores.reduce((value, element) => value + element);
    }
    return finalscore ?? 0;
  }  

  int getDaysRested(){
    DateTime coffeeRoastDate = getProfileProfileItemValue(ProfileType.coffee, DatabaseIds.roastDate);
    DateTime recipeMadeTime = getItemValue(DatabaseIds.date);
    int result = recipeMadeTime.difference(coffeeRoastDate).inDays;
    return result;
  }

  ProfileSavePermission isValidForSave(){

    ProfileSavePermission returnValue;

    switch (this.type) {
      case ProfileType.recipe:
        var coffeId = this.getProfileProfile(ProfileType.coffee).getItemValue(DatabaseIds.coffeeId); 
        var dose = getItemValue(DatabaseIds.brewingDose); 
        var yld = getItemValue(DatabaseIds.yielde); 
        var bw = getItemValue(DatabaseIds.brewWeight); 

        bool brewAndYieldNull = (( bw == null || bw == '' || bw == 0 ) && ( yld == null || yld == '' || yld == 0));
        
        if ( (brewAndYieldNull) ||
          coffeId == null || coffeId == '' ||
          dose == null || dose == '' || dose == 0 
          ){ 
            returnValue = ProfileSavePermission(false, 'The minimum fields required are, coffee, dose, and yield or brew weight.');
            }
        break;

      case ProfileType.coffee:
        var x = getItemValue(DatabaseIds.coffeeId); 
        if ( x == null || x == '' ){ returnValue = ProfileSavePermission(false, 'Lets give this coffee a name first.'); }
        break;

      case ProfileType.grinder: 
        var x = getItemValue(DatabaseIds.grinderId); 
        if ( x == null || x == '' ){ returnValue =  ProfileSavePermission(false,'Enter a name for your grinder.'); }
        break;
      
      case ProfileType.equipment: 
        var x = getItemValue(DatabaseIds.equipmentId); 
        if ( x == null || x == '' ){ returnValue =  ProfileSavePermission(false, 'Lets give this method a name first.'); }
        break;

      case ProfileType.water: 
        var x = getItemValue(DatabaseIds.waterID); 
        if ( x == null || x == '' ){ returnValue =  ProfileSavePermission(false, 'We should probably give the water a name...'); }
        break;

      case ProfileType.barista: 
       var x = getItemValue(DatabaseIds.name); 
        if ( x == null || x == '' ){ returnValue =  ProfileSavePermission(false, 'Give the poor guy a name!'); }
        break;

      default:  throw('No matching case in switch statement'); 
    }

    if ( returnValue == null ) { returnValue = ProfileSavePermission(true, 'All relevent necessaryfirld were filled.'); }

    assert(returnValue != null, 'Return value is null');
    return returnValue ?? ProfileSavePermission(false, 'There was a error with the app, Please send feedback  so we can make it better for next time :)');
  }

  void alterAsCopy(){
    switch (this.type) {
        case ProfileType.barista:
        
        break;

        case ProfileType.coffee:
        this.setItemValue(DatabaseIds.date,  null);
        
        break;

        case ProfileType.equipment:
        
        break;

        case ProfileType.grinder:
        
        break;

        case ProfileType.recipe:
          this.imageUrl = '';
          this.setItemValue(DatabaseIds.date,  DateTime.now());
          this.setItemValue(DatabaseIds.strength,  '0.0');
          this.setItemValue(DatabaseIds.balance,  '0.0');
          this.setItemValue(DatabaseIds.flavour,  '0.0');
          this.setItemValue(DatabaseIds.body,  '0.0');
          this.setItemValue(DatabaseIds.afterTaste,  '0.0'); 
          this.setItemValue(DatabaseIds.time,  0); 

        break;

        case ProfileType.water:

          this.setItemValue(DatabaseIds.date,  DateTime.now());

        break;

      default:
    }
  }

  static Profile makeACopy(Profile profile){


    List<String> newLikes = new List<String>.from(profile.likes);
    List<Map<String, String>> comments = new List<Map<String, String>>.from(profile.comments);
    DateTime date = 
      new DateTime(
        profile.updatedAt.year, 
        profile.updatedAt.month, 
        profile.updatedAt.day,
        profile.updatedAt.hour,
        profile.updatedAt.minute);

    List<Item> attributes = profile.properties.map((item){
      return new Item(
        title: item.title,
        value: item.value,
        segueId: item.segueId,
        databaseId: item.databaseId,
        placeHolderText: item.placeHolderText,
        keyboardType: item.keyboardType,
        inputViewDataSet: item.inputViewDataSet,
        icon: item.icon
        );
      }
    ).toList();

    List<Profile> profiles = new List<Profile>();

    if ( profile.type == ProfileType.recipe ) {
        profiles = profile.profiles.map((Profile p){
          return Profile.makeACopy(p);
        }).toList();
    }
    
    Profile newProfile = new Profile(
      isDeleted: profile.isDeleted ,
      likes: newLikes ,
      comments: comments ,
      userId: profile.userId ,
      updatedAt: date ,
      objectId: '' ,
      type: profile.type ,
      properties: attributes ,
      imageUrl: profile.imageUrl ,
      localimageAssetPlaceholder: profile.localimageAssetPlaceholder ,
      databaseId: profile.databaseId ,
      orderNumber: profile.orderNumber ,
      profiles: profiles ,
      isPublic: profile.isPublic ,
    );

    newProfile.alterAsCopy();

    return newProfile;
  }
}

class ProfileSavePermission{

  bool sucess;
  String message;

  ProfileSavePermission(this.sucess, this.message);
}

enum ProfileType {
  recipe,
  coffee,
  water,
  grinder,
  equipment,
  barista,
}

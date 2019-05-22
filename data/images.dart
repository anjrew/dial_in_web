import 'package:flutter_web/rendering.dart';
import 'package:flutter_web/services.dart' show rootBundle;
import 'profile.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'dart:math';


class Images{

    AssetImage kalitaMain = AssetImage(Images.kalita);
    AssetImage filterbarMain = AssetImage(Images.filterbar);
    AssetImage coffeeBeansTwoMain = AssetImage(Images.coffeebeans_two);
    AssetImage espressoMain = AssetImage(Images.espresso);
    AssetImage grindersTwoMain = AssetImage(Images.grinders_two);
    AssetImage waterTwoMain = AssetImage(Images.water_two);
    AssetImage kalitaTwoMain = AssetImage(Images.kalita_two);


    /// Firebase Images
    static const String coffeeBeansFirebase = 'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_images%2Fcoffee-beanSmaller512x512.png?alt=media&token=f9127bcf-11d9-4ba2-bc65-7a15abca2b35';
    static const String userFirebase = 'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_user_images%2Fuser.png?alt=media&token=f2a448f0-c395-4715-8b11-fef97e38d62f';
    static const String aeropressSmaller512x512Firebase = 'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_images%2FaeropressSmaller512x512.png?alt=media&token=a3ca2407-78dd-441c-8dd8-a59a90f3f650';
    static const String dropFirebase = 'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_images%2Fdrop.png?alt=media&token=b5e4d799-af59-4dc0-9495-becf5900095d';
    static const String recipeSmallerFirebase = 'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_images%2FrecipeSmaller512x512.png?alt=media&token=afbd5668-0aaf-42c5-b484-303acd8a705c';
    static const String grinderFirebase = 'https://firebasestorage.googleapis.com/v0/b/dial-in-21c50.appspot.com/o/default_images%2FgrinderSmaller512x512.png?alt=media&token=65a648f6-2014-4fa8-a1ed-16d80a26387a';

    /// Assets
    static const String cherries = 'assets/images/cherries.jpg';
    static const String dialInWhiteLogo = 'assets/images/DialInWhiteLogo.png';
    static const String user = 'assets/images/user.png';
    static const String backIcon = 'assets/images/back_icon.png';
    static const String cherriestwo = 'assets/images/cherriestwo.jpg';
    static const String addProfileButtonWithOrangeTint = 'assets/images/addProfileButtonWithOrangeTint.png';
    static const String logout = 'assets/images/logout.png';
    static const String aeropressSmaller512x512 = 'assets/images/aeropressSmaller512x512.png';
    static const String drop = 'assets/images/drop.png';
    static const String whiteRecipe200X200 = 'assets/images/whiteRecipe200X200.png';
    static const String coffeeBeans = 'assets/images/coffee-beanSmaller512x512.png';
    static const String grinder = 'assets/images/grinderSmaller512x512.png';
    static const String groupHandle = 'assets/images/whiteGrouphandle80x80@2x.png';
    static const String water = 'assets/images/drop.png';
    static const String recipeSmaller = 'assets/images/recipeSmaller512x512.png';
    static const String eclipseLoadingGif = 'assets/gifs/eclipseLoading.gif';
    static const String rippleLoadingGif = 'assets/gifs/rippleLoading.gif';

    static const String beans = 'assets/images/beans.jpg';
    static const String chemex = 'assets/images/chemex.jpg';
    static const String filterbar = 'assets/images/filterbar2.jpg';
    static const String kalita = 'assets/images/kalita.jpg';
    static const String espresso = 'assets/images/espresso2.jpg';
    static const String kalita_two = 'assets/images/kalita_two2.jpg';
    static const String water_one = 'assets/images/water_one.jpg';
    static const String water_two = 'assets/images/water_two.jpg';
    static const String coffee_table = 'assets/images/coffee_table.jpg';
    static const String grinders_two = 'assets/images/grinders_two2.jpg';
    static const String coffeebeans_two = 'assets/images/coffeebeans_two.jpg';

    static const String add_profile_button = 'assets/images/add_profile_button.jpg';
    static const String drawer = 'assets/images/drawer.jpg';
    static const String follow_button = 'assets/images/follow_button.jpg';
    static const String profile_page_copy_delete_buttons = 'assets/images/profile_page_copy_delete_buttons.jpg';
    static const String profile_page_edit_button = 'assets/images/profile_page_edit_button.jpg';
    static const String profile_page_public_switch = 'assets/images/profile_page_public_switch.jpg';
    static const String sliders = 'assets/images/sliders.jpg';

    

    AssetImage getProFileTypeBackgroundPhoto(ProfileType type){

      AssetImage value;

      switch (type) {

          case ProfileType.recipe:
           value = filterbarMain;
          break;

          case ProfileType.coffee:
            value = coffeeBeansTwoMain;
          break;

          case ProfileType.equipment:
            value = espressoMain;
          break;

          case ProfileType.grinder:
            value = grindersTwoMain;
          break;

          case ProfileType.water:
            value = waterTwoMain;
          break;

          case ProfileType.barista:
            value = kalitaTwoMain;
          break;

        default:
      }
      return value ?? Images.filterbar;
    }

  static  Future<void> getFile(String filePath, Function(File) completion) async{

    final ByteData bytes = await rootBundle.load(filePath);
    final Directory tempDir = Directory.systemTemp;
    final String fileName = "${Random().nextInt(10000)}.jpg";
    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(),mode: FileMode.write);

   completion(file);
  }
}
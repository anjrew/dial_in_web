import 'package:flutter_web/material.dart';


class AppColors {

  static Color getColor(ColorType colorType) {
    Color returnValue;

    switch ( colorType ) {

        case ColorType.primarySwatch:
        returnValue = const Color.fromARGB(250, 209, 140, 92);

        // const Color(0xffBC794D);
        // const Color.fromARGB(250, 209, 140, 92);
        // returnValue = Color(0xffBC794D);
        break;

        case ColorType.lightBackground:
        returnValue = Color.fromARGB(255, 230, 230, 230);
        break;

         case ColorType.darkBackground:
        returnValue = Colors.white;
        break;

        case ColorType.lightColor:
        returnValue = Colors.white;
        break;

        case ColorType.darkColor:
        returnValue = Colors.white;
        break;

        case ColorType.textLight:
        returnValue = Colors.white;
        break;

        case ColorType.textDark:
        returnValue = Colors.black;
        break;

        case ColorType.transparant:
        returnValue = Colors.white.withAlpha(0);
        break;

      default:
        returnValue = const Color(0xffBC794D);
    }
    return returnValue;
  }
}

enum ColorType { lightBackground, darkBackground, lightColor, darkColor, textLight, textDark, primarySwatch, transparant }
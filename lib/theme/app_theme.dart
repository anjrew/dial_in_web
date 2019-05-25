  import 'package:flutter_web/material.dart';
  import 'appColors.dart';
  import 'fonts.dart';


ThemeData buildThemeData(){

  final baseTheme = ThemeData(
    /// Primary changes Tab bar color
    primaryColor: Color(0xffBC794D),
    // AppColors.getColor(ColorType.primarySwatch),
     
    ///Colors
    // brightness: Brightness.dark,
    // primarySwatch: MaterialColor(AppColors.getColor(ColorType.toolBar)),
    primaryColorDark:  AppColors.getColor(ColorType.primarySwatch),
    scaffoldBackgroundColor: AppColors.getColor(ColorType.lightColor),
    primaryColorLight: AppColors.getColor(ColorType.primarySwatch),
  
    buttonColor: AppColors.getColor(ColorType.primarySwatch),
    textSelectionColor: AppColors.getColor(ColorType.primarySwatch),
    backgroundColor: Color.fromARGB(255, 230, 230, 230),
    bottomAppBarColor: AppColors.getColor(ColorType.lightColor),
    accentColor: AppColors.getColor(ColorType.primarySwatch),
    cardColor: AppColors.getColor(ColorType.lightColor),
    canvasColor: AppColors.getColor(ColorType.lightColor),
    cursorColor: Colors.black,
    // dialogBackgroundColor: ,
    // dividerColor: ,
    // disabledColor: ,
    // toggleableActiveColor: ,
    // accentColorBrightness: ,
    // secondaryHeaderColor: ,
    

    /// Icons
    // primaryIconTheme: ,
    
    /// Font
    /// 
    // fontFamily: Fonts.getFontType(FontType.kellySlab),

    ///Text
    textTheme: TextTheme( 
      body1: TextStyle( fontSize: 11.0), 
      body2: TextStyle( fontSize: 13.0),
      button: TextStyle( fontSize: 15.0, color: Colors.white),
      title: TextStyle( fontSize: 28.0),
      display1: TextStyle( fontSize: 15, color: AppColors.getColor(ColorType.primarySwatch)),
      display2: TextStyle( fontSize: 20.0 , color: AppColors.getColor(ColorType.primarySwatch)),
      display3: TextStyle( fontSize: 22.0 , color: AppColors.getColor(ColorType.primarySwatch)),
      display4: TextStyle( fontSize: 25.0),
      headline: TextStyle( fontSize: 15, fontStyle: FontStyle.italic ,color: AppColors.getColor(ColorType.primarySwatch)),
    
      subtitle: TextStyle( fontSize: 20),
      subhead: TextStyle( fontSize: 18,)
    ),


    tabBarTheme: TabBarTheme( 
      labelColor:Colors.white,

      unselectedLabelColor:  AppColors.getColor(ColorType.textLight),
      ),

    primaryColorBrightness: Brightness.light
  );
  return baseTheme;
}

ThemeData buildThemeComfortaa(){

  final baseTheme = ThemeData(
    /// Primary changes Tab bar color
    // primaryColor: AppColors.getColor(ColorType.primarySwatch),
     
    ///Colors
    brightness: Brightness.dark,
    // primarySwatch: MaterialColor(AppColors.getColor(ColorType.toolBar)),
    // primaryColorDark: Color.fromARGB(255, 230, 230, 230),
    // scaffoldBackgroundColor: Color.fromARGB(255, 230, 230, 230),
    // primaryColorLight: Color.fromARGB(255, 180, 184, 171),
  
    // buttonColor: AppColors.getColor(ColorType.primarySwatch),
    // textSelectionColor: AppColors.getColor(ColorType.primarySwatch),
    // backgroundColor: Color.fromARGB(255, 230, 230, 230),
    // bottomAppBarColor: AppColors.getColor(ColorType.white),
    // accentColor: AppColors.getColor(ColorType.tint),
    // cardColor: AppColors.getColor(ColorType.white),
    // canvasColor: AppColors.getColor(ColorType.white),
    // cursorColor: Colors.black,
    // dialogBackgroundColor: ,
    // dividerColor: ,
    // disabledColor: ,
    // toggleableActiveColor: ,
    // accentColorBrightness: ,
    // secondaryHeaderColor: ,
    

    /// Icons
    // primaryIconTheme: ,
    
    /// Font
    fontFamily: Fonts.getFontType(FontType.comfortaa),

    ///Text
  //   textTheme: TextTheme( 
      
  //     body1: TextStyle( fontSize: 11.0), 
  //     body2: TextStyle( fontSize: 13.0),
  //     button: TextStyle( fontSize: 15.0),
  //     title: TextStyle( fontSize: 28.0, fontFamily: Fonts.getFontType( FontType.kellySlab ) ),
  //     display1: TextStyle( fontSize: 15, color: AppColors.getColor(ColorType.primarySwatch)),
  //     display2: TextStyle( fontSize: 20.0 , color: AppColors.getColor(ColorType.primarySwatch)),
  //     display3: TextStyle( fontSize: 22.0 , color: AppColors.getColor(ColorType.primarySwatch)),
  //     display4: TextStyle( fontSize: 25.0),
  //     headline: TextStyle( fontSize: 15, fontStyle: FontStyle.italic ,color: AppColors.getColor(ColorType.primarySwatch)),
    
  //     subtitle: TextStyle( fontSize: 20),
  //     subhead: TextStyle( fontSize: 18,)
  //   ),


  //   tabBarTheme: TabBarTheme( 
  //     labelColor:Colors.white,

  //     unselectedLabelColor:  AppColors.getColor(ColorType.textLight),
  //     ),

  //   primaryColorBrightness: Brightness.light
  );
  return baseTheme;
}

ThemeData buildThemeDataKellySlab(){

  final baseTheme = ThemeData(
    /// Primary changes Tab bar color
    // primaryColor: AppColors.getColor(ColorType.primarySwatch),
     
    ///Colors
    brightness: Brightness.dark,
    // primarySwatch: MaterialColor(AppColors.getColor(ColorType.toolBar)),
    // primaryColorDark: Color.fromARGB(255, 230, 230, 230),
    // scaffoldBackgroundColor: Color.fromARGB(255, 230, 230, 230),
    // primaryColorLight: Color.fromARGB(255, 180, 184, 171),
  
    // buttonColor: AppColors.getColor(ColorType.primarySwatch),
    // textSelectionColor: AppColors.getColor(ColorType.primarySwatch),
    // backgroundColor: Color.fromARGB(255, 230, 230, 230),
    // bottomAppBarColor: AppColors.getColor(ColorType.white),
    // accentColor: AppColors.getColor(ColorType.tint),
    // cardColor: AppColors.getColor(ColorType.white),
    // canvasColor: AppColors.getColor(ColorType.white),
    // cursorColor: Colors.black,
    // dialogBackgroundColor: ,
    // dividerColor: ,
    // disabledColor: ,
    // toggleableActiveColor: ,
    // accentColorBrightness: ,
    // secondaryHeaderColor: ,
    

    /// Icons
    // primaryIconTheme: ,
    
    /// Font
    fontFamily: Fonts.getFontType(FontType.kellySlab),

    ///Text
  //   textTheme: TextTheme( 
      
  //     body1: TextStyle( fontSize: 11.0), 
  //     body2: TextStyle( fontSize: 13.0),
  //     button: TextStyle( fontSize: 15.0),
  //     title: TextStyle( fontSize: 28.0, fontFamily: Fonts.getFontType( FontType.kellySlab ) ),
  //     display1: TextStyle( fontSize: 15, color: AppColors.getColor(ColorType.primarySwatch)),
  //     display2: TextStyle( fontSize: 20.0 , color: AppColors.getColor(ColorType.primarySwatch)),
  //     display3: TextStyle( fontSize: 22.0 , color: AppColors.getColor(ColorType.primarySwatch)),
  //     display4: TextStyle( fontSize: 25.0),
  //     headline: TextStyle( fontSize: 15, fontStyle: FontStyle.italic ,color: AppColors.getColor(ColorType.primarySwatch)),
    
  //     subtitle: TextStyle( fontSize: 20),
  //     subhead: TextStyle( fontSize: 18,)
  //   ),


  //   tabBarTheme: TabBarTheme( 
  //     labelColor:Colors.white,

  //     unselectedLabelColor:  AppColors.getColor(ColorType.textLight),
  //     ),

  //   primaryColorBrightness: Brightness.light
  );
  return baseTheme;
}




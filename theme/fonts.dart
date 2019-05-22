class Fonts {

  static String getFontType(FontType font) {
    String returnValue;

    switch (font) {
      case FontType.comfortaa:
        returnValue = 'Comfortaa';
        break;
      case FontType.kellySlab:
        returnValue = 'KellySlab';
        break;  
      default:
        returnValue = 'Comfortaa';
    }
    return returnValue;
  }
}

enum FontType { comfortaa, kellySlab }

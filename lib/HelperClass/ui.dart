import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonData {
  static const Map<int, Color> color = const {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static const MaterialColor mainMaterialColor = MaterialColor(0xFF540A00, color);
}

class Screen {
  //screen deminisions
  static Screen instance = Screen();

  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _pixelRatio;
  static double _statusBarHeight;
  static double _bottomBarHeight;
  static double _textScaleFactor;

  static Screen getInstance() {
    return instance;
  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData;
  static double get textScaleFactory => _textScaleFactor;
  static double get pixelRatio => _pixelRatio;
  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static double get screenWidthPR => _screenWidth * _pixelRatio;
  static double get screenHeightPR => _screenHeight * _pixelRatio;
  static double get statusBarHeight => _statusBarHeight;
  static double get statusBarHeightPR => _statusBarHeight * _pixelRatio;
  static double get bottomBarHeight => _bottomBarHeight * _pixelRatio;

  static double fontSize({@required double size}) =>
      (size * _screenWidth) / 414;
}

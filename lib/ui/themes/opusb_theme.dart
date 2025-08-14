import 'package:flutter/material.dart';

// Definisikan warna yang digunakan
Color mainColor = Color.fromRGBO(
    72, 148, 204, 1); // Diubah alpha menjadi 1 untuk opasitas yang lebih normal
Color backgroundColor = Color.fromRGBO(229, 245, 252, 1);
Color whiteTheme = Colors.white;
Color blackTheme = Colors.black;
Color blueTheme = Color.fromRGBO(49, 170, 216, 1);
Color beigeTheme = Color.fromRGBO(245, 248, 222, 1);
Color grayTheme = Color.fromRGBO(217, 217, 217, 1);
Color gray3Theme = Color.fromRGBO(139, 139, 139, 1);
Color buttonsubmitColor = Color.fromRGBO(169, 214, 127, 1);
Color iconColor = Color.fromRGBO(255, 255, 255, 0.3);
Color greenUpload = Color.fromRGBO(51, 166, 96, 1);
Color greenBackgroundUpload = Color.fromRGBO(237, 251, 216, 1);
Color greeCheckBackgroundUpload = Color.fromRGBO(132, 214, 90, 1);
Color greenTextStyleUpload = Color.fromRGBO(43, 100, 30, 1);
Color grayField = Color.fromRGBO(196, 196, 196, 1);
Color redUpload = Color.fromRGBO(182, 23, 23, 1);

// Font weights
FontWeight superLight = FontWeight.w100;
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;

class OpusbTheme {
  final bool isDark;
  late Map<int, Color> primarySwatches;
  late MaterialColor primaryMaterialColor;
  late Color canvasColor;
  late Color textColor;
  late Color secondaryTextColor;

  OpusbTheme({this.isDark = false}) {
    // Setup primary swatches
    primarySwatches = {
      50: Color(0xFF00adef),
      100: Color(0xFF00adef),
      200: Color(0xFF00adef),
      300: Color(0xFF00adef),
      400: Color(0xFF00adef),
      500: Color(0xFF00adef),
      600: Color(0xFF254EDB),
      700: Color(0xFF1939B7),
      800: Color(0xFF102693),
      900: Color(0xFF091A7A),
    };

    // Material color definition
    primaryMaterialColor = MaterialColor(0xFF00adef, primarySwatches);

    // Conditional colors based on theme (dark or light)
    canvasColor = isDark ? Colors.grey[900]! : Colors.grey[50]!;
    textColor = isDark ? Colors.white : Colors.black;
    secondaryTextColor = isDark ? Colors.grey[200]! : Colors.grey[700]!;
  }

  // Get the current theme's ThemeData
  ThemeData get themeData {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primarySwatch: primaryMaterialColor,
      primaryColor: primarySwatches[500],
      hintColor: primarySwatches[500],
      canvasColor: canvasColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
    );
  }

  // Font styles for various fonts
  TextStyle get textFontOswald => TextStyle(fontFamily: 'Oswald');
  TextStyle blackTextStyle =
      TextStyle(fontFamily: 'Montserrat', color: Colors.black);
  TextStyle whiteTextStyle =
      TextStyle(fontFamily: 'Montserrat', color: Colors.white);
  TextStyle blackTextStyleO =
      TextStyle(fontFamily: 'Oswald', color: Colors.black);
  TextStyle whiteTextStyleO =
      TextStyle(fontFamily: 'Oswald', color: Colors.white);
  TextStyle latoTextStyle =
      TextStyle(fontFamily: 'Lato', color: Colors.black, fontSize: 14);
  TextStyle nunitoTextStyle =
      TextStyle(fontFamily: 'Nunito Sans', color: Colors.black, fontSize: 14);
  TextStyle poppinsTextStyle =
      TextStyle(fontFamily: 'Poppins', color: Colors.black, fontSize: 14);

  // App bar theme setup
  AppBarTheme get appBarTheme {
    return AppBarTheme(
      elevation: 0,
      centerTitle: true,
    );
  }

  // Bottom navigation bar theme
  BottomNavigationBarThemeData get bottomNavigationBarThemeData {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? Colors.grey[850]! : Colors.white,
    );
  }
}

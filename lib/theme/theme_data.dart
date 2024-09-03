import 'package:flutter/material.dart';
import '/utils/size_config.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.green,
    iconTheme: const IconThemeData(color: Colors.blue),
    canvasColor: const Color(0xffE5E5E5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green, // Custom AppBar background color
      centerTitle: true, // Center the title
      elevation: 0.0, // Remove the shadow for a flatter look
      titleTextStyle: TextStyle(
        fontSize: 24.0, // Increased font size
        fontWeight: FontWeight.bold, // Bold font weight
        letterSpacing: 1.5, // Increased letter spacing for a cleaner look
        color: Colors.white, // Text color
      ),
      iconTheme: const IconThemeData(
        color: Colors.white, // Custom color for back arrow and other icons
      ),
    ),
    
  
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black, fontFamily: "Open Sans"),
      bodySmall: TextStyle(color: Colors.black),
      labelMedium: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
      ),
      labelSmall: TextStyle(
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        vertical: SizeConfig.height * 2,
        horizontal: SizeConfig.width * 2,
      ),
      hintStyle: TextStyle(
        fontSize: SizeConfig.width * 4,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red.shade400,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red.shade400,
        ),
      ),
    ),
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black38,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      centerTitle: true, // Center the title
      elevation: 0.0, // Remove the shadow for a flatter look
      titleTextStyle: TextStyle(
        fontSize: 24.0, // Increased font size
        fontWeight: FontWeight.bold, // Bold font weight
        letterSpacing: 1.5, // Increased letter spacing for a cleaner look
        color: Colors.white, // Text color
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: Colors.white,
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white, fontFamily: "Open Sans"),
      bodyLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(
        color: Colors.white,
        fontFamily: "Open Sans",
      ),
      labelSmall: TextStyle(
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontFamily: "Open Sans",
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      hintStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

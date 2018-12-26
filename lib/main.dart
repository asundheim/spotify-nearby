import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotify_nearby/backend/themeService.dart' as themeService;

import 'pages/auth.dart';
import 'pages/home.dart';

/*
 * TODO: Local Storage for Auth keys
 * TODO: Set up Nearby for Android
 * TODO: Set up Nearby for iOS
 * TODO: Basic Spotify Auth flow
 * TODO: Transmit Spotify data
 * TODO: Implement Nearby Sharing toggle in settings
 * TODO: Implement Logout in settings
 */


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

// Needs to be stateful to correctly change theme
class MyAppState extends State<MyApp> {

  // Variables used to manage a dark theme
  String _color = 'blue';
  bool _isDark = false;

  // TODO add to the token from the auth page so it reroutes, also shared pref if not already
  static String token;

  @override
  Widget build(BuildContext context) {

    // loads theme data and color data
    _loadColor();
    _loadDarkMode();

    final Map<String, MaterialColor> colorMap = <String, MaterialColor> {
      'blue': Colors.blue,
      'red': Colors.red,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'pink': Colors.pink,
      'purple': Colors.purple,
      'cyan': Colors.cyan
    };

    // Main Material app return calling home class
    // Main theme for the entire application, Do not override primary color
    // of children otherwise primary app color picker won't function on it
    return MaterialApp(
      title: 'Spotify Nearby',
      theme: ThemeData(
        primarySwatch: colorMap[_color],
        brightness: _isDark ? Brightness.dark : Brightness.light, //Controls dark theme
      ),
     initialRoute: (token == null) ? '/auth' : '/',
      // ignore: always_specify_types
      routes: {
        '/': (BuildContext context) => Home(),
        '/auth': (BuildContext context) => Auth(),
      }
    );
  }

  // Accesses theme data stored in shared preferences "darkMode"
  Future<void> _loadDarkMode() async {
    final bool dark = await themeService.darkThemeEnabled();
    setState(() {
      _isDark = dark;
    });
  }

  Future<void> _loadColor() async {
    final String currentColor = await themeService.getColor();
    setState(() {
      _color = currentColor;
    });
  }
}


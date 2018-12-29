import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/themeService.dart' as themeService;
import 'backend/spotifyService.dart' as spotifyService;
import 'backend/storageService.dart';

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
  final Map<String, MaterialColor> colorMap = <String, MaterialColor> {
    'blue': Colors.blue,
    'red': Colors.red,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'pink': Colors.pink,
    'purple': Colors.purple,
    'cyan': Colors.cyan
  };

  @override
  Widget build(BuildContext context) {

    // loads theme data and color data
    _loadColor();
    _loadDarkMode();
    _getAuth();
    return MaterialApp(
        title: 'Spotify Nearby',
        theme: ThemeData(
          primarySwatch: colorMap[_color],
          brightness: _isDark ? Brightness.dark : Brightness.light, //Controls dark theme
        ),
        home: FutureBuilder<SharedPreferences>(
          future: getStorageInstance(),
          builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.hasData) {
              if (spotifyService.tokenExists(snapshot.data)) {
                return Home();
              }
              return Auth();
            } else {
              // Splash screen goes here
              return Text('loading');
            }
          }
        ),
    );
    // Main Material app return calling home class
    // Main theme for the entire application, Do not override primary color
    // of children otherwise primary app color picker won't function on it
  }

  // Accesses theme data stored in shared preferences "darkMode"
  Future<void> _loadDarkMode() async {
    SharedPreferences prefs = await getStorageInstance();
    setState(() {
      _isDark = themeService.darkThemeEnabled(prefs);
    });
  }

  Future<void> _loadColor() async {
    SharedPreferences prefs = await getStorageInstance();
    setState(() {
      _color = themeService.getColor(prefs);
    });
  }

  Future<String> _getAuth() async {
    SharedPreferences prefs = await getStorageInstance();
    if (spotifyService.tokenExists(prefs)) {
      if (spotifyService.authTokenExpired(prefs)) {
        spotifyService.refreshAuth(spotifyService.getRefreshToken(prefs), prefs);
      }
    }
    return spotifyService.getAuthToken(prefs);
  }
}


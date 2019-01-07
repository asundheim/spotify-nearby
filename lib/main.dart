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


void main() {
  runApp(MyApp());
  Timer.periodic(Duration(seconds: 5), (Timer t) => refresh());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

// Needs to be stateful to correctly change theme
class MyAppState extends State<MyApp> {

  // Variables used to manage a dark theme
  String _color = 'blue';
  bool _isDark = false;
  @override
  void initState() {
    _loadColor();
    _loadDarkMode();
    _getAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _loadColor();
    _loadDarkMode();
    return MaterialApp(
        title: 'Spotify Nearby',
        theme: ThemeData(
          primarySwatch: themeService.mapColor(_color),
          brightness: _isDark ? Brightness.dark : Brightness.light, //Controls dark theme
        ),
        initialRoute: '/',
        // ignore: always_specify_types
        routes: {
          '/': (BuildContext context) => FutureBuilder<SharedPreferences>(
            future: getStorageInstance(),
            builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
              if (snapshot.hasData) {
                if (spotifyService.tokenExists(snapshot.data)) {
                  return Home();
                } else {
                  return Auth();
                }
                } else {
                  // Splash screen goes here
                  return const Text('loading');
                }
              }
            ),
          '/home': (BuildContext context) => Home(),
          '/auth': (BuildContext context) => Auth(),
        }
    );
    // Main Material app return calling home class
    // Main theme for the entire application, Do not override primary color
    // of children otherwise primary app color picker won't function on it
  }

  // Accesses theme data stored in shared preferences "darkMode"
  Future<void> _loadDarkMode() async {
    final SharedPreferences prefs = await getStorageInstance();
    setState(() {
      _isDark = themeService.darkThemeEnabled(prefs);
    });
  }

  Future<void> _loadColor() async {
    final SharedPreferences prefs = await getStorageInstance();
    setState(() {
      _color = themeService.getColor(prefs);
    });
  }

  Future<String> _getAuth() async {
    final SharedPreferences prefs = await getStorageInstance();
    if (spotifyService.tokenExists(prefs)) {
      if (spotifyService.authTokenExpired(prefs)) {
        spotifyService.refreshAuth(spotifyService.getRefreshToken(prefs), prefs);
      }
    }
    return spotifyService.getAuthToken(prefs);
  }
}

Future<void> refresh()  async {
  spotifyService.updateInfo(spotifyService.getAuthToken(await getStorageInstance()), await getStorageInstance());
}
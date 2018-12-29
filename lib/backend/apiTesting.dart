import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'spotifyService.dart' as spotifyService;
import 'storageService.dart';

String loginURL = 'https://accounts.spotify.com/authorize'
    '?client_id=a08c7a5c79304ac1bb28fed5b687f0c1'
    '&response_type=code'
    '&redirect_uri=http://localhost:4200/spotify'
    '&scope=user-read-currently-playing'
    '&show_dialog=true';

String nowPlaying = '';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription<dynamic> _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _setNowPlaying(String s) {
    setState(() {
      nowPlaying = s;
    });
  }
  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();
    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: Text('Webview Destroyed')));
      }
    });

    // First time flow only
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (mounted) {
        if (url.split('?')[0] == 'http://localhost:4200/spotify') {
          setState(() {
            flutterWebviewPlugin.close();
          });
          spotifyService.initialAuth(url.split('=')[1], await getStorageInstance()).then((
              Response response) => print('Initial Auth Complete'));
        }
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  Future<void> handleLogin() async {
    final SharedPreferences prefs = await getStorageInstance();
    // Check for first time
    if (spotifyService.tokenExists(prefs)) {
      // If token has expired, update it
      if (spotifyService.authTokenExpired(prefs)) {
        spotifyService.refreshAuth(spotifyService.getRefreshToken(prefs), prefs).then((Response result) => handleLogin());
      } else {
        // Test Spotify calls here
        _setNowPlaying((await spotifyService.getNowPlaying(spotifyService.getAuthToken(prefs)))['name']);
      }
      // Used to test first use flow
     spotifyService.clearTokens(prefs);
    } else {
      // Show the login page for first time account
      flutterWebviewPlugin.launch(loginURL);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Spotify Auth Shit'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  handleLogin();
                },
                child: const Text('Login'),
              ),
              RaisedButton(
                onPressed: () async {
                  spotifyService.clearTokens(await getStorageInstance());
                },
                child: const Text('Clear Tokens'),
              ),
              Text('Now Playing: ' + nowPlaying),
            ]),
      );
  }

}
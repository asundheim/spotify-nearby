import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:spotify_nearby/backend/spotifyService.dart' as spotifyService;

String loginURL = 'https://accounts.spotify.com/authorize'
    '?client_id=a08c7a5c79304ac1bb28fed5b687f0c1'
    '&response_type=code'
    '&redirect_uri=http://localhost:4200/spotify'
    '&scope=user-read-currently-playing'
    '&show_dialog=true';
const String kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';
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
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          if (url.split('?')[0] == 'http://localhost:4200/spotify') {
            flutterWebviewPlugin.close();
            spotifyService.initialAuth(url.split('=')[1]).then((Response response) => print('Initial Auth Complete'));
          }
        });
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
    // Check for first time
    if (await spotifyService.tokenExists()) {
      // If token has expired, update it
      if (await spotifyService.authTokenExpired()) {
        spotifyService.refreshAuth(await spotifyService.getRefreshToken()).then((Response result) => handleLogin());
      } else {
        // Test Spotify calls here
        spotifyService.getNowPlaying(await spotifyService.getAuthToken()).then((Response response){
          _setNowPlaying(json.decode(response.body)['item']['name']);
        });
      }
      // Used to test first use flow
      // spotifyService.clearToken();
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
              Text('Now Playing: ' + nowPlaying),
            ]),
      );
  }

}
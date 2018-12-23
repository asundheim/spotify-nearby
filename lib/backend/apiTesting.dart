import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:spotify_nearby/backend/spotifyService.dart' as spotifyService;
import 'dart:async';
import 'dart:convert';

String loginURL = 'https://accounts.spotify.com/authorize'
    '?client_id=a08c7a5c79304ac1bb28fed5b687f0c1'
    '&response_type=code'
    '&redirect_uri=http://localhost:4200/spotify'
    '&scope=user-read-currently-playing'
    '&show_dialog=true';
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';
String nowPlaying = '';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

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
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // First time flow only
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          if (url.split('?')[0] == 'http://localhost:4200/spotify') {
            flutterWebviewPlugin.close();
            spotifyService.initialAuth(url.split('=')[1]).then((response) => print('Initial Auth Complete'));
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

  void handleLogin() async {
    // Check for first time
    if (await spotifyService.tokenExists()) {
      // If token has expired, update it
      if (await spotifyService.authTokenExpired()) {
        spotifyService.refreshAuth().then((result) => handleLogin());
      } else {
        // Test Spotify calls here
        spotifyService.getNowPlaying().then((response){
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
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: const Text('Spotify Auth Shit'),
        ),
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new RaisedButton(
                onPressed: () {
                  handleLogin();
                },
                child: const Text('Login'),
              ),
              new Text('Now Playing: ' + nowPlaying),
            ]),
      );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String selectedUrl = 'https://accounts.spotify.com/authorize'
    '?client_id=a08c7a5c79304ac1bb28fed5b687f0c1'
    '&response_type=code'
    '&redirect_uri=http://localhost:4200/spotify'
    '&scope=user-read-currently-playing'
    '&show_dialog=true';
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';
String aToken = '';
int timeToExpired = 1;
/*routes: {
'/': (_) => const MyHomePage(title: 'Flutter WebView Demo'),
'/widget': (_) => new WebviewScaffold(
url: 'https://accounts.spotify.com/authorize'
'?a08c7a5c79304ac1bb28fed5b687f0c1'
'&response_type=token'
'&redirect_uri=http://localhost:4200/spotify'
'&scope=user-read-currently-playing',
appBar: new AppBar(
title: const Text('Spotify Webview'),
),
withZoom: true,
withLocalStorage: true,
)
},*/


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

  final _history = [];
  var _redirectString = '';
  void _() {
    setState(() {

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

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          if (url.split('?')[0] == 'http://localhost:4200/spotify') {
            flutterWebviewPlugin.close();
          }
          _redirectString = url;
          postCode(url.split('=')[1]).then((response){
            Map map = json.decode(response.body);
            print('Body: ' + map.toString());
            updateTokens(map['access_token'], map['refresh_token'], map['expires_in'].toString());
          });
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

  Future<http.Response> postCode(String code) {
    print('posting code: ' + code);
    return http.post('https://accounts.spotify.com/api/token', body: constructHeader(code));
  }

  void updateTokens(String accessToken, String refreshToken, String duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('refresh_token', refreshToken);
    prefs.setString('auth_token', accessToken);
    prefs.setInt('expire_time', int.parse(duration));
    prefs.setInt('set_time', DateTime.now().millisecondsSinceEpoch);
    setState(() {
      aToken = accessToken;
    });
    print('Updated Refresh token: ' + refreshToken);
  }

  Future<bool> tokenExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().contains('refresh_token');
  }

  Future<String> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<String> authToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('auth_token');
    setState(() {
      aToken = token;
    });
    return token;
  }


  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<int> authTokenExpired() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int expired = prefs.getInt('set_time') + (1000 * prefs.getInt('expire_time')) - DateTime.now().millisecondsSinceEpoch;
    setState(() {
      timeToExpired = expired;
    });
    return expired;
  }

  void handleLogin() async {
    if (await tokenExists()) {
      await authToken();
      if (await authTokenExpired() < 0) {
        postCode(await refreshToken()).then((result) {
          print('Token exists. Body = ' + result.body);
        });
      }
      clearToken();
    } else {
      flutterWebviewPlugin.launch(selectedUrl);
    }
  }

  Map constructHeader(String authCode) {
    Map map = new Map();
      map['grant_type'] = 'authorization_code';
      map['code'] = authCode;
      map['redirect_uri'] = 'http://localhost:4200/spotify';
      map['client_id'] = 'a08c7a5c79304ac1bb28fed5b687f0c1';
      map['client_secret'] = '2d710351a8ef47c18e29c875da325b7f';
    return map;
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
              new Text('Auth Token: ' + aToken),
              new Text('Time till expired : ' + (timeToExpired/1000).toString() + 'Seconds'),
            ]),
      );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';

String selectedUrl = 'https://accounts.spotify.com/authorize'
    '?a08c7a5c79304ac1bb28fed5b687f0c1'
    '&response_type=token'
    '&redirect_uri=http://localhost:4200/spotify'
    '&scope=user-read-currently-playing';
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

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
          _history.add('onUrlChanged: $url');
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new RaisedButton(
                onPressed: () {
                  flutterWebviewPlugin.launch(selectedUrl);
                },
                child: const Text('Open Fullscreen Webview'),
              ),
            ]),
      );
  }

}
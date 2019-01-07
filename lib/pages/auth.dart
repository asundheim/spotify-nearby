import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../backend/spotifyService.dart' as spotifyService;
import '../backend/storageService.dart';

String loginURL = 'https://accounts.spotify.com/authorize'
    '?client_id=a08c7a5c79304ac1bb28fed5b687f0c1'
    '&response_type=code'
    '&redirect_uri=http://localhost:4200/spotify'
    '&scope=user-read-currently-playing'
    '&show_dialog=true';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  StreamSubscription<dynamic> _onDestroy;
  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    flutterWebviewPlugin.close();

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (mounted) {
        if (url.split('?')[0] == 'http://localhost:4200/spotify') {
          setState(() {
            flutterWebviewPlugin.close();
          });
          await spotifyService.initialAuth(url.split('=')[1], await getStorageInstance());
          Navigator.pop(context);
          Navigator.pushNamed(context, '/home');
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green,
      child: InkWell(
        // TODO fix error here
        onTap: () => setState(() => flutterWebviewPlugin.launch(loginURL).catchError((e) => print('error Launch loginURL'))),
        splashColor: Colors.greenAccent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: <Widget>[
                const Text(
                  'Please Authorize Spotify',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                      'Tap anywhere',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: Image(
                        image: const AssetImage('assets/res/spotify.png'),
                        width: 112.0,
                        height: 112.0,
                        color: Colors.green[300],
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
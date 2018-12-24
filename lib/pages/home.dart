import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';
import 'package:spotify_nearby/backend/apiTesting.dart';

class Home extends StatefulWidget {
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {

  String _token;

  @override
  Widget build(BuildContext context) {

    // Launch auth page, currently broken don't uncomment
    //_loadAuth();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Spotify Nearby"),
        // Anything that should be on appbar should be added to actions List
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())))
        ],
      ),
      body: new Material(
        child: Center(
          child:
          new RaisedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage())),
              child: new Text('API Stuff'),
          ),
        ),
      ),
    );
  }

  _loadAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token') ?? null;
    if (_token == null) Navigator.pushNamed(context, '/auth');
  }
}
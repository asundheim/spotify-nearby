import 'package:flutter/material.dart';

import 'settings.dart';
import 'package:spotify_nearby/backend/MyHomepage.dart';

class Home extends StatefulWidget {
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Spotify Nearby"),
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
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage())))
        ),
      ),
    );
  }
}
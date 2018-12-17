import 'package:flutter/material.dart';

/*
 * TODO: Build basic UI controls
 * TODO: Set up Nearby for Android
 * TODO: Set up Nearby for iOS
 * TODO: Basic Spotify Auth flow
 * TODO: Transmit Spotify data
 * TODO: Add UI for list of nearby users
 * TODO: Add UI page for account
 * TODO: Settings page
 */
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "spotify-nearby",
      theme: new ThemeData(
        primaryColor: Colors.greenAccent,
        brightness: Brightness.light,
      ),
      home: new Material(
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text("Spotify Nearby"),
          ),
        )
      )
    );
  }
}
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new Material(
        child: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[],
        ),
      ),
    );
  }
}
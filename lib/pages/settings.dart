import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {

  // Initialization and declaration on _isDark to prevent errors with async methods
  bool _isDark = false;

  // Loads the initial state when opened and calls _loadDarkTheme to see if
  // button should be pressed
  @override
  void initState() {
    _loadDarkTheme();
    super.initState();
  }

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
          children: <Widget>[
            _newSettingSwitch("Dark Theme", "Changes in app theme to dark", _isDark, _setDarkTheme)
          ],
        ),
      ),
    );
  }

  // Generic Widget for creating a simple switch setting, provide onChange
  // with a function call
  Widget _newSettingSwitch(String title, String subtitle, bool value, onChange) {
    return new ListTile(
      title: new Text(title),
      subtitle: new Text(subtitle),
      trailing: new Switch(
          value: value,
          onChanged: onChange,
      ),
    );
  }

  // Loads the initial dark theme bool from SharedPreferences, if non are found
  // loads as false (?? operator).
  _loadDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = (prefs.getBool("darkMode") ?? false);
    });
  }

  // Saves the dark theme bool value to SharedPreferences
  _setDarkTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("darkMode", value);
      _isDark = prefs.get("darkMode");
    });
  }
}
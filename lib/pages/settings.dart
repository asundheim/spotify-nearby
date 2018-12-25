import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_nearby/backend/apiTesting.dart';
import 'package:spotify_nearby/backend/themeService.dart' as themeService;

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
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new Material(
        child: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _newSettingSwitch(
                title: 'Dark Theme',
                subtitle: 'Changes in app theme to dark',
                value: _isDark,
                onChange: _toggleDarkTheme,
                key: new Key('toggleDarkTheme')
            ),
            _textButton(
                text: 'Spotify API stuff',
                subtitle: 'shhhhh',
                key: new Key('API')
            ),
          ],
        ),
      ),
    );
  }

  // Generic Widget for creating a simple switch setting, provide onChange
  //  // with a function call
  Widget _newSettingSwitch({String title, String subtitle, bool value, onChange, Key key}) {
    return new ListTile(
      title: new Text(title),
      subtitle: new Text(subtitle),
      trailing: new Switch(
          value: value,
          onChanged: onChange,
      ),
      key: key,
    );
  }

  Widget _textButton({String text, String subtitle, Key key}) {
    return new ListTile(
      title: new Text(text),
      subtitle: new Text(subtitle),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage())),
      key: key,
    );
  }

  // Loads the initial dark theme bool from SharedPreferences, if non are found
  // loads as falses
  _loadDarkTheme() async {
    bool dark = await themeService.darkThemeEnabled();
    setState(() {
      _isDark = dark;
    });
  }

  // Saves the dark theme bool value to SharedPreferences
  _toggleDarkTheme(bool value) async {
    setState(() {
      themeService.toggleDarkTheme(value);
      _isDark = value;
    });
  }
}
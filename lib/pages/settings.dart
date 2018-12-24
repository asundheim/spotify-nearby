import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {

  // Initialization and declaration on _isDark to prevent errors with async methods
  bool _isDark = false;
  bool _isSharing = true;
  String _themeColorString = "blue";

  // Loads the initial state when opened and calls _loadDarkTheme to see if
  // button should be pressed
  @override
  void initState() {
    _loadSharing();
    _loadDarkTheme();
    _loadThemeColor();
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
            _newSettingSwitch("Dark Theme", "Changes in app theme to dark", _isDark, _setDarkTheme),
            _themeColor(),
            _newSettingSwitch("Currently Sharing", "Toggles nearby sharing", _isSharing, _setSharing),
            _accountSetting(),
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

  // Allows user to see connected account and logout
  Widget _accountSetting() {
    return new ListTile(
      title: Text("My account"),
      subtitle: Text("Account Name"),
      trailing: RaisedButton(
        child: Text("Logout"),
        onPressed: null)
    );
  }

  Widget _themeColor() {
    return new ListTile(
      title: Text("Primary Theme Color"),
      subtitle: Text("Changes theme to selected color"),
      trailing:
        // TODO Make color current color
        PopupMenuButton<String>(
          icon: Icon(Icons.color_lens, color: null,),
          onSelected: (String result) {
            setState(() {
              _setThemeColor(result);
            });
        },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "Colors.blue",
                  child: Text("Blue")
              ),
              const PopupMenuItem<String>(
                  value: "Colors.green",
                  child: Text("Green")
              ),
              const PopupMenuItem<String>(
                  value: "Colors.red",
                  child: Text("Red")
              ),
  ],
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

  _loadSharing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSharing = (prefs.getBool("sharing") ?? true);
    });
  }

  _setSharing(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("sharing", value);
      _isSharing = prefs.get("sharing");
    });
  }

  _loadThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeColorString = (prefs.getString("themeColor") ?? "blue");
    });
  }

  _setThemeColor(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("themeColor", value);
      _themeColorString = prefs.getString("ThemeColor");
    });
  }
}
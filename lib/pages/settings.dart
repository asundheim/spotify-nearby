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
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new Material(
        child: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _themeColor(),
            _newSettingSwitch(
              title: "Currently Sharing", 
              subtitle: "Toggles nearby sharing", 
              value: _isSharing, 
              onChange: _setSharing,
              key: new Key('currentlySharing')
            ),
            _accountSetting(),
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

  // Generic Widget for creating a simple switch setting, provide onChange with a function call
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
          icon: Icon(Icons.color_lens, color: null),
          onSelected: (String result) {
            setState(() {
              _setThemeColor(result);
            });
        },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "blue",
                  child: Text("Blue")
              ),
              const PopupMenuItem<String>(
                  value: "green",
                  child: Text("Green")
              ),
              const PopupMenuItem<String>(
                  value: "red",
                  child: Text("Red")
              ),
              const PopupMenuItem<String>(
                  value: "yellow",
                  child: Text("Yellow")
              ),
              const PopupMenuItem<String>(
                  value: "pink",
                  child: Text("Pink")
              ),
              const PopupMenuItem<String>(
                  value: "purple",
                  child: Text("Purple")
              ),
              const PopupMenuItem<String>(
                  value: "cyan",
                  child: Text("Cyan")
              ),
  ],
        ),
      );
  }

  // Loads the initial dark theme bool from SharedPreferences, if none are found
  // loads as false
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

  // TODO: put this all in themeService and write unit tests
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
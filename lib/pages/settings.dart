import 'package:flutter/material.dart';

import '../backend/apiTesting.dart';
import '../backend/settingsService.dart' as settingsService;
import '../backend/spotifyService.dart' as spotifyService;
import '../backend/themeService.dart' as themeService;


class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {

  // Initialization and declaration on _isDark to prevent errors with async methods
  bool _isDark = false;
  bool _isSharing = true;
  // ignore: unused_field
  String _themeColorString = 'blue';
  String _currentUser = 'Loading...';

  // Loads the initial state when opened and calls _loadDarkTheme to see if
  // button should be pressed
  @override
  void initState() {
    _loadSharing();
    _loadDarkTheme();
    _loadThemeColor();
    _loadCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Material(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            _themeColor(),
            _newSettingSwitch(
                title: 'Dark Theme',
                subtitle: 'Changes in app theme to dark',
                value: _isDark,
                onChange: _toggleDarkTheme,
                key: const Key('toggleDarkTheme')
            ),
            _newSettingSwitch(
              title: 'Currently Sharing',
              subtitle: 'Toggles nearby sharing',
              value: _isSharing, 
              onChange: _setSharing,
              key: const Key('currentlySharing')
            ),
            _accountSetting(),
            _textButton(
                text: 'Spotify API stuff',
                subtitle: 'shhhhh',
                key: const Key('API')
            ),
          ],
        ),
      ),
    );
  }

  // Generic Widget for creating a simple switch setting, provide onChange with a function call
  // ignore: strong_mode_implicit_dynamic_parameter, always_specify_types
  Widget _newSettingSwitch({String title, String subtitle, bool value, onChange, Key key}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
          value: value,
          onChanged: onChange,
      ),
      key: key,
    );
  }

  Widget _textButton({String text, String subtitle, Key key}) {
    return ListTile(
      title: Text(text),
      subtitle: Text(subtitle),
      onTap: () => Navigator.push<Object> (
          context,
          MaterialPageRoute<dynamic>(builder: (BuildContext context) => const MyHomePage())
      ),
      key: key,
    );
  }

  // Allows user to see connected account and logout
  Widget _accountSetting() {
    return ListTile(
      title: const Text('My account'),
      subtitle: Text((_currentUser == null) ? 'Not signed in' : _currentUser),
      trailing: const RaisedButton(
        child: Text('Logout'),
        onPressed: null)
    );
  }

  Widget _themeColor() {
    return ListTile(
      title: const Text('Primary Theme Color'),
      subtitle: const Text('Changes theme to selected color'),
      trailing:
        // TODO Make color current color
        PopupMenuButton<String>(
          icon: const Icon(Icons.color_lens, color: null),
          onSelected: (String result) {
            setState(() {
              _setThemeColor(result);
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'blue',
                child: Text('Blue')
            ),
            const PopupMenuItem<String>(
                value: 'green',
                child: Text('Green')
            ),
            const PopupMenuItem<String>(
                value: 'red',
                child: Text('Red')
            ),
            const PopupMenuItem<String>(
                value: 'yellow',
                child: Text('Yellow')
            ),
            const PopupMenuItem<String>(
                value: 'pink',
                child: Text('Pink')
            ),
            const PopupMenuItem<String>(
                value: 'purple',
                child: Text('Purple')
            ),
            const PopupMenuItem<String>(
                value: 'cyan',
                child: Text('Cyan')
            ),
          ],
        ),
      );
  }

  // Loads the initial dark theme bool from SharedPreferences, if none are found
  // loads as false
  Future<void> _loadDarkTheme() async {
    final bool dark = await themeService.darkThemeEnabled();
    setState(() => _isDark = dark);
  }

  // Saves the dark theme bool value to SharedPreferences
  Future<void> _toggleDarkTheme(bool value) async {
    setState(() {
      themeService.toggleDarkTheme(value);
      _isDark = value;
    });
  }

  Future<void> _loadSharing() async {
    final bool sharing = await settingsService.isSharing();
    setState(() => _isSharing = sharing);
  }

  Future<void> _setSharing(bool value) async {
    await settingsService.setSharing(value);
    setState(() => _isSharing = value);
  }

  Future<void> _loadThemeColor() async {
    final String color = await themeService.getColor();
    setState(() => _themeColorString = color);
  }

  Future<void> _setThemeColor(String value) async {
    await themeService.setColor(value);
    setState(() => _themeColorString = value);
  }

  Future<void> _loadCurrentUser() async {
    final String user = await spotifyService.getCurrentUser();
    setState(() => _currentUser = user);
  }
}
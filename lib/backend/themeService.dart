import 'package:shared_preferences/shared_preferences.dart';

bool darkThemeEnabled(SharedPreferences prefs) =>
    prefs.getBool('darkMode') ?? false;

// Saves the dark theme bool value to SharedPreferences
void toggleDarkTheme(bool value, SharedPreferences prefs) =>
    prefs.setBool('darkMode', value);

String getColor(SharedPreferences prefs) =>
    prefs.getString('themeColor') ?? 'blue';

void setColor(String color, SharedPreferences prefs) =>
    prefs.setString('themeColor', color);


void clearPrefs(SharedPreferences prefs) => prefs.remove('darkMode');


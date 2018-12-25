import 'package:shared_preferences/shared_preferences.dart';

Future<bool> darkThemeEnabled() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('darkMode') ?? false;
}

// Saves the dark theme bool value to SharedPreferences
Future<bool> toggleDarkTheme(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('darkMode', value);
  return prefs.getBool('darkMode');
}

Future<void> clearPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('darkMode');
}

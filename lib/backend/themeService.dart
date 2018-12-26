import 'package:shared_preferences/shared_preferences.dart';

Future<bool> darkThemeEnabled() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('darkMode') ?? false;
}

// Saves the dark theme bool value to SharedPreferences
Future<void> toggleDarkTheme(bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('darkMode', value);
}

Future<String> getColor() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('themeColor') ?? 'blue';
}

Future<void> setColor(String color) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeColor', color);
}

Future<void> clearPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('darkMode');
}

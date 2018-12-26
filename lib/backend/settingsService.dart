
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isSharing() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('sharing') ?? true;
}

Future<void> setSharing(bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('sharing', value);
}

Future<void> clearPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('sharing');
}
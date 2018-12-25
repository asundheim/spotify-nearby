
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isSharing() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('sharing') ?? true;
}

Future<bool> setSharing(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('sharing', value);
  return value;
}

Future<void> clearPrefs() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('sharing');
}
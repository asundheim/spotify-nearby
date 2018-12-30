import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getStorageInstance() async {
  return SharedPreferences.getInstance();
}

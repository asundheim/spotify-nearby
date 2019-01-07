import 'nearbyService.dart' as neabyService;
import 'package:shared_preferences/shared_preferences.dart';

bool isSharing(SharedPreferences prefs) =>
    prefs.getBool('sharing') ?? true;

void setSharing(bool value, SharedPreferences prefs) {
  prefs.setBool('sharing', value);
  if (!value) {
    neabyService.stopNearbyService();
  }
}


void clearPrefs(SharedPreferences prefs) =>
    prefs.remove('sharing');
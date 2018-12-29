import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_nearby/backend/storageService.dart';
import 'package:spotify_nearby/backend/settingsService.dart' as settingsService;

void main() {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });

  setUp(() async => settingsService.clearPrefs(await getStorageInstance()));

  test('toggling should update prefs', () async {
    SharedPreferences prefs = await getStorageInstance();
    settingsService.setSharing(false, prefs);

    expect(settingsService.isSharing(prefs), false);

    settingsService.setSharing(true, prefs);

    expect(settingsService.isSharing(prefs), true);
  });
}
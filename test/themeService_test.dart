import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_nearby/backend/storageService.dart';
import 'package:spotify_nearby/backend/themeService.dart' as themeService;

void main() {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });

  setUp(() async => themeService.clearPrefs(await getStorageInstance()));

  test('toggling dark mode should update prefs', () async {
    SharedPreferences prefs = await getStorageInstance();
    themeService.toggleDarkTheme(true, prefs);

    expect(themeService.darkThemeEnabled(prefs), true);
  });

  test('default value should be false', () async {
    SharedPreferences prefs = await getStorageInstance();
    expect(themeService.darkThemeEnabled(prefs), false);
  });
}
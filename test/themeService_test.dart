import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_nearby/backend/themeService.dart' as themeService;

void main() {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });

  setUp(() async => themeService.clearPrefs());

  test('toggling dark mode should update prefs', () async {
    await themeService.toggleDarkTheme(true);

    expect(await themeService.darkThemeEnabled(), true);
  });

  test('default value should be false', () async {
    expect(await themeService.darkThemeEnabled(), false);
  });
}

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_nearby/backend/settingsService.dart' as settingsService;

void main() {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });

  setUp(() async => await settingsService.clearPrefs());

  test('toggling should update prefs', () async {
    await settingsService.setSharing(false);

    expect(await settingsService.isSharing(), false);

    await settingsService.setSharing(true);

    expect(await settingsService.isSharing(), true);
  });
}
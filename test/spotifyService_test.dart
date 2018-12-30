import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_nearby/backend/spotifyService.dart' as spotifyService;
import 'package:spotify_nearby/backend/storageService.dart';

void main() {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });

  setUp(() async => spotifyService.clearTokens(await getStorageInstance()));

  test('initial auth storage', () async {
    SharedPreferences prefs = await getStorageInstance();
    // Mock http calls
    spotifyService.client = MockClient((Request request) async {
      final Map<String, dynamic> mapJson = <String, dynamic> {
        'access_token': 'testAccessToken',
        'expires_in': 3600,
        'refresh_token': 'testRefreshToken'
      };
      return Response(json.encode(mapJson), 200);
    });

    expect(spotifyService.getAuthToken(prefs), null);
    expect(spotifyService.getRefreshToken(prefs), null);

    await spotifyService.initialAuth('', prefs);

    expect(spotifyService.getAuthToken(prefs), 'testAccessToken');
    expect(spotifyService.getRefreshToken(prefs), 'testRefreshToken');
  });

  test('refresh auth storage', () async {
    SharedPreferences prefs = await getStorageInstance();
    // Mock http calls
    spotifyService.client = MockClient((Request request) async {
      final Map<String, dynamic> mapJson = <String, dynamic> {
        'access_token': 'testAccessToken1',
        'expires_in': 3600
      };
      return Response(json.encode(mapJson), 200);
    });

    expect(spotifyService.getAuthToken(prefs), null);
    expect(spotifyService.getRefreshToken(prefs), null);

    await spotifyService.refreshAuth('', prefs);

    expect(spotifyService.getAuthToken(prefs), 'testAccessToken1');
    expect(spotifyService.getRefreshToken(prefs), null);

    spotifyService.client = MockClient((Request request) async {
      final Map<String, dynamic> mapJson = <String, dynamic> {
        'access_token': 'testAccessToken2',
        'expires_in': 3600,
        'refresh_token': 'testRefreshToken2'
      };
      return Response(json.encode(mapJson), 200);
    });

    await spotifyService.refreshAuth('', prefs);

    expect(spotifyService.getAuthToken(prefs), 'testAccessToken2');
    expect(spotifyService.getRefreshToken(prefs), 'testRefreshToken2');
  });

  test('detect expired token', () async {
    SharedPreferences prefs = await getStorageInstance();
    // Mock http calls
    spotifyService.client = MockClient((Request request) async {
      final Map<String, dynamic> mapJson = <String, dynamic>{
        'access_token': 'testAccessToken',
        'expires_in': 1,
        'refresh_token': 'testRefreshToken'
      };
      return Response(json.encode(mapJson), 200);
    });

    await spotifyService.initialAuth('', prefs);

    expect(spotifyService.authTokenExpired(prefs), false);

    await Future<dynamic>.delayed(Duration(milliseconds: 2000));

    expect(spotifyService.authTokenExpired(prefs), true);
  });
}
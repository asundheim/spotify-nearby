import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:spotify_nearby/backend/spotifyService.dart' as spotifyService;

void main() {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });

  setUp(() async => await spotifyService.clearTokens());

  test('initial auth storage', () async {
    // Mock http calls
    spotifyService.client = MockClient((Request request) async {
      final Map<String, dynamic> mapJson = <String, dynamic> {
        'access_token': 'testAccessToken',
        'expires_in': 3600,
        'refresh_token': 'testRefreshToken'
      };
      return Response(json.encode(mapJson), 200);
    });

    expect(await spotifyService.getAuthToken(), null);
    expect(await spotifyService.getRefreshToken(), null);

    await spotifyService.initialAuth('');

    expect(await spotifyService.getAuthToken(), 'testAccessToken');
    expect(await spotifyService.getRefreshToken(), 'testRefreshToken');
  });

  test('refresh auth storage', () async {
    // Mock http calls
    spotifyService.client = MockClient((Request request) async {
      final Map<String, dynamic> mapJson = <String, dynamic> {
        'access_token': 'testAccessToken1',
        'expires_in': 3600
      };
      return Response(json.encode(mapJson), 200);
    });

    expect(await spotifyService.getAuthToken(), null);
    expect(await spotifyService.getRefreshToken(), null);

    await spotifyService.refreshAuth('');

    expect(await spotifyService.getAuthToken(), 'testAccessToken1');
    expect(await spotifyService.getRefreshToken(), null);

    spotifyService.client = MockClient((Request request) async {
      final Map<String, dynamic> mapJson = <String, dynamic> {
        'access_token': 'testAccessToken2',
        'expires_in': 3600,
        'refresh_token': 'testRefreshToken2'
      };
      return Response(json.encode(mapJson), 200);
    });

    await spotifyService.refreshAuth('');

    expect(await spotifyService.getAuthToken(), 'testAccessToken2');
    expect(await spotifyService.getRefreshToken(), 'testRefreshToken2');
  });

  test('detect expired token', () async {
    // Mock http calls
    spotifyService.client = MockClient((Request request) async {
      final Map<String, dynamic> mapJson = <String, dynamic>{
        'access_token': 'testAccessToken',
        'expires_in': 1,
        'refresh_token': 'testRefreshToken'
      };
      return Response(json.encode(mapJson), 200);
    });

    await spotifyService.initialAuth('');

    expect(await spotifyService.authTokenExpired(), false);

    await Future<dynamic>.delayed(Duration(milliseconds: 2000));

    expect(await spotifyService.authTokenExpired(), true);
  });
}
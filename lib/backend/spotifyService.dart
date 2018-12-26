import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

String client_id = 'a08c7a5c79304ac1bb28fed5b687f0c1';
String client_secret = '2d710351a8ef47c18e29c875da325b7f';

Client client = Client();

Future<Response> initialAuth(String code) {
  return client.post('https://accounts.spotify.com/api/token', headers:  clientHeaders(), body: preAuthBody(code)).then((Response response){
    final Map<String, dynamic> map = json.decode(response.body);
    updateAuthToken(map['access_token']);
    updateRefreshToken(map['refresh_token']);
    updateExpireTime(map['expires_in'].toString());
  });
}

Future<Response> refreshAuth(String refreshToken) {
  return client.post('https://accounts.spotify.com/api/token', headers: clientHeaders(), body: refreshBody(refreshToken)).then((Response result) {
    final Map<String, dynamic> map = json.decode(result.body);
    updateAuthToken(map['access_token']);
    updateExpireTime(map['expires_in'].toString());
    if (map.containsKey('refresh_token')) {
      updateRefreshToken(map['refresh_token']);
    }
  });
}

Future<Response> getNowPlaying(String authToken) async {
  return client.get('https://api.spotify.com/v1/me/player/currently-playing', headers: authHeaders(authToken));
}

Future<void> updateAuthToken(String authToken) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('auth_token', authToken);
}

Future<void> updateExpireTime(String duration) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('expire_time', int.parse(duration));
  prefs.setInt('set_time', DateTime.now().millisecondsSinceEpoch);
}

Future<void> updateRefreshToken(String refreshToken) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('refresh_token', refreshToken);
}

Future<bool> tokenExists() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getKeys().contains('refresh_token');
}

Future<String> getRefreshToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('refresh_token');
}

Future<String> getAuthToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('auth_token');
  return token;
}

Future<void> clearTokens() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('auth_token');
  prefs.remove('refresh_token');
  prefs.remove('set_time');
  prefs.remove('expire_time');
}

Future<bool> authTokenExpired() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int expired = prefs.getInt('set_time') + (1000 * prefs.getInt('expire_time')) - DateTime.now().millisecondsSinceEpoch;
  return expired < 0;
}

Map<String, String> clientHeaders() {
  return <String, String> {
    'Authorization': 'Basic ${base64Encode(utf8.encode(client_id + ':' + client_secret))}'
  };
}

Map<String, String> authHeaders(String authCode) {
  return <String, String> {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authCode'
  };
}

Map<String, String> preAuthBody(String authCode) {
  return <String, String>{
    'grant_type': 'authorization_code',
    'code': authCode,
    'redirect_uri': 'http://localhost:4200/spotify'
  };
}

Map<String, String> refreshBody(String refreshToken) {
  return <String, String> {
    'grant_type': 'refresh_token',
    'refresh_token': refreshToken
  };
}

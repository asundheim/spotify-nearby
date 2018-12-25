import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String client_id = 'a08c7a5c79304ac1bb28fed5b687f0c1';
String client_secret = '2d710351a8ef47c18e29c875da325b7f';

http.Client client = http.Client();

Future<http.Response> initialAuth(String code) {
  return client.post('https://accounts.spotify.com/api/token', headers:  clientHeaders(), body: preAuthBody(code)).then((response){
    Map map = json.decode(response.body);
    updateAuthToken(map['access_token']);
    updateRefreshToken(map['refresh_token']);
    updateExpireTime(map['expires_in'].toString());
  });
}

Future<http.Response> refreshAuth(String refreshToken) {
  return client.post('https://accounts.spotify.com/api/token', headers: clientHeaders(), body: refreshBody(refreshToken)).then((result) {
    Map map = json.decode(result.body);
    updateAuthToken(map['access_token']);
    updateExpireTime(map['expires_in'].toString());
    if (map.containsKey('refresh_token')) {
      updateRefreshToken(map['refresh_token']);
    }
  });
}

Future<http.Response> getNowPlaying(String authToken) async {
  return client.get('https://api.spotify.com/v1/me/player/currently-playing', headers: authHeaders(authToken));
}

void updateAuthToken(String authToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('auth_token', authToken);
}

void updateExpireTime(String duration) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('expire_time', int.parse(duration));
  prefs.setInt('set_time', DateTime.now().millisecondsSinceEpoch);
}

void updateRefreshToken(String refreshToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('refresh_token', refreshToken);
}

Future<bool> tokenExists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getKeys().contains('refresh_token');
}

Future<String> getRefreshToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('refresh_token');
}

Future<String> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('auth_token');
  return token;
}

Future<void> clearTokens() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('auth_token');
  prefs.remove('refresh_token');
  prefs.remove('set_time');
  prefs.remove('expire_time');
}

Future<bool> authTokenExpired() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int expired = prefs.getInt('set_time') + (1000 * prefs.getInt('expire_time')) - DateTime.now().millisecondsSinceEpoch;
  return expired < 0;
}

Map<String, String> clientHeaders() {
  Map<String, String> map = new Map<String, String>();
  map['Authorization'] = 'Basic ${base64Encode(utf8.encode(client_id+':'+client_secret))}';
  return map;
}

Map<String, String> authHeaders(String authCode) {
  Map<String, String> map = new Map<String, String>();
  map['Content-Type'] = 'application/json';
  map['Authorization'] = 'Bearer $authCode';
  return map;
}

Map<String, String> preAuthBody(String authCode) {
  Map<String, String> map = new Map<String, String>();
  map['grant_type'] = 'authorization_code';
  map['code'] = authCode;
  map['redirect_uri'] = 'http://localhost:4200/spotify';
  return map;
}

Map<String, String> refreshBody(String refreshToken) {
  Map<String, String> map = new Map<String, String>();
  map['grant_type'] = 'refresh_token';
  map['refresh_token'] = refreshToken;
  return map;
}

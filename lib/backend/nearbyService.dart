import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storageService.dart';
import 'spotifyService.dart' as spotifyService;
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

final String uniqueID = uuid.v4();
const MethodChannel platform = MethodChannel('com.anderssundheim.spotifynearby/nearby');

String spotifyUsername;
String currentSong = 'none';
String trackID = 'none';

List<dynamic> receivedUniqueID = <dynamic>[];
List<String> receivedSpotifyUsername;
List<String> receivedCurrentSong;
List<String> receivedTrackID;

String test = 'null';

void sendUniqueID(String message) {
  try {
    platform.invokeMethod('sendUniqueID',{'uniqueID': uniqueID});
  } on PlatformException catch (e) {
    print(e.message);
  }
}

void clearData() {
  receivedUniqueID = null;
  receivedSpotifyUsername = null;
  receivedCurrentSong = null;
  receivedTrackID = null;
}

void startNearbyService() {
  try {
    platform.invokeMethod('startNearbyService');
  } on PlatformException catch (e) {
    print(e.message);
  }
}

Future<void> getConnectionsID() async {
  try {
    final List<dynamic> result = await platform.invokeMethod('getConnections');

    if (result != null) {
    receivedUniqueID.replaceRange(0, receivedUniqueID.length, result);
    int index = 0;
    for (int i = index; i < receivedUniqueID.length; i++){
      sendPayload(receivedUniqueID[i], await createPayload());
      index++;
    }
    //
    }
  } on PlatformException catch (e) {
    print(e.message);
  }
}

void sendPayload(String endpointID, String payload) {
  try {
    platform.invokeMethod('payload',<String, String> {'endpointID': endpointID, 'payload': payload},);
  } on PlatformException catch (e) {
    print(e.message);
  }
}

Future<void> receivedData() async {
  String outputData;
  try {
    final String result = await platform.invokeMethod('receivedPayload');
    if (result != null) {
      outputData = result;
    }
  } on PlatformException catch (e) {
    print(e.message);
  }
  // TEMP FOR TESTING
  test = outputData;
  // TODO add data parsing
}

Future<String> createPayload() async {
  await loadData();
  return '$spotifyUsername|$currentSong|$trackID';
}

  // TODO: this will need to be updated periodically
  Future<void> loadData() async {
    final SharedPreferences prefs = await getStorageInstance();
    final String playing = await spotifyService.getNowPlaying(spotifyService.getAuthToken(prefs))
        .then((Map<String, dynamic> map) => map['name']);
    final String track = await spotifyService.getNowPlaying(spotifyService.getAuthToken(prefs))
        .then((Map<String, dynamic> map) => map['id']);
    spotifyUsername = spotifyService.getCurrentUser(prefs);
    currentSong = playing;
    trackID = track;
  }



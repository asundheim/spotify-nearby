import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = new Uuid();

final String uniqueID = uuid.v4();
final platform = MethodChannel('com.anderssundheim.spotifynearby/nearby');

String spotifyUsername;
String currentSong;
String trackID;

List<String> receivedUniqueID;
List<String> receivedSpotifyUsername;
List<String> receivedCurrentSong;
List<String> receivedTrackID;

void _clearData() async {
  receivedUniqueID = null;
  receivedSpotifyUsername = null;
  receivedCurrentSong = null;
  receivedTrackID = null;
}

Future<void> _startNearbyService() async {
  String outputID;
  try {
    final String result = await platform.invokeMethod('start');
    outputID = result;
  } on PlatformException catch (e) {
    print(e.message);
    outputID = "error";
  }
  receivedUniqueID.add(outputID);
}

void _sendPayload() {
  // Todo Must send target ID, and payload
  try {
    platform.invokeMethod('payload');
  } on PlatformException catch (e) {
    print(e.message);
  }
}

Future<void> _receivedData() async {
  String outputData;
  try {
    final String result = await platform.invokeMethod('start');
    outputData = result;
  } on PlatformException catch (e) {
    print(e.message);
    outputData = "error";
  }
  // TODO add data parsing
}

String _createPayload() {
  // TODO create payload
  return null;
}





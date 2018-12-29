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

String test = 'null';

void sendUniqueID(String message) {
  try {
    platform.invokeMethod('sendUniqueID',{"uniqueID": uniqueID});
  } on PlatformException catch (e) {
    print(e.message);
  }
}

void clearData() async {
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

Future<void> getConnectionsID() async{
  try {
    final String result = await platform.invokeMethod('getConnections');
    if (result != null) {
      sendPayload(result, createPayload());
    }
  } on PlatformException catch (e) {
    print(e.message);
  }
}

void sendPayload(String endpointID, String payload) {
  try {
    platform.invokeMethod('payload',{"endpointID": endpointID, "payload": payload},);
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

String createPayload() {
  return "Testing payload";
}





import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'spotifyService.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

final String uniqueID = uuid.v4();
const MethodChannel platform = MethodChannel('com.anderssundheim.spotifynearby/nearby');

// TODO need values to be spotify data, Thanks ders love you bby <3
String spotifyUsername;
String currentSong;
String trackID;

List<dynamic> receivedUniqueID = new List();
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

Future<void> getConnectionsID() async{
  try {
    final List<dynamic> result = await platform.invokeMethod('getConnections');

    if (result != null) {
    receivedUniqueID.replaceRange(0, receivedUniqueID.length, result);
    int index = 0;
    for (int i = index; i < receivedUniqueID.length; i++){
      sendPayload(receivedUniqueID[i], createPayload());
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

String createPayload() {
<<<<<<< HEAD
  return "payload test";
=======
  return 'Testing payload';
>>>>>>> master
}

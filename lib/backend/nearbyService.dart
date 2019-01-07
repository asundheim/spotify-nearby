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
List<String> receivedSpotifyUsername = <String>['DarthEvandar','Budde25'];
List<String> receivedCurrentSong = <String>['My Favorite Song', 'Fireflies'];
List<String> receivedTrackID = <String>['0FutrWIUM5Mg3434asiwkp', '3DamFFqW32WihKkTVlwTYQ'];

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
  String unparsedData;
  try {
    final String result = await platform.invokeMethod('receivedPayload');
    if (result != null) {
      unparsedData = result;
    }
  } on PlatformException catch (e) {
    print(e.message);
  }
  // TODO check for errors
  List<String> parsedData = unparsedData.split('|');
  receivedSpotifyUsername.add(parsedData[0]);
  receivedCurrentSong.add(parsedData[1]);
  receivedTrackID.add(parsedData[2]);
}

Future<String> createPayload() async {
  await loadData();
  //print('$spotifyUsername|$currentSong|$trackID');
  return '$spotifyUsername|$currentSong|$trackID';
}

  // TODO: this will need to be updated periodically
  Future<void> loadData() async {
    final SharedPreferences prefs = await getStorageInstance();
    spotifyUsername = spotifyService.getCurrentUser(prefs);
    currentSong = spotifyService.getNowPlaying(prefs);
    trackID = spotifyService.getSongId(prefs);
  }



import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storageService.dart';
import 'spotifyService.dart' as spotifyService;
import 'settingsService.dart' as settingsService;
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

final String uniqueID = uuid.v4();
const MethodChannel platform = MethodChannel('com.anderssundheim.spotifynearby/nearby');

String spotifyUsername;
String currentSong = 'none';
String trackID = 'none';

List<dynamic> receivedUniqueID = <dynamic>[];
List<String> receivedUserAccount = <String>[];
List<String> receivedSongTitle = <String>[];
List<String> receivedSongUrl = <String>[];

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
  receivedUserAccount = null;
  receivedSongTitle = null;
  receivedSongUrl = null;
}

Future<void> startNearbyService() async {
  final SharedPreferences prefs = await getStorageInstance();
  if (settingsService.isSharing(prefs)) {
    try {
      platform.invokeMethod('startNearbyService');
    } on PlatformException catch (e) {
      print(e.message);
    }
  } else {
    print('Sharing is off');
    // TODO prompt user to turn sharing on, bc why would you turn it off?
  }
}

void stopNearbyService() {
  try {
    platform.invokeMethod('stopNearbyService');
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
    for (int i = index; i < receivedUniqueID.length; i++) {
      String payload = await createPayload();
      while (payload == null) {
        await Future<dynamic>.delayed(Duration(seconds: 5));
        print('payload null, realoding');
        await createPayload();
      }
      sendPayload(receivedUniqueID[i], payload);
      index++;
    }}
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
      print('Recieved a valid payload');
    } else {
      print('Recievied a null paylaod');
      return;
    }
  } on PlatformException catch (e) {
    print(e.message);
  }
  List<String> parsedData;
  if (unparsedData != null) {
    print('Parsing Data');
    parsedData = unparsedData.split('|');
  } else {
    print('Error parsedData not length 3');
    print('Parsed data is: $parsedData');
    print('Unparsed data is $unparsedData');
    return;
  }
  if (parsedData != null && parsedData.length == 3) {
    bool isAdded = false;
    if (receivedUserAccount != null) {
      for (int i = 0; i < receivedUserAccount.length; i++) {
        if (receivedUserAccount[i] == parsedData[0]) {
          receivedSongTitle.insert(i, parsedData[1]);
          receivedSongUrl.insert(i, parsedData[2]);
          print('Updated old entry');
          isAdded = true;
        }
      }
      if (!isAdded) {
        receivedUserAccount.add(parsedData[0]);
        receivedSongTitle.add(parsedData[1]);
        receivedSongUrl.add(parsedData[2]);
        print('Added new entry');
      }
    } else {
      print('Parse list error');
    }
  } else {
    print('Got some null data somehow, idk fix it');
    return;
  }
}

Future<String> createPayload() async {
  await loadData();
  if (spotifyUsername != null || currentSong != null || trackID != null) {
    print('Created payload');
    return '$spotifyUsername|$currentSong|$trackID';
  } else {
    return null;
  }
}

  Future<void> loadData() async {
    final SharedPreferences prefs = await getStorageInstance();
    spotifyUsername = spotifyService.getCurrentUser(prefs);
    currentSong = spotifyService.getNowPlaying(prefs);
    trackID = spotifyService.getSongId(prefs);
  }



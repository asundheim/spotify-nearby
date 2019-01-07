import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nearbyService.dart' as nearbyService;

class Nearby extends StatefulWidget {
  @override
  NearbyState createState() => NearbyState();
}

class NearbyState extends State<Nearby> {

  static const MethodChannel platform = MethodChannel(
      'com.anderssundheim.spotifynearby/nearby');

  String payload = 'loading';

  Future<void> makePayload() async {
    payload = await nearbyService.createPayload();
}

  @override
  Widget build(BuildContext context) {
    makePayload();
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(onPressed: _startNearby, child: const Text('Start'),),
              RaisedButton(onPressed: _onPressed, child: const Text('Refresh'),),
              Text(nearbyService.sharing ? 'Sharing' : 'Not Sharing'),
              Text('ID: ' + nearbyService.uniqueID),
              Text('Connected IDs: ' + nearbyService.receivedUniqueID.toString()),
              Text('My payload: $payload'),
              Text('Payload: ' + nearbyService.test)
            ],
          ),
        ),
      ),
    );
  }


  // Show status

  void _onPressed() {
    setState(() {
      nearbyService.getConnectionsID();
      nearbyService.receivedData();
    });
}

  Future<void> _startNearby() async {
    nearbyService.startNearbyService();
  }
}

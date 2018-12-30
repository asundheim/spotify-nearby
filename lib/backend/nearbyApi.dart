import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nearbyService.dart' as nearbyService;

class Nearby extends StatefulWidget {
  @override
  NearbyState createState() => NearbyState();
}

class NearbyState extends State<Nearby> {

  static const platform = const MethodChannel('com.anderssundheim.spotifynearby/nearby');

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(onPressed: _startNearby, child: Text('Start'),),
              RaisedButton(onPressed: _onPressed, child: Text('Refresh'),),
              RaisedButton(onPressed: _payload, child: Text('Send Payload'),),
              Text(_status),
              Text('ID: ' + nearbyService.uniqueID),
              Text('Connected IDs: implement later'),
              Text('Payload: ' + nearbyService.test)
            ],
          ),
        ),
      ),
    );
  }


  // Get battery level.
  String _status = 'Null';
  String _connectedIDs = 'Null';
  String _otherID = 'Null';

  void _onPressed() {
    setState(() {
      nearbyService.getConnectionsID();
      nearbyService.receivedData();
    });
}

  Future<void> _startNearby() async {
    nearbyService.startNearbyService();
    setState(() => _status = "Discovery and Advertising On");
  }

  Future<void> _getConnections() async {
    String out;
    try {
      final String result = await platform.invokeMethod('connections');
      out = result;
    } on PlatformException catch (e) {
      out = "Error gc: '${e.message}'.";
    }
    setState(() => _connectedIDs = out);
  }

  Future<void> _payload() async {
    String out;
    try {
      final String result = await platform.invokeMethod('payload');
      out = result;
    } on PlatformException catch (e) {
      out = "Error id: '${e.message}'.";
    }
    //setState(() => _id = out);
  }

  Future<void> _payloadResults() async {
    String out;
    try {
      final String result = await platform.invokeMethod('payloadResults');
      out = result;
    } on PlatformException catch (e) {
      out = "Error id: '${e.message}'.";
    }
    setState(() => _otherID = out);
  }
}


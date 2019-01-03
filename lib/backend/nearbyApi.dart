import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nearbyService.dart' as nearbyService;

class Nearby extends StatefulWidget {
  @override
  NearbyState createState() => NearbyState();
}

class NearbyState extends State<Nearby> {

  static const MethodChannel platform = MethodChannel('com.anderssundheim.spotifynearby/nearby');

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(onPressed: _startNearby, child: const Text('Start'),),
              RaisedButton(onPressed: _onPressed, child: const Text('Refresh'),),
              Text(_status),
              Text('ID: ' + nearbyService.uniqueID),
              Text('Connected IDs: ' + nearbyService.receivedUniqueID.toString()),
              Text('Payload: ' + nearbyService.test)
            ],
          ),
        ),
      ),
    );
  }


  // Show status
  String _status = 'Null';

  void _onPressed() {
    setState(() {
      nearbyService.getConnectionsID();
      nearbyService.receivedData();
    });
}

  Future<void> _startNearby() async {
    nearbyService.startNearbyService();
    setState(() => _status = 'Discovery and Advertising On');
  }
}

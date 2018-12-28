import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              Text(_result),
              Text('ID: $_id'),
              Text('Connections: $_connections'),
              Text('Payload: $_otherID')
            ],
          ),
        ),
      ),
    );
  }


  // Get battery level.
  String _result = 'blank';
  String _id = 'blank';
  String _connections = 'blank';
  String _otherID = 'blank';

  void _onPressed() {
  _getConnections();
  _myID();
  _payloadR();
}

  Future<void> _startNearby() async {
    String out;
    try {
      final String result = await platform.invokeMethod('start');
      out = 'result: $result';
    } on PlatformException catch (e) {
      out = "Failed to start nearby: '${e.message}'.";
    }
    setState(() => _result = out);
  }

  Future<void> _getConnections() async {
    String out;
    try {
      final String result = await platform.invokeMethod('connections');
      out = result;
    } on PlatformException catch (e) {
      out = "Error gc: '${e.message}'.";
    }
    setState(() => _connections = out);
  }

  Future<void> _myID() async {
    String out;
    try {
      final String result = await platform.invokeMethod('id');
      out = result;
    } on PlatformException catch (e) {
      out = "Error id: '${e.message}'.";
    }
    setState(() => _id = out);
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

  Future<void> _payloadR() async {
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


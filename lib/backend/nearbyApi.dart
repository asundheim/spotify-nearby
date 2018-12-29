import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              RaisedButton(onPressed: _startNearby),
              Text(_result),
            ],
          ),
        ),
      ),
    );
  }


  // Get battery level.
  String _result = 'blank';

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
}


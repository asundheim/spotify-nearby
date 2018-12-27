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
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(onPressed: _startNearby),
            Text(_result),
          ],
        ),
      ),
    );
  }


  // Get battery level.
  String _result = 'blank';

  Future<void> _startNearby() async {
    String out;
    try {
      final int result = await platform.invokeMethod('start');
      out = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      out = "Failed to start nearby: '${e.message}'.";
    }

    setState(() {
      _result = out;
    });
  }
}


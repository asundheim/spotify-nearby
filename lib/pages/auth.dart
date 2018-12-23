import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.green,
      child: InkWell(
        splashColor: Colors.greenAccent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                new Text(
                  "Please authorize Spotify",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Center(
                  child: new Image(image: null)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
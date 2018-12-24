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
        onTap: () {
          // Todo add auth page link
          setState(() {
          });
        },
        splashColor: Colors.greenAccent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: <Widget>[
                Text(
                  "Please Authorize Spotify",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                      "Click anywhere",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: new Center(
                      child: new Image(
                          image:
                          AssetImage('assets/res/spotify.png'),
                        width: 112.0,
                        height: 112.0,
                        color: Colors.green[300],
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
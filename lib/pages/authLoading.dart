import 'package:flutter/material.dart';

class AuthLoading extends StatefulWidget {
  @override
  _AuthLoadingState createState() => _AuthLoadingState();
}

class _AuthLoadingState extends State<AuthLoading> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green,
      child: InkWell(
        splashColor: Colors.greenAccent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: <Widget>[
                const Text(
                  'Loading',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: const CircularProgressIndicator()
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

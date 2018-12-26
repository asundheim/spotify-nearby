import 'package:flutter/material.dart';
import 'package:spotify_nearby/backend/spotifyService.dart' as spotifyService;
import 'package:spotify_nearby/pages/auth.dart';
import 'settings.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    // Launch auth page, currently broken don't uncomment
    //_loadAuth();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Nearby'),
        // Anything that should be on appbar should be added to actions List
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push<Object>(
                  context,
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) => Settings()))
          )
        ],
      ),
      body: Material(
        child: Center(
          child: Column(
            // TODO add gesture controller to refresh
            children: <Widget>[
              const LinearProgressIndicator(
                // TODO change value to 1 when done loading
                value: null,
              ),
              InkWell(
                // TODO ontap launches your spotify
                onTap: () => setState(() {
                  }),
              child: const ListTile(
                title: Text('My Username', textAlign: TextAlign.center),
                subtitle: Text('My Currently playing Song', textAlign: TextAlign.center),
                ),
              ),
              Expanded(
              child: ListView.builder(
                // Max 50 items for now, increase for each nearby
                  itemCount: 50,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (BuildContext context, int index) {
                    const Padding(padding: EdgeInsets.all(16.0));
                    return InkWell(
                      onTap: () => setState(() {
                      }),
                      child: ListTile(
                        title: const Text('PlaceHolder Title'),
                        subtitle: const Text('PlaceHolder Subtitle'),
                        trailing: const Icon(Icons.music_note),
                        // TODO add an onTap event to listen to that music
                        onTap: () => Navigator.push<Object>(
                            context,
                            MaterialPageRoute<dynamic>(builder: (BuildContext context) => Auth())
                        ),
                    )
                    );
                  }
              ),
              )
            /*new RaisedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage())),
            child: new Text('API Stuff'),
        ),*/
          ]
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Future<void> _loadAuth() async {
    if (!(await spotifyService.tokenExists())) {
      Navigator.pushNamed(context, '/auth');
    }
  }
}
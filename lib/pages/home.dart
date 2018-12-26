import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:spotify_nearby/backend/spotifyService.dart' as spotifyService;
import 'package:spotify_nearby/pages/auth.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String currentUser = '';
  String currentlyPlaying = '';

  @override
  void initState() {
    loadCurrentUser();
    loadCurrentlyPlaying();
    super.initState();
  }

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
          child: GestureDetector(
            onHorizontalDragDown: (dynamic e) => (dynamic e) => const SnackBar(
              content: Text('update'),
            ),
          child: Column(
            // TODO add gesture controller to refresh
            children: <Widget>[
              const LinearProgressIndicator(
                // TODO change value to 1 when done loading
                value: null,
              ),
              InkWell(
                // TODO ontap launches your spotify
                onTap: () => setState(() => _launchSpotify()),
              child: ListTile(
                title: Text('Signed in as: $currentUser', textAlign: TextAlign.center),
                subtitle: Text('Currently Playing: $currentlyPlaying', textAlign: TextAlign.center),
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
                      onTap: () => setState(() {}),
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
          ]
          ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchSpotify() async {
    const String url = 'https://open.spotify.com/track';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // ignore: unused_element
  Future<void> _loadAuth() async {
    if (!(await spotifyService.tokenExists())) {
      Navigator.pushNamed(context, '/auth');
    }
  }

  Future<void> loadCurrentUser() async {
    final String user = await spotifyService.getCurrentUser();
    setState(() => currentUser = user);
  }

  // TODO: this will need to be updated periodically
  Future<void> loadCurrentlyPlaying() async {
    final String playing = await spotifyService.getNowPlaying(await spotifyService.getAuthToken());
    setState(() => currentlyPlaying = playing);
  }
}
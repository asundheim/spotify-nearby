import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/spotifyService.dart' as spotifyService;
import 'package:spotify_nearby/pages/auth.dart';
import '../backend/storageService.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String currentUser = '';
  String currentlyPlaying = '';
  // TODO Initialized with test values, delete when implementing, just pass data too all three Lists
  static List<String> userAccount = <String>['DarthEvandar','Budde25', 'peanut'];
  static List<String> songTitle = <String>['My Favorite Song', 'Fireflies'];
  static List<String> songUrl = <String>['0FutrWIUM5Mg3434asiwkp', '3DamFFqW32WihKkTVlwTYQ'];
  static List<List<String>> titleData = <List<String>>[userAccount,songTitle,songUrl];
  static int _listLength = 0;

  @override
  void initState() {
    loadCurrentUser();
    loadCurrentlyPlaying();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _listLengthMin();

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
                onTap: () => setState(() => _launchSpotify('')),
              child: ListTile(
                title: Text('Signed in as: $currentUser', textAlign: TextAlign.center),
                subtitle: Text('Currently Playing: $currentlyPlaying', textAlign: TextAlign.center),
                ),
              ),
              Expanded(
              child: ListView.builder(
                // Max 50 items for now, increase for each nearby
                  itemCount: _listLength,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (BuildContext context, int index) {
                    const Padding(padding: EdgeInsets.all(16.0));
                    return InkWell(
                      onTap: () => setState(() {}),
                      child: ListTile(
                        title: Text(titleData[1][index]),
                        subtitle: Text(titleData[0][index]),
                        trailing: const Icon(Icons.music_note),
                        onTap: () => _launchSpotify(titleData[2][index])
                        ),
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

  void _listLengthMin() {
    setState(() {
      for (int i = 0; i < 2; i++) {
        userAccount.length < songTitle.length ? _listLength = userAccount.length : _listLength = songTitle.length;
        userAccount.length < songUrl.length ? _listLength = userAccount.length : _listLength = songUrl.length;
      }
    });
  }

  Future<void> _launchSpotify(String track) async {
    final String url = 'https://open.spotify.com/track/$track';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // ignore: unused_element
  Future<void> _loadAuth() async {
    if (!(spotifyService.tokenExists(await getStorageInstance()))) {
      Navigator.pushNamed(context, '/auth');
    }
  }

  Future<void> loadCurrentUser() async {
    SharedPreferences prefs = await getStorageInstance();
    setState(() => currentUser = spotifyService.getCurrentUser(prefs));
  }

  // TODO: this will need to be updated periodically
  Future<void> loadCurrentlyPlaying() async {
    final String playing = await spotifyService.getNowPlaying(spotifyService.getAuthToken(await getStorageInstance()));
    setState(() => currentlyPlaying = playing);
  }
}
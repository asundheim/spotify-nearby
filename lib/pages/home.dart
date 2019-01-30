import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/spotifyService.dart' as spotifyService;
import 'package:spotify_nearby/backend/nearbyService.dart' as nearbyService;
import '../backend/storageService.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  // TODO also need values here, thanks!
  String currentUser;
  String currentlyPlaying;

  static List<String> userAccount = <String>[];
  static List<String> songTitle = <String>[];
  static List<String> songUrl = <String>[];
  static List<List<String>> titleData = <List<String>>[userAccount,songTitle,songUrl];
  static int _listLength = 0;

  @override
  void initState() {
    _loadNowPlaying();
    _loadCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _listLengthMin();
    _loadNowPlaying();
    _loadCurrentUser();
    _updateTiles();

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
                onTap: () =>  _launchSpotify(''),
              child: ListTile(
                title: Text(currentlyPlaying == null ? 'Nothing is playing': currentlyPlaying, textAlign: TextAlign.center),
                subtitle: Text(currentUser == null ? 'Not logged in' : currentUser, textAlign: TextAlign.center),
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

  // Should actually be useless but doesn't hurt, might save us trouble down the line
  void _listLengthMin() {
    if (userAccount != null && songUrl != null && songTitle != null) {
      setState(() {
        for (int i = 0; i < 2; i++) {
          userAccount.length < songTitle.length ?
          _listLength = userAccount.length : _listLength = songTitle.length;
          userAccount.length < songUrl.length
              ? _listLength = userAccount.length
              : _listLength = songUrl.length;
        }
      });
    }
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
    if (!spotifyService.tokenExists(await getStorageInstance())) {
      Navigator.pushNamed(context, '/auth');
    }
  }

  Future<void> _loadCurrentUser() async {
    final SharedPreferences prefs = await getStorageInstance();
    setState(() => currentUser = spotifyService.getCurrentUser(prefs));
  }

  void _loadNowPlaying() async {
    final SharedPreferences prefs = await getStorageInstance();
    setState(() => currentlyPlaying = spotifyService.getNowPlaying(prefs));
  }

  void _updateTiles() {
    setState(() {
      userAccount = nearbyService.receivedUserAccount;
      songTitle = nearbyService.receivedSongTitle;
      songUrl = nearbyService.receivedSongUrl;
    });
  }
}
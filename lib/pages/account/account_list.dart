import 'package:flutter/material.dart';
import 'package:musical_application/pages/account/playlists/playlist_page.dart';
import 'package:musical_application/utils/content_types.dart';

import '../../data_provider.dart';
import '../../models/dto/trackartist.dart';
import '../../models/playlist.dart';
import 'playlists/create_playlist_page.dart';

class SavedPage extends StatefulWidget {
  final ContentTypes pageType;
  final void Function(String trackId, String songName, String artistName,
      bool isAdded, String path) changeSong;

  SavedPage({super.key, required this.pageType, required this.changeSong});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final _dataProvider = DataProvider();

  @override
  Widget build(BuildContext context) {
    switch (widget.pageType) {
      case ContentTypes.music:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text("Saved tracks"),
          ),
          body: FutureBuilder(
            future: _dataProvider.getAccountTracks(), //
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.red));
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (snapshot.data!.isEmpty) {
                return Container();
              }

              var tracks = snapshot.data as List<TrackArtist>;
              return ListView.builder(
                itemCount: tracks.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, ind) {
                  var track = tracks[ind];
                  return ListTile(
                    title: Text(track.trackName),
                    subtitle: Text(track.artistName),
                    onTap: () => {
                      widget.changeSong(track.trackId, track.trackName,
                          track.artistName, track.isAdded, track.path)
                    },
                  );
                },
              );
            },
          ),
        );
      case ContentTypes.playlist:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text("Saved playlists"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePlaylistPage()),
                  );
                },
              ),
            ],
          ),
          body: FutureBuilder(
            future: _dataProvider.getUserPlaylists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.red));
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (snapshot.data!.isEmpty) {
                return Container();
              }

              var playlists = snapshot.data as List<Playlist>;
              return ListView.builder(
                itemCount: playlists.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, ind) {
                  var playlist = playlists[ind];
                  return ListTile(
                    title: Text(playlist.name),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistPage(
                            playlistId: playlist.id!,
                            artistId: playlist.artistId,
                            name: playlist.name,
                            description: playlist.description,
                            isPublic: playlist.isPublic,
                            changeSong: widget.changeSong,
                          ),
                        ),
                      )
                    },
                  );
                },
              );
            },
          ),
        );
      default:
        return Container();
    }
  }
}

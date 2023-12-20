// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';
import 'package:musical_application/pages/account/playlists/add_playlist_songs_page.dart';

import '../../../components/my_button.dart';
import '../../../models/dto/trackartist.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;
  final String name;
  final String description;
  final _dataProvider = DataProvider();

  PlaylistPage(
      {super.key,
      required this.name,
      required this.playlistId,
      required this.description});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Playlist"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 150,
                height: 150,
                color: Colors.grey,
                child: const Icon(
                  Icons.music_note,
                  size: 125,
                  color: Colors.white38,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 20),
          Text(widget.name),
          const SizedBox(height: 20),
          widget.description.isNotEmpty
              ? Text(widget.description)
              : Container(),
          const SizedBox(height: 12),
          SizedBox(
            width: 250,
            height: 65,
            child: MyButton(
              text: "Add tracks",
              color: Colors.red,
              onTap: () async {
                final trackIds = await widget._dataProvider
                    .getPlaylistTracks(widget.playlistId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SongsPage(
                          playlistId: widget.playlistId,
                          trackIds: trackIds.map((t) => t.trackId).toList())),
                );
              },
            ),
          ),
          const Divider(color: Colors.red),
          FutureBuilder(
            future: widget._dataProvider.getPlaylistTracks(widget.playlistId),
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
                    onTap: () => {},
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

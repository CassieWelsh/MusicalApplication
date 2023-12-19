import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';

import '../../../models/dto/trackartist.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;
  final String name;
  final _dataProvider = DataProvider();

  PlaylistPage({super.key, required this.name, required this.playlistId});

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
          Text(widget.name),
          const SizedBox(height: 25),
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

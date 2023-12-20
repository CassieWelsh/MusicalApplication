// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';

import '../../../components/my_button.dart';
import '../../../models/dto/trackartist.dart';

class SongsPage extends StatefulWidget {
  final String playlistId;

  final Iterable<String> trackIds;

  const SongsPage(
      {super.key, required this.playlistId, required this.trackIds});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final _dataProvider = DataProvider();
  late Future future = _dataProvider.getMainPageTracks();
  Map<String, bool> values = <String, bool>{};

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add tracks"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text("Search: "),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _searchController,
                  onChanged: (a) {
                    if (_searchController.text.isNotEmpty)
                      setState(() {
                        future = _dataProvider
                            .getMainPageTracksBySearch(_searchController.text);
                      });
                    else
                      setState(() {
                        future = _dataProvider.getMainPageTracks();
                      });
                  },
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: future,
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

              final tracks = snapshot.data as List<TrackArtist>;
              return ListView.builder(
                itemCount: tracks.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, ind) {
                  final track = tracks[ind];
                  if (!values.containsKey(track.trackId) &&
                      widget.trackIds.any((t) => t == track.trackId))
                    values[track.trackId] = true;

                  if (!values.containsKey(track.trackId))
                    values[track.trackId] = false;

                  return CheckboxListTile(
                    title: Text(track.trackName),
                    subtitle: Text(track.artistName),
                    value: values[track.trackId],
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null) {
                          values[track.trackId] = value;
                        }
                      });
                    },
                    //onTap: () => {},
                  );
                },
              );
            },
          ),
          SizedBox(
            height: 65,
            child: MyButton(
              text: "Add selected",
              color: Colors.red,
              onTap: () async {
                await _dataProvider.updatePlaylistTracks(widget.playlistId, values);
                Navigator.of(context).popUntil((p) => p.isFirst);
              }
            ),
          ),
        ],
      ),
    );
  }
}

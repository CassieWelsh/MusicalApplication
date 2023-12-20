// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';
import 'package:musical_application/pages/account/playlists/add_playlist_songs_page.dart';

import '../../../components/my_button.dart';
import '../../../components/my_textfield.dart';
import '../../../models/dto/trackartist.dart';

class PlaylistPage extends StatefulWidget {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final String playlistId;
  String name;
  String description;
  bool isPublic;
  final _dataProvider = DataProvider();
  void Function(String trackId, String songName, String artistName,
      bool isAdded, String path) changeSong;
  final String artistId;

  PlaylistPage(
      {super.key,
      required this.name,
      required this.playlistId,
      required this.artistId,
      required this.description,
      required this.isPublic,
      required this.changeSong});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late final _nameController = TextEditingController()..text = widget.name;
  late final _descriptionController = TextEditingController()
    ..text = widget.description;
  bool editMode = false;
  bool isActive = false;
  late Future<List<TrackArtist>> future =
      widget._dataProvider.getPlaylistTracks(widget.playlistId);

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
          !editMode
              ? Text("Name: ${widget.name}")
              : MyTextField(
                  hintText: "",
                  controller: _nameController,
                  obscureText: false,
                ),
          editMode
              ? MyTextField(
                  controller: _descriptionController,
                  hintText: "",
                  obscureText: false)
              : Container(),
          !editMode && widget.description.isNotEmpty
              ? Text("Description: ${widget.description}")
              : Container(),
          const SizedBox(height: 12),
          editMode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("IsPublic", style: TextStyle(fontSize: 18)),
                    Checkbox(
                        value: widget.isPublic,
                        onChanged: (value) => setState(() {
                              widget.isPublic = value!;
                            })),
                  ],
                )
              : Container(),
          !editMode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                                    trackIds: trackIds
                                        .map((t) => t.trackId)
                                        .toList())),
                          );
                        },
                      ),
                    ),
                    widget.artistId == widget.userId ? TextButton(
                      onPressed: () {
                        setState(() {
                          editMode = true;
                        });
                      },
                      child: const Icon(Icons.edit),
                    ) : Container()
                  ],
                )
              : Column(
                  children: [
                    MyButton(
                      onTap: () async {
                        await widget._dataProvider.updatePlaylist(
                            widget.playlistId,
                            _nameController.text,
                            _descriptionController.text,
                            widget.isPublic);
                        setState(() {
                          editMode = false;
                          future = widget._dataProvider
                              .getPlaylistTracks(widget.playlistId);
                          widget.name = _nameController.text;
                          widget.description = _descriptionController.text;
                        });
                      },
                      text: "Save",
                      color: Colors.green,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                      onTap: () async {
                        await widget._dataProvider
                            .removePlaylist(widget.playlistId);
                        Navigator.pop(context);
                      },
                      text: "Delete",
                      color: Colors.red,
                    ),
                  ],
                ),
          const Divider(color: Colors.red),
          !editMode
              ? FutureBuilder(
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
                          onTap: () => widget.changeSong(
                              track.trackId,
                              track.trackName,
                              track.artistName,
                              track.isAdded,
                              track.path),
                        );
                      },
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

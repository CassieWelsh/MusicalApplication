import 'package:flutter/material.dart';
import 'package:musical_application/utils/content_types.dart';

import '../../data_provider.dart';
import '../../models/dto/trackartist.dart';

class SavedPage extends StatefulWidget {
  final ContentTypes pageType;

  SavedPage({super.key, required this.pageType});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final _dataProvider = DataProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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

        if (snapshot.data!.isEmpty){
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';
import 'package:musical_application/models/dto/trackartist.dart';

class HomePage extends StatelessWidget {
  final _dataProvider = DataProvider();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataProvider.getMainPageTracks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.red));
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()),);
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
            );
          },
        );
      },
    );
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //       future: tracks.get(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting){
    //           return const Text('Loading');
    //         }
    //         if (snapshot.connectionState == ConnectionState.done) {
    //           var a = snapshot.data!.docs.toList();
    //           return ListView.builder(
    //               itemCount: a.length,
    //               scrollDirection: Axis.vertical,
    //               shrinkWrap: true,
    //               itemBuilder: (context, ind) {
    //                 var item = a[ind];
    //                 return ListTile(
    //                   title: Text(item.id),
    //                   subtitle: Text(item.data().toString()),
    //                 );
    //               });
    //         }
    //
    //         return Text("loading");
    //       },
    //     ),
    //   ],
    // );
  }
}

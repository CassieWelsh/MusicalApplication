import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';
import 'package:musical_application/models/dto/trackartist.dart';

class HomePage extends StatefulWidget {
  final void Function(String trackId, String songName, String artistName,
      bool isAdded, String path) changeSong;

  const HomePage({super.key, required this.changeSong});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dataProvider = DataProvider();
  int _currentIndex = 0;
  late Future data;

  _HomePageState() {
    data = _dataProvider.getMainPageTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavigationBar(
          height: 55,
          indicatorColor: Colors.red,
          backgroundColor: Colors.white,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            data = _dataProvider.getMainPageTracks();
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.audiotrack_outlined),
              label: "Tracks",
            ),
            NavigationDestination(
              icon: Icon(Icons.album),
              label: "Albums",
            ),
            NavigationDestination(
              icon: Icon(Icons.playlist_add_check_circle_rounded),
              label: "Playlist",
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              label: "Search",
            ),
          ],
        ),
        FutureBuilder(
          future: data, //_dataProvider.getMainPageTracks(),
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
                    track.path,
                  ),
                );
              },
            );
          },
        ),
      ],
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

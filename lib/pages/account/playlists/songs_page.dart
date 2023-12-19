import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';

import '../../../components/my_button.dart';
import '../../../models/dto/trackartist.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final _dataProvider = DataProvider();
  late final future = _dataProvider.getMainPageTracks();

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
                  onChanged: (a) => {print(a)},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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

              var tracks = snapshot.data as List<TrackArtist>;
              return ListView.builder(
                itemCount: tracks.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, ind) {
                  bool status = false;
                  var track = tracks[ind];
                  return CheckboxListTile(
                    title: Text(track.trackName),
                    subtitle: Text(track.artistName),
                    value: status,

                    onChanged: (bool? value) {
                      setState(() {
                        status = !status;
                      });
                    },
                    //onTap: () => {},
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          MyButton(
            text: "Add selected",
            color: Colors.red,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongsPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

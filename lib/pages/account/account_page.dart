import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';
import 'package:musical_application/pages/account/account_list.dart';
import 'package:musical_application/utils/content_types.dart';

class AccountPage extends StatelessWidget {
  final void Function(String trackId, String songName, String artistName,
      bool isAdded, String path) changeSong;

  AccountPage({super.key, required this.changeSong});

  final _dataProvider = DataProvider();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 25),
        Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.red))),
          child: FutureBuilder(
            future: _dataProvider.getCurrentArtist(),
            builder: (context, snapshot) {
              const style = TextStyle(fontSize: 24);

              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  "Welcome, ${snapshot.data?.name}",
                  style: style,
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...", style: style);
              }

              return const Text("Error while loading user", style: style);
            },
          ),
        ),
        Expanded(
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              color: Colors.grey,
              tiles: [
                ListTile(
                  title: Text("Saved music"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedPage(
                            changeSong: changeSong,
                            pageType: ContentTypes.music),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text("Saved playlists"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedPage(
                            changeSong: changeSong,
                            pageType: ContentTypes.playlist),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text("Saved albums"),
                  onTap: () {},
                ),
              ],
            ).toList(),
          ),
        ),
      ],
    );
  }
}

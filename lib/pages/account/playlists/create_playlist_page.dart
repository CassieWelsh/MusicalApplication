import 'package:flutter/material.dart';
import 'package:musical_application/pages/account/playlists/songs_page.dart';

import '../../../components/my_button.dart';
import '../../../components/my_textfield.dart';

class CreatePlaylistPage extends StatefulWidget {
  String message = "Create playlist";

  CreatePlaylistPage({super.key});

  @override
  State<CreatePlaylistPage> createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create playlist"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: _nameController,
            hintText: 'Name',
            obscureText: false,
          ),
          const SizedBox(height: 25),
          MyButton(
            text: "Add tracks",
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongsPage(),
                )
              );
            },
          ),
          const SizedBox(height: 10),
          MyButton(
            text: "Create",
            color: Colors.red,
            onTap: () {},
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

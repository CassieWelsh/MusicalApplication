// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:musical_application/data_provider.dart';

import '../../../components/my_button.dart';
import '../../../components/my_textfield.dart';

class CreatePlaylistPage extends StatefulWidget {
  String message = "Create playlist";
  final _dataProvider = DataProvider();

  CreatePlaylistPage({super.key});

  @override
  State<CreatePlaylistPage> createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isPublic = false;

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
          const SizedBox(height: 10),
          MyTextField(
            controller: _descriptionController,
            hintText: 'Description',
            obscureText: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Make public",
                style: TextStyle(fontSize: 18),
              ),
              Checkbox(
                value: isPublic,
                onChanged: (value) => setState(
                  () {
                    isPublic = value!;
                  },
                ),
              ),
            ],
          ),
          MyButton(
            text: "Create",
            color: Colors.red,
            onTap: () async {
              if (_nameController.text.isEmpty) {
                setState(() {
                  widget.message = "Provide the name please";
                });
                return;
              }

              await widget._dataProvider.CreatePlaylist(
                  _nameController.text, _descriptionController.text, isPublic);
              Navigator.of(context).popUntil((p) => p.isFirst);
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

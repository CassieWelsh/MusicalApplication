// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:musical_application/repositories/track_repository.dart';

import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../../models/track.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? path;
  PlatformFile? file;
  String message = "Upload a track";
  bool isPublic = false;

  final _trackRepository = TrackRepository();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Account"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: _nameController,
            hintText: 'Track name',
            obscureText: false,
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Make public",
                style: TextStyle(fontSize: 18),
              ),
              Checkbox(
                value: isPublic,
                onChanged: (value) => setState(() {
                  isPublic = value!;
                }),
              ),
              MyButton(
                text: "${file?.name.substring(0, 18) ?? "Choose"}..",
                color: Colors.red,
                onTap: () async {
                  final files = await FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: const ['mp3']);
                  setState(() {
                    final newFile = files?.files.first;
                    if (newFile != null) {
                      if (!newFile.path!.endsWith(".mp3")){
                        message = "Choose a file with .mp3 extension";
                        file = null;
                        return;
                      }
                      file = newFile;
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          file != null
              ? MyButton(
                  text: "Upload",
                  color: Colors.redAccent,
                  onTap: () async {
                    final auth = FirebaseAuth.instance.currentUser;
                    final track = Track(
                        name: _nameController.text,
                        artistId: auth!.uid,
                        genre: 0,
                        songPath: "",
                        isPublished: isPublic
                    );
                    setState(() {
                      message = "Uploading";
                    });
                    await _trackRepository.uploadTrack(track, file!);
                    setState(() {
                      message = "Successful";
                    });
                    Navigator.pop(context);
                  },
                )
              : const SizedBox(
                  height: 0,
                ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

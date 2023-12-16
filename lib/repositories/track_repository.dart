import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:musical_application/utils/collection_names.dart';

import '../models/track.dart';

class TrackRepository {
  final _tracksColl =
      FirebaseFirestore.instance.collection(CollectionNames.tracks);
  final _artistsColl =
      FirebaseFirestore.instance.collection(CollectionNames.tracks);
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<List<Track>> getTracks() async {
    final snapshot =
        await _tracksColl.where("isPublished", isEqualTo: true).limit(25).get();

    return snapshot.docs.map((e) => Track.fromSnapshot(e)).toList();
  }

  Future uploadTrack(Track track, PlatformFile file) async {
    final fileUploader = FirebaseStorage.instance.ref().child(file.name);
    await fileUploader.putFile(
        File(file.path!), SettableMetadata(contentType: "audio/mpeg"));
    await _tracksColl.add(track.toFirestore());
  }
}

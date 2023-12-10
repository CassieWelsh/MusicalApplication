import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musical_application/utils/collection_names.dart';

import '../models/track.dart';

class TrackRepository {
  final _tracksColl = FirebaseFirestore.instance.collection(CollectionNames.tracks);
  final _artistsColl = FirebaseFirestore.instance.collection(CollectionNames.tracks);
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<List<Track>> getTracks() async {
    final snapshot = await _tracksColl.where("isPublished", isEqualTo: true)
                                      .limit(25)
                                      .get();

    return snapshot.docs.map((e) => Track.fromSnapshot(e)).toList();
  }
}

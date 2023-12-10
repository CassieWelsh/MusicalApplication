import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/artist.dart';
import '../utils/collection_names.dart';

class ArtistRepository {
  final _artistsColl = FirebaseFirestore.instance.collection(CollectionNames.artists);
  final auth = FirebaseAuth.instance;

  Future<List<Artist>> getArtists() async {
    final snapshot = await _artistsColl.get();
    return snapshot.docs.map((e) => Artist.fromSnapshot(e)).toList();
  }

  Future<Artist?> getCurrentArtist() async {
    final user = auth.currentUser;
    if (user != null) {
      final snapshot = await _artistsColl.where("userId", isEqualTo: user.uid).get();
      return Artist.fromSnapshot(snapshot.docs.first);
    }

    return null;
  }

  Future<Map<String, Artist>> getArtistsByUserIds(Iterable<String> userIds) async {
    final snapshot = await _artistsColl.where("userId", whereIn: userIds).get();
    return Map<String, Artist>.fromIterable(
        snapshot.docs.map<Artist>((e) => Artist.fromSnapshot(e)),
        key: (a) => a.userId,
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Track {
  final String? id;
  final String artistId;
  final String name;
  final int genre;
  final String songPath;
  final bool isPublished;

  Track({
    this.id,
    required this.artistId,
    required this.name,
    required this.genre,
    required this.songPath,
    required this.isPublished,
  });

  factory Track.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      throw Exception();
    }

    return Track(
      id: document.id,
      artistId: data["artistId"],
      name: data["name"],
      genre: data["genre"],
      songPath: data["songPath"],
      isPublished: data["isPublished"],
    );
  }
}

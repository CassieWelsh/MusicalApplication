import 'package:cloud_firestore/cloud_firestore.dart';

class Playlist {
    final String? id;
    final String artistId;
    final String name;
    final String description;
    final bool isPublic;
    final bool isAlbum;

    Playlist({
      this.id,
      required this.artistId,
      required this.name,
      required this.description,
      required this.isPublic,
      required this.isAlbum
    });

    factory Playlist.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
      final data = document.data();
      if (data == null) {
        throw Exception();
      }

      return Playlist(
        id: document.id,
        artistId: data["artistId"],
        name: data["name"],
        description: data["description"],
        isPublic: data["isPublic"],
        isAlbum: data["isAlbum"],
      );
    }

    Map<String, dynamic> toFirestore() {
      return {
        "artistId": artistId,
        "name": name,
        "description": description,
        "isAlbum": isAlbum,
        "isPublic": isPublic,
      };
    }
}
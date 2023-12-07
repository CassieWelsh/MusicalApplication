import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  final String userId;
  final String name;
  final String? bio;

  Artist({ required this.userId, required this.name, this.bio });

  factory Artist.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      throw Exception();
    }

    return Artist(
        userId: data["userId"],
        name: data["name"],
        bio: data["bio"]
    );
  }
}

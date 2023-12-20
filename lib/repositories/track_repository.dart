import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:musical_application/utils/collection_names.dart';

import '../models/playlist.dart';
import '../models/track.dart';

class TrackRepository {
  final _artistTracksColl =
      FirebaseFirestore.instance.collection(CollectionNames.artistTracks);
  final _tracksColl =
      FirebaseFirestore.instance.collection(CollectionNames.tracks);

  final _playlistsColl =
      FirebaseFirestore.instance.collection(CollectionNames.playlists);
  final _playlistTracksColl =
      FirebaseFirestore.instance.collection(CollectionNames.playlistTracks);
  final _artistPlaylistsColl =
      FirebaseFirestore.instance.collection(CollectionNames.artistPlaylists);

  final _artistsColl =
      FirebaseFirestore.instance.collection(CollectionNames.tracks);
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future addPlaylist(String name, String description, bool isPublic) async {
    final playlist = Playlist(
        artistId: userId!,
        name: name,
        description: description,
        isPublic: isPublic,
        isAlbum: false);

    final playlistDoc = await _playlistsColl.add(playlist.toFirestore());
    await _artistPlaylistsColl.add(
        {"playlistId": playlistDoc.id, "artistId": userId, "playlistType": 0});
  }

  Future<List<Playlist>> getSavedPlaylists() async {
    final playlists =
        await _artistPlaylistsColl.where("artistId", isEqualTo: userId).get();

    final artistPlaylists = await _playlistsColl
        .where(FieldPath.documentId,
            whereIn: playlists.docs.map((p) => p["playlistId"]).toList())
        .get();

    return artistPlaylists.docs.map((e) => Playlist.fromSnapshot(e)).toList();
  }

  Future<List<Track>> getPlaylistTracks(String playlistId) async {
    final trackIds = await _playlistTracksColl
        .where("playlistId", isEqualTo: playlistId)
        .get();

    if (trackIds.size <= 0) {
      return <Track>[];
    }

    final tracks = await _tracksColl
        .where(FieldPath.documentId,
            whereIn: trackIds.docs.map((t) => t["trackId"]).toList())
        .get();

    return tracks.docs.map((t) => Track.fromSnapshot(t)).toList();
  }

  Future<List<Track>> getTracks() async {
    final snapshot =
        await _tracksColl.where("isPublished", isEqualTo: true).limit(25).get();

    return snapshot.docs.isNotEmpty
        ? snapshot.docs.map((e) => Track.fromSnapshot(e)).toList()
        : <Track>[];
  }

  Future uploadTrack(Track track, PlatformFile file) async {
    final id = DateTime.now().toString();
    final fileUploader = FirebaseStorage.instance.ref().child(id);
    track.songPath = id;
    await fileUploader.putFile(
        File(file.path!), SettableMetadata(contentType: "audio/mpeg"));
    await _tracksColl.add(track.toFirestore());
  }

  Future<List<Track>> getSavedTracks() async {
    final snapshot = await _artistTracksColl
        .where("artistId", isEqualTo: userId)
        //.orderBy("addDate", descending: true)
        .limit(25)
        .get();

    final trackIds = snapshot.docs.map((t) => t["trackId"]).toList();
    if (trackIds.isEmpty) {
      return const [];
    }

    final tracks = await _tracksColl
        .where(FieldPath.documentId, whereIn: trackIds)
        .limit(25)
        .get();
    final result = tracks.docs.map((e) => Track.fromSnapshot(e)).toList();

    return result;
  }

  Future removeSaved(String trackId) async {
    final artistTrack = (await _artistTracksColl
        .where("trackId", isEqualTo: trackId)
        .where("artistId", isEqualTo: userId)
        .get());
    if (artistTrack.size > 0) {
      await _artistTracksColl.doc(artistTrack.docs.first.id).delete();
    }
  }

  Future addSaved(String trackId) async {
    final artistTrack = (await _artistTracksColl
        .where("trackId", isEqualTo: trackId)
        .where("artistId", isEqualTo: userId)
        .get());
    if (artistTrack.size <= 0) {
      await _artistTracksColl.add(
          {"trackId": trackId, "artistId": userId, "addDate": DateTime.now()});
    }
  }

  Future updatePlaylistTracks(
      String playlistId, Iterable<String> values) async {
    final tracks = await _playlistTracksColl
        .where("playlistId", isEqualTo: playlistId)
        .get();
    for (DocumentSnapshot doc in tracks.docs) {
      await doc.reference.delete();
    }

    for (final v in values) {
      await _playlistTracksColl.add({"playlistId": playlistId, "trackId": v});
    }
  }

  Future<List<Playlist>> getPlaylists() async {
    return (await _playlistsColl.get())
        .docs
        .map((p) => Playlist.fromSnapshot(p))
        .toList();
  }

  Future updatePlaylist(
      String playlistId, String name, String description, bool isPublic) async {
    final firebasePlaylist = (await _playlistsColl
            .where(FieldPath.documentId, isEqualTo: playlistId)
            .get())
        .docs
        .firstOrNull;

    if (firebasePlaylist != null) {
      final playlist = Playlist.fromSnapshot(firebasePlaylist);
      playlist.name = name;
      playlist.description = description;
      playlist.isPublic = isPublic;
      await _playlistsColl
          .doc(playlistId)
          .set(playlist.toFirestore(), SetOptions(merge: true));
    }
  }

  Future removePlaylist(String playlistId) async {
    final playlist = await _playlistsColl.doc(playlistId).delete();

    final trackSaves = (await _playlistTracksColl
            .where("playlistId", isEqualTo: playlistId)
            .get())
        .docs;

    for (var ts in trackSaves) {
      await ts.reference.delete();
    }

    final userSaves = (await _artistPlaylistsColl
            .where("playlistId", isEqualTo: playlistId)
            .get())
        .docs;
    for (var us in userSaves) {
      await us.reference.delete();
    }
  }
}

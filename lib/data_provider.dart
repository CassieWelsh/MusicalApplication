import 'package:musical_application/models/dto/trackartist.dart';
import 'package:musical_application/repositories/artist_repository.dart';
import 'package:musical_application/repositories/track_repository.dart';

import 'models/artist.dart';
import 'models/playlist.dart';

class DataProvider {
  final _trackRepository = TrackRepository();
  final _artistRepository = ArtistRepository();

  Future<List<TrackArtist>> getMainPageTracks() async {
    final tracks = await _trackRepository.getTracks();
    final artists = await _artistRepository
        .getArtistsByUserIds(tracks.map((e) => e.artistId));

    return tracks
        .map((t) => TrackArtist(
            trackId: t.id!,
            trackName: t.name,
            artistName: artists[t.artistId]?.name ?? 'Unknown',
            path: t.songPath,
            isAdded: false))
        .toList();
  }

  Future<Artist?> getCurrentArtist() {
    return _artistRepository.getCurrentArtist();
  }

  Future<List<Playlist>> getUserPlaylists() {
    return _trackRepository.getSavedPlaylists();
  }

  Future<List<TrackArtist>> getPlaylistTracks(String playlistId) async {
    final tracks = await _trackRepository.getPlaylistTracks(playlistId);

    final artists = await _artistRepository
        .getArtistsByUserIds(tracks.map((e) => e.artistId));

    return tracks
        .map((t) => TrackArtist(
            trackId: t.id!,
            trackName: t.name,
            artistName: artists[t.artistId]?.name ?? 'Unknown',
            path: t.songPath,
            isAdded: true))
        .toList();
  }

  Future<List<TrackArtist>> getAccountTracks() async {
    final tracks = await _trackRepository.getSavedTracks();
    final artists = await _artistRepository
        .getArtistsByUserIds(tracks.map((e) => e.artistId));

    return tracks
        .map((t) => TrackArtist(
            trackId: t.id!,
            trackName: t.name,
            artistName: artists[t.artistId]?.name ?? 'Unknown',
            path: t.songPath,
            isAdded: true))
        .toList();
  }

  Future addOrRemoveSong(String trackId, bool isAdded) async {
    if (isAdded) {
      await _trackRepository.removeSaved(trackId);
      return;
    }
    await _trackRepository.addSaved(trackId);
  }

  Future CreatePlaylist(String name, String description, bool isPublic) async {
    return _trackRepository.addPlaylist(name, description, isPublic);
  }

  Future<List<TrackArtist>> getMainPageTracksBySearch(String search) async {
    final tracks = (await _trackRepository.getTracks())
        .where((t) => t.name.toLowerCase().contains(search.toLowerCase()));
    final artists = await _artistRepository
        .getArtistsByUserIds(tracks.map((e) => e.artistId));

    return tracks
        .map((t) => TrackArtist(
            trackId: t.id!,
            trackName: t.name,
            artistName: artists[t.artistId]?.name ?? 'Unknown',
            path: t.songPath,
            isAdded: false))
        .toList();
  }

  Future updatePlaylist(String playlistId, Map<String, bool> values) {
    values.removeWhere((key, value) => !value);
    return _trackRepository.updatePlaylist(playlistId, values.keys);
  }
}

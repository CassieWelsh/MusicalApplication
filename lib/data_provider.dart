import 'package:musical_application/models/dto/trackartist.dart';
import 'package:musical_application/models/track.dart';
import 'package:musical_application/repositories/artist_repository.dart';
import 'package:musical_application/repositories/track_repository.dart';

import 'models/artist.dart';

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

  Future<List<Track>> getAccountTracks() {
    return _trackRepository.getSavedTracks();
  }

  Future addOrRemoveSong(String trackId, bool isAdded) async {
    if (isAdded){
      await _trackRepository.removeSaved(trackId);
      return;
    }
    await _trackRepository.addSaved(trackId );
  }
}

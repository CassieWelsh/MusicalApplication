import 'package:musical_application/models/dto/trackartist.dart';
import 'package:musical_application/repositories/artist_repository.dart';
import 'package:musical_application/repositories/track_repository.dart';

class DataProvider {
  final _trackRepository = TrackRepository();
  final _artistRepository = ArtistRepository();

  Future<List<TrackArtist>> getMainPageTracks() async {
    final tracks = await _trackRepository.getTracks();
    final artists = await _artistRepository
        .getArtistsByUserIds(tracks.map((e) => e.artistId));

    return tracks.map((t) => TrackArtist(
        trackName: t.name,
        artistName: artists[t.artistId]?.name ?? 'Unknown',
        path: t.songPath)
    ).toList();
  }
}

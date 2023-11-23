class Track {
  int trackId;
  String userId;
  GenreTypes genre;
  String name;
  String? artist;
  String songPath;

  Track(this.trackId, this.userId, this.genre, this.name, this.artist,
      this.songPath);
}

enum GenreTypes { metal }

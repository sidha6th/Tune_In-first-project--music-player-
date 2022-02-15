import 'package:hive_flutter/hive_flutter.dart';
part 'db_model.g.dart';

@HiveType(typeId: 0)
class AllSongs {
  @HiveField(0)
  int? key;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? albums;
  @HiveField(3)
  final int? duration;
  @HiveField(4)
  final int? image;
  @HiveField(5)
  final String? songdata;
  @HiveField(6)
  final bool? ispinned;

  AllSongs({
    this.key,
    this.name,
    this.albums,
    this.duration,
    this.image,
    this.songdata,
    this.ispinned,
  });
}

@HiveType(typeId: 1)
class OnlyModelplaylist {
  @HiveField(0)
  final String? playlistName;
  @HiveField(1)
  int? playlistKey;
  OnlyModelplaylist({
    this.playlistKey,
    this.playlistName,
  });
}

@HiveType(typeId: 2)
class ModelPlaylistsongs {
  @HiveField(0)
  int? playlistKey;
  @HiveField(1)
  final String? songname;
  @HiveField(2)
  late final int? songkey;
  @HiveField(3)
  final int? duration;
  @HiveField(4)
  final int? image;
  @HiveField(5)
  final String? songdata;
  @HiveField(6)
  int? currespondingSongDeletingkey;
  ModelPlaylistsongs({
    this.playlistKey,
    this.songname,
    this.songkey,
    this.image,
    this.duration,
    this.songdata,
    this.currespondingSongDeletingkey,
  });
}

class ModelAlbum {
  final int? image;
  final String? albumname;
  final int? key;
  ModelAlbum({
    this.albumname,
    this.key,
    this.image,
  });
}

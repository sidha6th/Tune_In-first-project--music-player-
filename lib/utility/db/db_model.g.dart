// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllSongsAdapter extends TypeAdapter<AllSongs> {
  @override
  final int typeId = 0;

  @override
  AllSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllSongs(
      key: fields[0] as int?,
      name: fields[1] as String?,
      albums: fields[2] as String?,
      duration: fields[3] as int?,
      image: fields[4] as int?,
      songdata: fields[5] as String?,
      ispinned: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AllSongs obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.albums)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.songdata)
      ..writeByte(6)
      ..write(obj.ispinned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OnlyModelplaylistAdapter extends TypeAdapter<OnlyModelplaylist> {
  @override
  final int typeId = 1;

  @override
  OnlyModelplaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnlyModelplaylist(
      playlistKey: fields[1] as int?,
      playlistName: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OnlyModelplaylist obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistName)
      ..writeByte(1)
      ..write(obj.playlistKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnlyModelplaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModelPlaylistsongsAdapter extends TypeAdapter<ModelPlaylistsongs> {
  @override
  final int typeId = 2;

  @override
  ModelPlaylistsongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelPlaylistsongs(
      playlistKey: fields[0] as int?,
      songname: fields[1] as String?,
      songkey: fields[2] as int?,
      image: fields[4] as int?,
      duration: fields[3] as int?,
      songdata: fields[5] as String?,
      currespondingSongDeletingkey: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelPlaylistsongs obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.playlistKey)
      ..writeByte(1)
      ..write(obj.songname)
      ..writeByte(2)
      ..write(obj.songkey)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.songdata)
      ..writeByte(6)
      ..write(obj.currespondingSongDeletingkey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelPlaylistsongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}


import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/pages/detailes_pages/user_playlist_songlist_page.dart';

List<SongModel> queriedsong = [];
final OnAudioQuery _audioQuery = OnAudioQuery();

//============box==============//
Future<Box<AllSongs>> allSongsBox() async {
  final allSongBox = await Hive.openBox<AllSongs>('songbox');
  return allSongBox;
}

Future<Box<OnlyModelplaylist>> onlymodelplaylistBox() async {
  final onlymodelplaylistBox =
      await Hive.openBox<OnlyModelplaylist>('playlistbox');
  return onlymodelplaylistBox;
}

Future<Box<ModelPlaylistsongs>> playlistsongsBox() async {
  final playlistsongsBox =
      await Hive.openBox<ModelPlaylistsongs>('playlistSongbox');
  return playlistsongsBox;
}
//============ box ==============//

//=========================song fetch section========================//

fetchSong({required bool accepted}) async {
  if (await _audioQuery.permissionsStatus() != true) {
    await _audioQuery.permissionsRequest();
  }
  queriedsong = await _audioQuery.querySongs();
  final allSongBox = await allSongsBox();
  allSongsNotifier.value.clear();
  if (allSongBox.values.isEmpty) {
    for (var songs in queriedsong) {
      AllSongs allsongdata = AllSongs(
          name: songs.title,
          albums: songs.album,
          duration: songs.duration,
          songdata: songs.data,
          image: songs.id);
      int _key = await allSongBox.add(allsongdata);
      allsongdata.key = _key;
      await allSongBox.put(allsongdata.key, allsongdata);
      allSongsNotifier.value.add(allsongdata);
      allSongsNotifier.notifyListeners();
    }
  } else {
    List<AllSongs> list = [];
    list.addAll(allSongBox.values);
    for (var i = 0; i < queriedsong.length; i++) {
      for (var j = 0; j < list.length; j++) {
        if (queriedsong[i].title != list[i].name) {
          AllSongs songdata = AllSongs(
            name: queriedsong[i].title,
            songdata: queriedsong[i].data,
            duration: queriedsong[i].duration,
            albums: queriedsong[i].album,
            image: queriedsong[i].id,
          );
          int _key = await allSongBox.add(songdata);
          songdata.key = _key;
          await allSongBox.put(songdata.key, songdata);
        } else {
          break;
        }
      }
    }
    list.clear();
    allSongsNotifier.value.clear();
    allSongsNotifier.value.addAll(allSongBox.values);
    allSongsNotifier.notifyListeners();
  }
  albumSongNotifier.value.clear();
  for (var songs in allSongsNotifier.value) {
    ModelAlbum albumdata =
        ModelAlbum(albumname: songs.albums, key: songs.key, image: songs.image);
    albumSongNotifier.value.add(albumdata);
  }
  albumSongNotifier.notifyListeners();
}
//========================= end of song fetch section=========================//

//=============================================data functions=====================================================//

//==============================album data function===========================//
listtoalbums() {
  albumSongNotifier.value.clear();
  for (var songs in allSongsNotifier.value) {
    ModelAlbum albumdata =
        ModelAlbum(albumname: songs.albums, key: songs.key, image: songs.image);
    albumSongNotifier.value.add(albumdata);
  }
  albumSongNotifier.notifyListeners();
}
//==========================end of album data function=========================//

//===============================playlist data functions=========================//

getRemainingPlaylist(int key) async {
  Box<OnlyModelplaylist> allplaylist = await onlymodelplaylistBox();
  List<int> unUsedPlaylistKeys = [];
  List<int> allPlaylistkeys = [];
  List<int> usedplaylistkeys = [];
  allPlaylistkeys.clear();
  usedplaylistkeys.clear();
  unUsedPlaylistKeys.clear();
  remainingPlaylists.clear();
  if (playlistNotifier.value.isEmpty) {
  } else if (playlistSongsNotifier.value.isEmpty) {
    remainingPlaylists.addAll(playlistNotifier.value);
  } else {
    for (var item in playlistSongsNotifier.value) {
      if (key == item.songkey) {
        usedplaylistkeys.add(item.playlistKey!);
      }
    }
    for (var item in playlistNotifier.value) {
      allPlaylistkeys.add(item.playlistKey!);
    }
    unUsedPlaylistKeys = allPlaylistkeys
        .where((item) => !usedplaylistkeys.contains(item))
        .toList();
    if(unUsedPlaylistKeys.isNotEmpty){for (var item in unUsedPlaylistKeys) {
      OnlyModelplaylist? playlist = allplaylist.get(item);
      remainingPlaylists.add(playlist!);
    }}
  }
  playlistNotifier.notifyListeners();
}

//its only for playlist tile details
getplaylist() async {
  playlistNotifier.value.clear();
  final playlistbox = await onlymodelplaylistBox();
  playlistNotifier.value.addAll(playlistbox.values);
  playlistNotifier.notifyListeners();
}

addplaylist(
    {required String playlistname, bool? fromlibrary, AllSongs? songs}) async {
  final playlistbox = await onlymodelplaylistBox();
  final playlist = OnlyModelplaylist(playlistName: playlistname);
  int _key = await playlistbox.add(playlist);
  playlist.playlistKey = _key;
  await playlistbox.put(playlist.playlistKey, playlist);
  playlistNotifier.value.add(playlist);
  playlistNotifier.notifyListeners();
  if (fromlibrary == true) {
    await addSongToUserPlaylist(playlist.playlistKey!, songs!);
  }
}

deleteplaylist(int? playlistkey) async {
  final playlistbox = await onlymodelplaylistBox();
  final playlistSongsbox = await playlistsongsBox();
  ModelPlaylistsongs key = ModelPlaylistsongs();
  for (var i = 0; i < playlistSongsNotifier.value.length; i++) {
    if (playlistSongsNotifier.value[i].playlistKey == playlistkey) {
      key.currespondingSongDeletingkey =
          playlistSongsNotifier.value[i].currespondingSongDeletingkey;
      await playlistSongsbox.delete(key.currespondingSongDeletingkey);
    }
  }
  await playlistbox.delete(playlistkey);
  await getplaylist();
  await getUserPlaylistSongs();
}

//=============================end of playlist data functions========================//

//=============================user playlist song functions==========================//
//its for playlist songs details
addSongToUserPlaylist(int currespondingPlaylistKey, AllSongs songdata) async {
  Box<ModelPlaylistsongs> userplaylist = await playlistsongsBox();
  ModelPlaylistsongs userplaylistsongs = ModelPlaylistsongs(
    playlistKey: currespondingPlaylistKey,
    duration: songdata.duration,
    image: songdata.image,
    songdata: songdata.songdata,
    songkey: songdata.key,
    songname: songdata.name,
  );
  int _key = await userplaylist.add(userplaylistsongs);
  userplaylistsongs.currespondingSongDeletingkey = _key;
  await userplaylist.put(
      userplaylistsongs.currespondingSongDeletingkey, userplaylistsongs);
  await getUserPlaylistSongs();
}

getUserPlaylistSongs() async {
  playlistSongsNotifier.value.clear();
  Box<ModelPlaylistsongs> userplaylist = await playlistsongsBox();
  playlistSongsNotifier.value.addAll(userplaylist.values);
  playlistSongsNotifier.notifyListeners();
}

removeSongFromUserPlaylist(int? key) async {
  //debugPrint(key.toString());
  Box<ModelPlaylistsongs> userplaylist = await playlistsongsBox();
  await userplaylist.delete(key);
  await getUserPlaylistSongs();
}

getCurrespondingPlaylistSongs(int playlistKey) {
  currespondingPlaylistSongPath.clear();
  currespondingPlaylistsong.clear();
  playlistSongsList.clear();
  for (var item in playlistSongsNotifier.value) {
    if (item.playlistKey == playlistKey) {
      final userplaylistdata = ModelPlaylistsongs(
        songname: item.songname,
        duration: item.duration,
        image: item.image,
        songdata: item.songdata,
        songkey: item.songkey,
        currespondingSongDeletingkey: item.currespondingSongDeletingkey,
      );
      currespondingPlaylistsong.add(userplaylistdata);
    }
  }
}

//!!!!!its for get the  remainig songs to add into user creating playlist!!!!!//
getRemaingSongsForUserPlaylist() async {
  Box<AllSongs> allSongs = await allSongsBox();
  remainingSongsNotifier.value.clear();
  if (currespondingPlaylistsong.isEmpty) {
    remainingSongsNotifier.value.addAll(allSongsNotifier.value);
  } else if (allSongsNotifier.value.length ==
      currespondingPlaylistsong.length) {
    remainingSongsNotifier.value.clear();
  } else {
    List<int> allkeys = [];
    List<int> currplaylistsongkeys = [];
    allkeys.clear();
    currplaylistsongkeys.clear();
    for (var item in allSongsNotifier.value) {
      allkeys.add(item.key!);
    }
    for (var item in currespondingPlaylistsong) {
      currplaylistsongkeys.add(item.songkey!);
    }
    allkeys =
        allkeys.where((item) => !currplaylistsongkeys.contains(item)).toList();
    for (var i = 0; i < allkeys.length; i++) {
      AllSongs? song = allSongs.get(allkeys[i]);
      remainingSongsNotifier.value.add(song!);
    }
  }
  remainingSongsNotifier.notifyListeners();
}

//============================= end of user playlist song functions=============================//

//==================================pinned song functions===============================//
pinTheSong(List<AllSongs> data, BuildContext context) async {
  Box<AllSongs> allsongbox = await allSongsBox();
  for (var item in data) {
    int? key = item.key;
    final tempdata = AllSongs(
      albums: item.albums,
      duration: item.duration,
      image: item.image,
      ispinned: item.ispinned,
      key: item.key,
      name: item.name,
      songdata: item.songdata,
    );
    await allsongbox.put(key!, tempdata);
  }
  allSongsNotifier.value.clear();
  allSongsNotifier.value.addAll(allsongbox.values);
  allSongsNotifier.notifyListeners();
  var playerControllerInstance =
      Provider.of<PlayerController>(context, listen: false);
  playerControllerInstance.listenEverything();
}

unPinTheSong(int key, AllSongs data) async {
  Box<AllSongs> allsongbox = await allSongsBox();
  final pinnedSong = AllSongs(
      name: data.name,
      ispinned: false,
      albums: data.albums,
      songdata: data.songdata,
      duration: data.duration,
      image: data.image,
      key: key);
  await allsongbox.put(key, pinnedSong);
  allSongsNotifier.value.clear();
  allSongsNotifier.value.addAll(allsongbox.values);
  debugPrint('the song pinned is ' + data.ispinned.toString());
  allSongsNotifier.notifyListeners();
  await getThePinnedSongs();
}

getThePinnedSongs() {
  pinnedSongNotifier.value.clear();
  for (var item in allSongsNotifier.value) {
    if (item.ispinned == true) {
      AllSongs pinnedSong = AllSongs(
          duration: item.duration,
          name: item.name,
          key: item.key,
          image: item.image,
          songdata: item.songdata);
      pinnedSongNotifier.value.add(pinnedSong);
      pinnedSongNotifier.notifyListeners();
    }
  }
 
}

//================================== end of pinned song functions===========================//

//==============================reset the app function=========================//
clearalldata() async {
  SharedPreferences isaccepted = await SharedPreferences.getInstance();
  await isaccepted.setBool('accepted', false);
  final allsongsbox = await allSongsBox();
  await allsongsbox.clear();
  allSongsNotifier.value.clear();
  final playlistbox = await onlymodelplaylistBox();
  await playlistbox.clear();
  playlistNotifier.value.clear();
  final allplaylistsongs = await playlistsongsBox();
  await allplaylistsongs.clear();
  playlistSongsNotifier.value.clear();
  albumSongNotifier.value.clear();
  await assetsAudioPlayer.stop();
  pinnedSongNotifier.value.clear();
  albumSongNotifier.notifyListeners();
  pinnedSongNotifier.notifyListeners();
  playlistSongsNotifier.notifyListeners();
  isplayed.value=false;
}
//=============================end of reset the app function=====================//

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/time_picker.dart';

ValueNotifier<bool> isplayed = ValueNotifier(false);
List<ModelPlaylistsongs> currespondingPlaylistsong = [];

ValueNotifier<bool> isbuttonchanged = ValueNotifier(false);
ValueNotifier<String> sleepTimerIndicator = ValueNotifier('00:00');
String? searchedSong;
List<SongModel> queriedsong = [];
//===============changing modes of play songs with list==============//
List<Audio> allSongsplayList = [];
List<Audio> pinnedPlaylist = [];
List<Audio> albumPlaylist = [];
List<Audio> playlistSongsList = [];
//===============changing modes of play songs with list==============//
ValueNotifier<List<AllSongs>> remainingSongsNotifier = ValueNotifier(
    []); //this notifier for list the remainig songs in the songs adding section//
List<int> alreadyAddedSongkeysInUserPlaylist = [];
ValueNotifier<List<AllSongs>> allSongsNotifier = ValueNotifier([]);
ValueNotifier<List<AllSongs>> pinnedSongNotifier = ValueNotifier([]);
ValueNotifier<List<ModelAlbum>> albumSongNotifier = ValueNotifier([]);
ValueNotifier<List<ModelAlbum>> currespondingAlbumSongNotifier =
    ValueNotifier([]);
ValueNotifier<List<OnlyModelplaylist>> playlistNotifier = ValueNotifier([]);
ValueNotifier<List<ModelPlaylistsongs>> playlistSongsNotifier =
    ValueNotifier([]);
List<OnlyModelplaylist> remainingPlaylists = [];
final assetsAudioPlayer = AssetsAudioPlayer();
int? currentPlaylistKey;
String? currentplayingsongpath;
//its for update ui with currespods to the current songs changes//
ValueNotifier<String> currentSongNameNotifier = ValueNotifier('Unknown');
ValueNotifier<dynamic> currentSongImageNotifier = ValueNotifier(0);
ValueNotifier<bool> isCurrentsongPinned = ValueNotifier(false);
int? currentSongkey;
String? songNameForNotification;
int? songImgForNotification;

//its for update ui with currespods to the current songs changes//
LoopMode loop = LoopMode.playlist;

//==================================provider class starts from here======================================//
class PlayerController extends ChangeNotifier {
  bool isplaying = false;
  String? currentplayingsongname;
  dynamic currentplayingsongimg;
  int? currentsongindex;
  Duration? duration;
  int? selectedSongindex;
  int? selectedSongKey;
  String? currentSongDuration;
  int wheretoPlay = 1;

//================================path initializing function==============================//
  getAllSongsPaths(List<String> songPathList) {
    for (var element in songPathList) {
      final audio = Audio.file(element,
          metas: Metas(
            title: songNameForNotification,
          ));
      allSongsplayList.add(audio);
    }
  }

  getAlbumSongsPaths(List<String> songPathList) {
    for (var element in songPathList) {
      final audio = Audio.file(element,
          metas: Metas(
            title: songNameForNotification,
          ));
      albumPlaylist.add(audio);
    }
  }

  getPinnedSongsPaths(List<String> songPathList) {
    for (var element in songPathList) {
      final audio = Audio.file(element,
          metas: Metas(
            title: songNameForNotification,
          ));
      pinnedPlaylist.add(audio);
    }
  }

  getPlaylistSongsPaths(List<String> songPathList) {
    for (var element in songPathList) {
      final audio = Audio.file(element,
          metas: Metas(
            title: songNameForNotification,
          ));
      playlistSongsList.add(audio);
    }
  }

//================================ end of path initializing function==============================//

//======================== modes of playlist controller ==================//
  whereToPlaysongs() {
    if (wheretoPlay == 1) {
      return allSongsplayList;
    } else if (wheretoPlay == 2) {
      return pinnedPlaylist;
    } else if (wheretoPlay == 3) {
      return playlistSongsList;
    } else if (wheretoPlay == 4) {
      return albumPlaylist;
    }
  }
//======================== end of modes of playlist controller ==================//

//=====================================player initialization==========================//

  playerinit({startingindex = 0, search = false, songPath}) async {
    isplayed.value = true;
    isplayed.notifyListeners();
    change();
    await assetsAudioPlayer.open(
      search == true
          ? Audio.file(songPath, metas: Metas(title: songNameForNotification))
          : Playlist(audios: whereToPlaysongs(), startIndex: startingindex),
      autoStart: true,
      showNotification: true,
      loopMode: loop,
    );
    await listenEverything();
    duration = assetsAudioPlayer.current.value!.audio.duration;
    currentsongindex = assetsAudioPlayer.current.value?.index;
    notifyListeners();
  }

  listenEverything() {
    assetsAudioPlayer.current.listen((event) {
      currentplayingsongpath =
          assetsAudioPlayer.current.value?.audio.audio.path;
      for (var i = 0; i < allSongsNotifier.value.length; i++) {
        if (currentplayingsongpath == allSongsNotifier.value[i].songdata) {
          currentSongImageNotifier.value = allSongsNotifier.value[i].image;
          currentSongImageNotifier.notifyListeners();
          isCurrentsongPinned.value =
              allSongsNotifier.value[i].ispinned ?? false;
          isCurrentsongPinned.notifyListeners();
          currentSongkey = allSongsNotifier.value[i].key;
          currentSongNameNotifier.value =
              allSongsNotifier.value[i].name ?? 'Unknown';
          currentSongNameNotifier.notifyListeners();
        }
      }
    });
  }

  change() {
    assetsAudioPlayer.isPlaying.listen((event) {
      if (assetsAudioPlayer.isPlaying.value == true) {
        isplaying = true;
        isbuttonchanged.value = true;
        isbuttonchanged.notifyListeners();
      } else {
        isplaying = false;
        isbuttonchanged.value = false;
        isbuttonchanged.notifyListeners();
      }
    });
  }

// =================================== Slider section =======================================//
  // ignore: prefer_typing_uninitialized_variables
  Duration currentPosition = const Duration(seconds: 0);
  Duration dur = const Duration(seconds: 0);
  double curr = 0;
  totalDuration() {
    assetsAudioPlayer.current.listen((event) {
      dur = event!.audio.duration;
    });
    return Text(
      dur.toString().split('.')[0],
      style: const TextStyle(color: Colors.white),
    );
  }

  getDuration() {
    return StreamBuilder(
        stream: assetsAudioPlayer.currentPosition,
        builder: (context, AsyncSnapshot<Duration> asyncSnapshot) {
          currentPosition = asyncSnapshot.data ?? const Duration();
          return Text(currentPosition.toString().split('.')[0],
              style: const TextStyle(color: Colors.white));
        });
  }

  current() {
    curr = currentPosition as double;
    notifyListeners();
  }

  void changeToSeconds(int seconds) {
    Duration newDuration = Duration(seconds: seconds);
    assetsAudioPlayer.seek(newDuration);
    notifyListeners();
  }
//=========================== end of slider ==============================//

//=================== song playing controller section =======================//
  playwithindex({index}) async {
    await assetsAudioPlayer.playlistPlayAtIndex(index);
  }

  playsong() async {
    await assetsAudioPlayer.play();
  }

  songpause() async {
    await assetsAudioPlayer.pause();
  }

  songprevious() async {
    await assetsAudioPlayer.previous();
  }

  playnext() async {
    await assetsAudioPlayer.next();
  }
//=================== end of song playing controller section =======================//
}

String? time;
String nulltime = '0';
Widget getTimer(BuildContext context) {
  return CustomTimePicker(
    elevation: 2,
    onPositivePressed: (context, time) {
      var usertime = time.toString().substring(11, 16);
      sleepTimerIndicator.value = usertime;
      sleepTimerIndicator.notifyListeners();
      String hour = usertime.toString().substring(0, 2);
      String minute = usertime.toString().substring(3, 5);
      int min = int.parse(minute);
      int hr = int.parse(hour);
      hr = hr * 3600;
      min = min * 60;
      int totalseconds = hr + min;
      runtime(totalseconds);
  
      Navigator.pop(context);
    },
    onNegativePressed: (context) {
      Navigator.pop(context);
    },
  );
}

runtime(int totalseconds) async {
  await Future.delayed(Duration(seconds: totalseconds), () async {
    await assetsAudioPlayer.stop();
  });
}

//===================================================================================//
//===========pinning songs from the now playing functions===============//
pinSongFromNowplaying(BuildContext context) async {
  Box<AllSongs> allSongBox = await allSongsBox();
  for (var i = 0; i < allSongsNotifier.value.length; i++) {
    if (currentplayingsongpath == allSongsNotifier.value[i].songdata) {
      AllSongs song = AllSongs(
          albums: allSongsNotifier.value[i].albums,
          duration: allSongsNotifier.value[i].duration,
          image: allSongsNotifier.value[i].image,
          ispinned: true,
          key: allSongsNotifier.value[i].key,
          name: allSongsNotifier.value[i].name,
          songdata: allSongsNotifier.value[i].songdata);
      await allSongBox.put(currentSongkey, song);
    }
  }
  allSongsNotifier.value.clear();
  allSongsNotifier.value.addAll(allSongBox.values);
  allSongsNotifier.notifyListeners();
  getThePinnedSongs();
  final playerControllerIntstance =
      Provider.of<PlayerController>(context, listen: false);
  playerControllerIntstance.listenEverything();
}

//===========unpinning songs from the now playing functions===============//
unPinSongFromNowplaying(BuildContext context) async {
  Box<AllSongs> allSongBox = await allSongsBox();
  for (var i = 0; i < allSongsNotifier.value.length; i++) {
    if (currentplayingsongpath == allSongsNotifier.value[i].songdata) {
      AllSongs song = AllSongs(
          albums: allSongsNotifier.value[i].albums,
          duration: allSongsNotifier.value[i].duration,
          image: allSongsNotifier.value[i].image,
          ispinned: false,
          key: allSongsNotifier.value[i].key,
          name: allSongsNotifier.value[i].name,
          songdata: allSongsNotifier.value[i].songdata);
      await allSongBox.put(currentSongkey, song);
    }
  }
  allSongsNotifier.value.clear();
  allSongsNotifier.value.addAll(allSongBox.values);
  allSongsNotifier.notifyListeners();
  await getThePinnedSongs();
  final playerControllerIntstance =
      Provider.of<PlayerController>(context, listen: false);
  playerControllerIntstance.listenEverything();
}
//==================================================================================//
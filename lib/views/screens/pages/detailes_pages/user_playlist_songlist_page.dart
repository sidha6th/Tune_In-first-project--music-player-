import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/pages/nowplaying_page.dart';
import 'package:tune_in/views/screens/pages/songs_adding_pages/user_playlist_song_adding_page.dart';
import 'package:tune_in/views/widgets/common_designs.dart';
import 'package:tune_in/views/widgets/common_list_and_grid_tiles/common_list_tile.dart';
import 'package:tune_in/views/widgets/miniplayer_widget/front_side_miniplyer.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/animating_add_remove_button.dart';

class Userplaylistsong extends StatelessWidget {
  const Userplaylistsong(
      {Key? key,
      required this.title,
      required this.removeOption,
      required this.isplaylist,
      this.playlistkey})
      : super(key: key);
  final String title;
  final bool removeOption;
  final bool isplaylist;
  final int? playlistkey;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(gradient: gradient()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.2),
          title: Text(
            title,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  getRemaingSongsForUserPlaylist();
                  currentIcon = add;
                  currentIndex = -1;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => Addsongpage(
                          playlistkey: playlistkey, title: 'Add song')));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0),
        body: Stack(children: [
          Column(
            children: [
              Consumer<PlayerController>(
                builder: (context, setSongDetails, _) => ValueListenableBuilder(
                    valueListenable: playlistSongsNotifier,
                    builder: (BuildContext context,
                        List<ModelPlaylistsongs> value, _) {
                      getCurrespondingPlaylistSongs(playlistkey!);
                      return currespondingPlaylistsong.isEmpty
                          ? const Center(child: Text('No songs found'))
                          : Expanded(
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Slidable(
                                          endActionPane: ActionPane(
                                              motion: const BehindMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (context) async {
                                                    currespondingPlaylistSongPath
                                                        .clear();
                                                    await removeSongFromUserPlaylist(
                                                        currespondingPlaylistsong[
                                                                index]
                                                            .currespondingSongDeletingkey);
                                                    for (var item
                                                        in currespondingPlaylistsong) {
                                                      currespondingPlaylistSongPath
                                                          .add(item.songdata!);
                                                      final playerControllerInstance =
                                                          Provider.of<
                                                                  PlayerController>(
                                                              context,
                                                              listen: false);
                                                      playerControllerInstance
                                                          .getPlaylistSongsPaths(
                                                              currespondingPlaylistSongPath);
                                                    }
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFFFFFFFF)
                                                          .withOpacity(0.5),
                                                  foregroundColor: Colors.red,
                                                  icon: Icons.delete,
                                                  label: 'Remove',
                                                ),
                                              ]),
                                          child: Tile(
                                              builder: () {
                                                currespondingPlaylistSongPath
                                                    .clear();
                                                for (var item
                                                    in currespondingPlaylistsong) {
                                                  currespondingPlaylistSongPath
                                                      .add(item.songdata!);
                                                }
                                                final playerControllerInstance =
                                                    Provider.of<
                                                            PlayerController>(
                                                        context,
                                                        listen: false);
                                                songImgForNotification =
                                                    currespondingPlaylistsong[
                                                            index]
                                                        .image;
                                                songNameForNotification =
                                                    currespondingPlaylistsong[
                                                            index]
                                                        .songname;
                                                playerControllerInstance
                                                    .getPlaylistSongsPaths(
                                                        currespondingPlaylistSongPath);
                                                setSongDetails.wheretoPlay = 3;
                                                playerControllerInstance
                                                        .currentplayingsongimg =
                                                    currespondingPlaylistsong[
                                                            index]
                                                        .image;
                                                playerControllerInstance
                                                        .currentplayingsongname =
                                                    currespondingPlaylistsong[
                                                            index]
                                                        .songname;
                                                setSongDetails.selectedSongKey =
                                                    currespondingPlaylistsong[
                                                            index]
                                                        .songkey;
                                                setSongDetails
                                                    .selectedSongindex = index;
                                                setSongDetails
                                                        .currentSongDuration =
                                                    currespondingPlaylistsong[
                                                            index]
                                                        .duration
                                                        .toString();
                                                setSongDetails.playerinit(
                                                    startingindex:
                                                        setSongDetails
                                                            .selectedSongindex);
                                              },
                                              songImage:
                                                  currespondingPlaylistsong[
                                                          index]
                                                      .image,
                                              playlist: false,
                                              title: currespondingPlaylistsong[
                                                      index]
                                                  .songname,
                                              index: index)));
                                },
                                itemCount: currespondingPlaylistsong.length,
                              ),
                            );
                    }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              )
            ],
          ),
          Positioned(
              bottom: 0,
              child: ValueListenableBuilder(
                  valueListenable: isplayed,
                  builder: (BuildContext context, bool isplayed, _) {
                    return Visibility(
                      visible: isplayed,
                      replacement: const SizedBox(),
                      child: OpenContainer(
                        transitionType: ContainerTransitionType.fade,
                        transitionDuration: const Duration(milliseconds: 600),
                        closedBuilder: (BuildContext ctx, action) => MiniPlayer(
                          width: width,
                        ),
                        openBuilder: (BuildContext context, action) {
                          return const NowPlaying();
                        },
                      ),
                    );
                  }))
        ]),
      ),
    );
  }
}

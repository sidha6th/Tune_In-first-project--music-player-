import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/pages/nowplaying_page.dart';
import 'package:tune_in/views/screens/pages/songs_adding_pages/song_pinning_page.dart';
import 'package:tune_in/views/screens/pages/songs_adding_pages/user_playlist_song_adding_page.dart';
import 'package:tune_in/views/widgets/common_designs.dart';
import 'package:tune_in/views/widgets/common_list_and_grid_tiles/common_list_tile.dart';
import 'package:tune_in/views/widgets/miniplayer_widget/front_side_miniplyer.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/animating_add_remove_button.dart';


class PinnedList extends StatelessWidget {
  const PinnedList({Key? key, required this.removeOption}) : super(key: key);
  final bool removeOption;
  @override
  Widget build(BuildContext context) {
    List<String> pinnedsongpaths = [];
    final width = MediaQuery.of(context).size.width;
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
          title: const Text('Pinned songs'),
          actions: [
            //=========================================song adding section========================================//
            IconButton(
                onPressed: () {
                  currentIcon = add;
                  currentIndex = -1;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          const PinThesongpage(title: 'Add song')));
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0),
        body: Stack(children: [
          Column(
            children: [
              Consumer<PlayerController>(
                builder: (_, setSongDetails, child) => ValueListenableBuilder(
                    valueListenable: pinnedSongNotifier,
                    builder:
                        (BuildContext context, List<AllSongs> pinnedSongs, _) {
                      pinnedsongpaths.clear();
                      for (var songpath in pinnedSongs) {
                        debugPrint(songpath.songdata);
                        pinnedsongpaths.add(songpath.songdata!);
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            AllSongs pinnedsong = pinnedSongs[index];
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Dismissible(
                                    confirmDismiss: (direction) {
                                      return showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Are You sure want to remove'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text('No',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueGrey))),
                                                TextButton(
                                                  onPressed: () {
                                                    unPinTheSong(
                                                        pinnedsong.key!,
                                                        pinnedsong);
                                                    pinnedSongNotifier
                                                        .notifyListeners();
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: const Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    key: ValueKey(index),
                                    child: Tile(
                                        builder: () {
                                          final playerControllerInstance =
                                              Provider.of<PlayerController>(
                                                  context,
                                                  listen: false);
                                                  songImgForNotification=pinnedsong.image;
                                                  songNameForNotification=pinnedsong.name;
                                          setSongDetails.wheretoPlay = 2;
                                          playerControllerInstance
                                              .getPinnedSongsPaths(
                                                  pinnedsongpaths);
                                          playerControllerInstance
                                                  .currentplayingsongname =
                                              pinnedsong.name;
                                          playerControllerInstance
                                                  .currentplayingsongimg =
                                              pinnedsong.image;
                                          setSongDetails.selectedSongKey =
                                              pinnedsong.key;
                                          setSongDetails.selectedSongindex =
                                              index;
                                          setSongDetails.currentSongDuration =
                                              pinnedsong.duration.toString();
                                          setSongDetails.playerinit(
                                              startingindex: setSongDetails
                                                  .selectedSongindex);
                                        },
                                        songImage: pinnedsong.image,
                                        playlist: false,
                                        title: pinnedsong.name,
                                        index: index)));
                          },
                          itemCount: pinnedSongs.length,
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

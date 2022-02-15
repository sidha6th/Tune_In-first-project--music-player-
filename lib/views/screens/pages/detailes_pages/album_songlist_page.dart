import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/pages/nowplaying_page.dart';
import 'package:tune_in/views/widgets/common_designs.dart';
import 'package:tune_in/views/widgets/common_list_and_grid_tiles/common_list_tile.dart';
import 'package:tune_in/views/widgets/miniplayer_widget/front_side_miniplyer.dart';


List<AllSongs> currespodingAlbumSongs = [];

class AlbumSongs extends StatelessWidget {
  const AlbumSongs({Key? key, this.albumname}) : super(key: key);

  final String? albumname;
  @override
  Widget build(BuildContext context) {
    List<String> albumSongPaths = [];
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
          title: Text(albumname!),
        ),
        backgroundColor: Colors.black.withOpacity(0),
        body: Stack(children: [
          Column(
            children: [
              Consumer<PlayerController>(
                  builder: (BuildContext context, controller, _) {
                return ValueListenableBuilder(
                    valueListenable: allSongsNotifier,
                    builder:
                        (BuildContext context, List<AllSongs> albumSongs, _) {
                      currespodingAlbumSongs.clear();
                      albumSongPaths.clear();
                      albumPlaylist.clear();
                      for (var item in albumSongs) {
                        if (item.albums.toString() == albumname.toString()) {
                          AllSongs songs = AllSongs(
                            duration: item.duration,
                            image: item.image,
                            ispinned: item.ispinned,
                            key: item.key,
                            name: item.name,
                            songdata: item.songdata,
                          );
                          currespodingAlbumSongs.add(songs);
                        }
                      }
                      for (var songpath in currespodingAlbumSongs) {
                        debugPrint(songpath.songdata);
                        albumSongPaths.add(songpath.songdata!);
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Tile(
                                    builder: () {
                                      controller.wheretoPlay = 4;
                                      songImgForNotification =
                                          currespodingAlbumSongs[index].image;
                                      songNameForNotification =
                                          currespodingAlbumSongs[index].name;
                                      controller.currentplayingsongname =
                                          currespodingAlbumSongs[index].name;
                                      controller.currentplayingsongimg =
                                          currespodingAlbumSongs[index].image;
                                      controller
                                          .getAlbumSongsPaths(albumSongPaths);
                                      controller.selectedSongKey =
                                          currespodingAlbumSongs[index].key;
                                      controller.selectedSongindex = index;
                                      controller.currentSongDuration =
                                          currespodingAlbumSongs[index]
                                              .duration
                                              .toString();
                                      controller.playerinit(
                                          startingindex:
                                              controller.selectedSongindex);
                                    },
                                    songImage:
                                        currespodingAlbumSongs[index].image,
                                    playlist: false,
                                    title: currespodingAlbumSongs[index].name,
                                    index: index));
                          },
                          itemCount: currespodingAlbumSongs.length,
                        ),
                      );
                    });
              }),
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

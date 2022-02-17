import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/pages/nowplaying_page.dart';
import 'package:tune_in/views/widgets/common_list_and_grid_tiles/common_list_tile.dart';


TextEditingController playlistcreation = TextEditingController();

class Library extends StatelessWidget {
  const Library({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    List<String> allsongpath = [];
    return Column(
      children: [
         SizedBox(
          height: height*0.01,
        ),
        allSongsNotifier.value.isEmpty
            ? Flexible(
                child: Center(
                    child: Image.asset('assets/images/fetch error.png')))
            : Expanded(
                child: Consumer<PlayerController>(
                  builder: (_, setSongDetails, child) => ValueListenableBuilder(
                      valueListenable: allSongsNotifier,
                      builder: (BuildContext context, List<AllSongs> songs, _) {
                        return ListView.builder(
                            itemCount: songs.length,
                            itemBuilder: (ctx, intex) {
                              var song = songs[intex];
                              //custom list tile
                              return Column(
                                children: [
                                   SizedBox(
                                    height: height*0.01,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width*0.02),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        motion: const BehindMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (ctx) {
                                              getRemainingPlaylist(
                                                  songs[intex].key!);
                                              //=============================================== playlist Adding alert box ===========================================================//
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      title:  Text(
                                                        'add to playlist',
                                                        style: TextStyle(
                                                            fontSize: width*0.05,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      content: SizedBox(
                                                        width: double.maxFinite,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            TextField(
                                                              controller:
                                                                  playlistcreation,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:  Text(
                                                                        'Not Now',
                                                                        style: TextStyle(fontSize: width*0.04,
                                                                            color:
                                                                                Colors.black))),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (playlistcreation
                                                                          .text
                                                                          .trim()
                                                                          .isNotEmpty) {
                                                                        addplaylist(
                                                                            playlistname: playlistcreation
                                                                                .text,
                                                                            fromlibrary:
                                                                                true,
                                                                            songs:
                                                                                song);
                                                                        ScaffoldMessenger.of(ctx).showSnackBar( SnackBar(
                                                                          dismissDirection: DismissDirection.horizontal,
                                                                            backgroundColor:
                                                                                Colors.blueGrey,
                                                                            content: Text('Song Added successfully',style: TextStyle(fontSize: width*0.02),)));
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                      playlistcreation
                                                                          .clear();
                                                                    },
                                                                    child:
                                                                         Text(
                                                                      'Create and Add',
                                                                      style: TextStyle(
                                                                          fontSize: width*0.04,
                                                                          color:
                                                                              Colors.green),
                                                                    )),
                                                              ],
                                                            ),
                                                            remainingPlaylists
                                                                    .isEmpty
                                                                ? const SizedBox()
                                                                : Text(
                                                                    'Playlists',
                                                                    style: TextStyle(
                                                                      fontSize: width*0.04,
                                                                        color: Colors
                                                                            .blueAccent),
                                                                  ),
                                                            Flexible(
                                                              child: ValueListenableBuilder(
                                                                  valueListenable:
                                                                      playlistNotifier,
                                                                  builder: (BuildContext
                                                                          context,
                                                                      List<OnlyModelplaylist>
                                                                          playlist,
                                                                      _) {
                                                                    return ListView
                                                                        .builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount: remainingPlaylists
                                                                                .length,
                                                                            itemBuilder:
                                                                                (BuildContext context, int index) {
                                                                              return ListTile(
                                                                                leading: const Icon(
                                                                                  Icons.playlist_add,
                                                                                  color: Colors.blueGrey,
                                                                                ),
                                                                                onTap: () {
                                                                                  addSongToUserPlaylist(playlist[index].playlistKey!, song);
                                                                                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                                                                                    backgroundColor: Colors.blueGrey,
                                                                                    content: Text('Song Added successfully'),
                                                                                    behavior: SnackBarBehavior.floating,
                                                                                  ));
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                title: Text(remainingPlaylists[index].playlistName!),
                                                                              );
                                                                            });
                                                                  }),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                              //===============================================ends playlist Adding alert box ===========================================================//
                                            },
                                            backgroundColor:
                                                const Color(0xFFFFFFFF)
                                                    .withOpacity(0.5),
                                            foregroundColor: Colors.white,
                                            icon: Icons.add,
                                            label: 'Add',
                                          ),
                                        ],
                                      ),
                                      child: Tile(
                                          builder: () {
                                            for (var paths in songs) {
                                              allsongpath
                                                  .add(paths.songdata ?? '');
                                            }
                                            final playerControllerInstance =
                                                Provider.of<PlayerController>(
                                                    context,
                                                    listen: false);
                                                    
                                            songNameForNotification = song.name;
                                            songImgForNotification = song.image;
                                            playerControllerInstance
                                                .getAllSongsPaths(allsongpath);
                                            setSongDetails.wheretoPlay = 1;
                                            setSongDetails.selectedSongindex =
                                                intex;
                                            isCurrentsongPinned.value =
                                                song.ispinned ?? false;
                                            isCurrentsongPinned
                                                .notifyListeners();
                                            setSongDetails.currentSongDuration =
                                                song.duration.toString();
                                            setSongDetails.playerinit(
                                                startingindex: setSongDetails
                                                    .selectedSongindex);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        NowPlaying(
                                                          songImage: song.image,
                                                          songName: song.name!,
                                                        )));
                                          },
                                          songImage: song.image,
                                          title: song.name!,
                                          index: intex,
                                          playlist: false),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            });
                      }),
                ),
              ),
        ValueListenableBuilder(
            valueListenable: isplayed,
            builder: (BuildContext context, bool isplayed, _) {
              return Visibility(
                replacement: const SizedBox(),
                visible: isplayed,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
              );
            })
      ],
    );
  }
}

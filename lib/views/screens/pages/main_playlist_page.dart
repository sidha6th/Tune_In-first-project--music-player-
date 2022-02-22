import 'package:flutter/material.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/pages/detailes_pages/pinned_songlist_page.dart';
import 'package:tune_in/views/screens/pages/detailes_pages/user_playlist_songlist_page.dart';
import 'package:tune_in/views/widgets/alertbox_widget/dialoge_box.dart';


class Playlist extends StatelessWidget {
  const Playlist({Key? key, List? audios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: height*0.015,
        ),
        //================================================ pinned playlist tile section ================================================//
        ListTile(
          tileColor: Colors.white.withOpacity(0.3),
          onTap: () {
            getThePinnedSongs();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const PinnedList(
                      removeOption: true,
                    )));
          },
          leading: const Icon(
            Icons.push_pin,
            color: Colors.green,
            size: 30,
          ),
          title:  Text(
            'Pinned Songs',
            style: TextStyle(
                fontSize: width*0.054, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: ValueListenableBuilder(
              valueListenable: pinnedSongNotifier,
              builder: (context, List<AllSongs> pinned, _) => pinned.isEmpty
                  ? const SizedBox()
                  : Text(
                      '${pinned.length.toString()} Songs',
                      style: const TextStyle(color: Colors.white),
                    )),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.white.withOpacity(0.5))),
            onPressed: () {
              showdialoge(
                  context: context,
                  title: 'Create playlist',
                  playlist: false,
                  delete: false,
                  other: true);
            },
            child: const Text('Add playlists')),
        //=======================================user playlist section====================================================//
        playlistNotifier.value.isNotEmpty
        ? Row(
          children:const [
             Padding(
              padding:  EdgeInsets.only(top: 10,left: 20,bottom: 10),
              child: Text('Playlists',style: TextStyle(fontSize: 18,color: Colors.white),),
            ),
          ],
        )
        : const SizedBox(),
        Expanded(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ValueListenableBuilder(
            valueListenable: playlistNotifier,
            builder:
                (BuildContext context, List<OnlyModelplaylist> values, _) {
              return GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 20,
                          crossAxisCount: 2,),
                  itemCount: values.length,
                  itemBuilder: (BuildContext context, int index) {
                    OnlyModelplaylist playlist = values[index];
                    return InkWell(
                        onLongPress: () async {
                          return await showDialog(
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
                                                color: Colors.blueGrey))),
                                    TextButton(
                                      onPressed: () {
                                        deleteplaylist(
                                            playlist.playlistKey);
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text(
                                        'Yes',
                                        style:
                                            TextStyle(color: Colors.red),
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        onTap: () {
                          alreadyAddedSongkeysInUserPlaylist.clear();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            getCurrespondingPlaylistSongs(
                                playlist.playlistKey!);
                            return Userplaylistsong(
                              playlistkey: playlist.playlistKey,
                              isplaylist: true,
                              title: playlist.playlistName!,
                              removeOption: true,
                            );
                          }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                              image:const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/playlist.jpg'),
                                  fit: BoxFit.contain)),
                          child: Center(
                              child: Text(
                            playlist.playlistName.toString().length >= 10
                                ? playlist.playlistName!
                                    .toUpperCase()
                                    .substring(0, 10)
                                : playlist.playlistName!.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          )),
                        ));
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

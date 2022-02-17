import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/widgets/common_designs.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/animating_add_remove_button.dart';


List<ModelPlaylistsongs> temp = [];
int currentIndex = -1;

class Addsongpage extends StatelessWidget {
  const Addsongpage({
    Key? key,
    required this.title,
    this.playlistkey,
  }) : super(key: key);
  final int? playlistkey;
  final String title;
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    //var height=MediaQuery.of(context).size.height;
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
            ElevatedButton(
                onPressed: () {
                  currentIcon = add;
                  currentIndex = -1;
                  remainingSongsNotifier.value.clear();
                  getplaylist();
                  Navigator.pop(context);
                },
                child: const Text('save'))
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0),
        body: ValueListenableBuilder(
            valueListenable: remainingSongsNotifier,
            builder: (BuildContext context, List<AllSongs> value, _) {
              return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (BuildContext context, int index) {
                    final remainingSongs = value[index];
                    return ListTile(
                      leading: QueryArtworkWidget(
                        nullArtworkWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const Image(
                              width: 50,
                              image: AssetImage(
                                  'assets/images/DefaultMusicImg.png'),
                            )),
                        id: remainingSongs.image!,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(5),
                      ),
                      
                      title: remainingSongs.name!.length>18?Text(
                    remainingSongs.name!.substring(0,19),
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold),
                  ):Text(
                    remainingSongs.name??'unknown',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                      trailing: AddRemoveBtn(
                        builder1: () {
                          if (currentIndex != index) {
                            // final currentaddingsongs = ModelPlaylistsongs(
                            //     songname: remainingSongs.name,
                            //     duration: remainingSongs.duration,
                            //     image: remainingSongs.image,
                            //     playlistKey: playlistkey,
                            //     songdata: remainingSongs.songdata,
                            //     songkey: remainingSongs.key);
                            addSongToUserPlaylist(playlistkey!, value[index]);
                            currentIndex = index;
                            currentIcon = remove;
                          } else {
                            removeSongFromUserPlaylist(value[index].key!);
                            currentIndex = -1;
                            currentIcon = add;
                          }
                        },
                      ),
                    );
                  });
            }),
      ),
    );
  }
}

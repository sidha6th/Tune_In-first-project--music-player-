import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/pages/songs_adding_pages/user_playlist_song_adding_page.dart';
import 'package:tune_in/views/widgets/common_designs.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/animating_add_remove_button.dart';

List<AllSongs> tempPinning = [];

class PinThesongpage extends StatelessWidget {
  const PinThesongpage({
    Key? key,
    required this.title,
    this.playlistkey,
  }) : super(key: key);
  final int? playlistkey;
  final String title;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
                onPressed: () async {
                  await pinTheSong(tempPinning, context);
                  await getThePinnedSongs();
                  currentIcon = add;
                  currentIndex = -1;
                  Navigator.pop(context);

                  pinnedPlaylist.clear();
                  final playerControllerInstance =
                      Provider.of<PlayerController>(context, listen: false);
                  playerControllerInstance.getPinnedSongsPaths(pinnedsongpaths);
                },
                child: const Text('save'))
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0),
        body: ValueListenableBuilder(
            valueListenable: allSongsNotifier,
            builder: (BuildContext context, List<AllSongs> value, _) {
              List<AllSongs> temp = [];
              temp.clear();
              for (var item in value) {
                if (item.ispinned == false || item.ispinned == null) {
                  final tempdata = AllSongs(
                    albums: item.albums,
                    duration: item.duration,
                    image: item.image,
                    ispinned: item.ispinned,
                    key: item.key,
                    name: item.name,
                    songdata: item.songdata,
                  );
                  temp.add(tempdata);
                }
              }
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: QueryArtworkWidget(
                      nullArtworkWidget: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const Image(
                            width: 50,
                            image:
                                AssetImage('assets/images/DefaultMusicImg.png'),
                          )),
                      id: temp[index].image!,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(5),
                    ),
                    title: temp[index].name!.length > 24
                        ? Text(
                            temp[index].name!.substring(0, 24),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w200),
                          )
                        : Text(
                            temp[index].name ?? 'unknown',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w200),
                          ),
                    trailing: AddRemoveBtn(
                      builder1: () {
                        if (currentIndex != index) {
                          final pinnedSong = AllSongs(
                              name: temp[index].name,
                              ispinned: true,
                              albums: temp[index].albums,
                              duration: temp[index].duration,
                              songdata: temp[index].songdata,
                              image: temp[index].image,
                              key: temp[index].key);
                          tempPinning.add(pinnedSong);
                          currentIcon = remove;
                          currentIndex = index;
                        } else {
                          tempPinning.removeAt(index);
                          currentIndex = -1;
                          currentIcon = add;
                        }
                      },
                    ),
                  );
                },
                itemCount: temp.length,
              );
            }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/db/db_model.dart';


class Searchpage extends StatefulWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchdata = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.blueGrey.shade900.withOpacity(0.2),
        title: TextField(
          onChanged: (String value) {
            allSongsNotifier.notifyListeners();
          },
          controller: searchdata,
          decoration: InputDecoration(
              hintText: 'Songs,Albums',
              focusColor: Colors.blueGrey,
              suffixIcon: IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    searchdata.clear();
                    allSongsNotifier.notifyListeners();
                  },
                  icon: const Icon(
                    Icons.clear_sharp,
                    size: 30,
                    color: Colors.blueGrey,
                  )),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 30,
                color: Colors.blueGrey,
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none))),
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: allSongsNotifier,
          builder: (BuildContext context, List<AllSongs> value, _) {
            return ListView.builder(
                itemCount: value.length,
                itemBuilder: (BuildContext context, int index) {
                  AllSongs songs = value[index];

                  return songs.name
                          .toString()
                          .toLowerCase()
                          .contains(searchdata.text.toLowerCase())
                      ? ListTile(
                          onTap: () {
                            final playerControllerInstance =
                                Provider.of<PlayerController>(context,
                                    listen: false);
                            searchedSong = songs.songdata!;
                            songNameForNotification=songs.name;
                            playerControllerInstance.selectedSongindex = index;
                            playerControllerInstance.currentSongDuration =
                                songs.duration.toString();
                            playerControllerInstance.playerinit(
                                songPath: searchedSong,
                                startingindex:
                                    playerControllerInstance.selectedSongindex,
                                search: true);
                          },
                          title: Text(
                            songs.name!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: QueryArtworkWidget(
                            nullArtworkWidget: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const Image(
                                  width: 50,
                                  image: AssetImage(
                                      'assets/images/DefaultMusicImg.png'),
                                )),
                            id: songs.image!,
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(5),
                          ),
                        )
                      : const SizedBox();
                });
          }),
    );
  }
}

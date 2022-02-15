import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/pages/detailes_pages/album_songlist_page.dart';
import 'package:tune_in/views/widgets/common_list_and_grid_tiles/album_page_grid.dart';

class Albums extends StatelessWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        albumSongNotifier.value.isEmpty
            ? Expanded(child: Image.asset(r'assets/images/fetch error.png'))
            : Expanded(
                child: ValueListenableBuilder(
                    valueListenable: albumSongNotifier,
                    builder: (BuildContext ctx, List<ModelAlbum> albumdata, _) {
                      return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: albumdata.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            final album = albumdata[index];
                            return Center(
                                child: Bounce(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => AlbumSongs(
                                                    albumname:
                                                        album.albumname ??
                                                            'Unknown',
                                                  )));
                                    },
                                    duration: const Duration(milliseconds: 110),
                                    child: Cards(
                                      albumname: album.albumname ?? '',
                                      albumimg: album.image,
                                      index: index,
                                    )));
                          });
                    }),
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

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Tile extends StatelessWidget {
  const Tile(
      {Key? key,
      required this.builder,
      this.title,
      this.songImage,
      required this.index,
      required this.playlist})
      : super(key: key);
  final bool playlist;
  final int? songImage;
  final int index;
  final String? title;
  final Function builder;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
        width: width,
        decoration: BoxDecoration(
            color: Colors.black54.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Bounce(
          duration: const Duration(milliseconds: 50),
          onPressed: () => builder(),
          child: ListTile(
            leading: playlist == true
                ? Image(
                    image: const AssetImage(
                      'assets/images/playlist.jpg',
                    ),
                    height: height * 0.04)
                : QueryArtworkWidget(
                    nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image(
                          width: width * 0.13,
                          image: const AssetImage(
                              'assets/images/DefaultMusicImg.png'),
                        )),
                    id: songImage!,
                    artworkWidth: width * 0.13,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(4),
                  ),
            title: playlist == true
                ? Padding(
                    padding: EdgeInsets.only(left: width * 0.09),
                    child: title!.length>20?Marquee(
                     text:  title ?? 'Unknown',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold),
                    ):Text(title??'unknown',style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold),),
                  )
                : Text(
                    title??'unknown',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ));
  }
}

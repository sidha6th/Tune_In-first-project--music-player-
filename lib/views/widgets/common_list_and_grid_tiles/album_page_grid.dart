import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Cards extends StatelessWidget {
  const Cards(
      {Key? key, required this.index, this.albumimg, required this.albumname})
      : super(key: key);
  final String albumname;
  final int index;
  final dynamic albumimg;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        child: Stack(
          children: [
            QueryArtworkWidget(
              artworkHeight: MediaQuery.of(context).size.height,
              nullArtworkWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: width,
                    image:
                        const AssetImage('assets/images/DefaultMusicImg.png'),
                  )),
                  artworkWidth:width ,
              id: albumimg,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.circular(5),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: width,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.white.withOpacity(0.3)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: albumname.length > 11
                        ? Marquee(
                            text: albumname,
                            style: const TextStyle(color: Colors.white))
                        : Text(
                            albumname,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

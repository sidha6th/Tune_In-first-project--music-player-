import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune_in/controller/provider.dart';

// ignore: must_be_immutable
class CurrentSongImage extends StatelessWidget {
 const CurrentSongImage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: currentSongImageNotifier,
      builder: (context, dynamic value, child) {
        return QueryArtworkWidget(
        artworkHeight: MediaQuery.of(context).size.height * 0.28,
        artworkWidth: MediaQuery.of(context).size.width * 0.54,
        nullArtworkWidget: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              width: MediaQuery.of(context).size.width * 0.5,
              image: const AssetImage('assets/images/DefaultMusicImg.png'),
            )),
        id: value,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.circular(5),
      );
  }
    );
  }
}

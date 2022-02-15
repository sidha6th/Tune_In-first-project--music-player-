import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/views/widgets/common_designs.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/front_side_current_image.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/pause_play_button.dart';



class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key, required this.width}) : super(key: key);
  final double width;

  final String songName = 'song name';
  @override
  Widget build(BuildContext context) {
    final playerControllerInstance =
        Provider.of<PlayerController>(context, listen: false);
    return Container(
      width: width,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        children: [
          const Padding(
            padding:  EdgeInsets.all(5.0),
             child:FrontSideSongImage(),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 const Padding(
                    padding:  EdgeInsets.only(top: 5),
                    child:  Text('Now playing'),
                  ),
              //======================song name should be show here=================//
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: currentSongNameNotifier,
                      builder: (BuildContext context, String title, _) {
                        return Marquee(text: title.isEmpty?'Unknown':title,
                          style:  TextStyle(fontSize: width*0.04),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
          
            SizedBox(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                musicControllerIcon(
                  icon: Icons.skip_previous,
                  builder: () {
                    playerControllerInstance.songprevious();
                  }),
              const Playbutton(),
              musicControllerIcon(
                  icon: Icons.skip_next,
                  builder: () {
                    playerControllerInstance.playnext();
                  })
            ],))
        ],
      ),
    );
  }
}

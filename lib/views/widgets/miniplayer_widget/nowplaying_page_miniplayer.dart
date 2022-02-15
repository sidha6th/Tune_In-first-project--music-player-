import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/pause_play_button.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/player_controller_loop_button.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/player_controller_shuffle.dart';


class NowplayingController extends StatelessWidget {
  const NowplayingController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerControllerInstance =
        Provider.of<PlayerController>(context, listen: false);
    const controllerheight = 50;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: controllerheight.toDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         const LoopIcon(),
          IconButton(
              onPressed: () {
                playerControllerInstance.songprevious();
              },
              icon: const Icon(
                Icons.skip_previous,
                size: 40,
              )),
          const Playbutton(),
          IconButton(
              onPressed: () {
                playerControllerInstance.playnext();
              },
              icon: const Icon(Icons.skip_next, size: 40)),
          const ShuffleIcon()
        ],
      ),
    );
  }
}

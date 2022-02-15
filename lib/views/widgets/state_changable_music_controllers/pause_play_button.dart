import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';


class Playbutton extends StatelessWidget {
  const Playbutton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final playerControllerInstance =
        Provider.of<PlayerController>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: isbuttonchanged,
      builder: (BuildContext context, bool value, _) {
        return value == true
            ? IconButton(
                onPressed: () {
                  playerControllerInstance.songpause();
                },
                icon: const Icon(
                  Icons.pause,
                  size: 35,
                ))
            : IconButton(
                onPressed: () {
                  playerControllerInstance.playsong();
                },
                icon: const Icon(
                  Icons.play_arrow,
                  size: 35,
                ));
      },
    );
  }
}

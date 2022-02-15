import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tune_in/controller/provider.dart';


Icon icon=const Icon(Icons.repeat);
class LoopIcon extends StatefulWidget {
  const LoopIcon({Key? key}) : super(key: key);

  @override
  State<LoopIcon> createState() => _LoopIconState();
}

class _LoopIconState extends State<LoopIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async{
          if(loop==LoopMode.playlist){
            loop=LoopMode.single;
            await assetsAudioPlayer.toggleLoop();
            setState(() {
             icon= const Icon(Icons.repeat_one_rounded,color: Colors.white,);
            });
          }else{
            loop=LoopMode.playlist;
            await assetsAudioPlayer.toggleLoop();
            setState(() {
               icon=const Icon(Icons.repeat);
            });
          }
        },
        icon: icon ,iconSize: 30,);
  }
}

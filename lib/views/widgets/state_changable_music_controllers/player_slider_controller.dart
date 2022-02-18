import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';


// ignore: must_be_immutable
class Sliderclass extends StatefulWidget {
  const Sliderclass({
    Key? key,
  }) : super(key: key);
  @override
  _SliderclassState createState() => _SliderclassState();
}

class _SliderclassState extends State<Sliderclass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerController>(
      builder: (BuildContext context, PlayerController controller, _) =>
       Column(
          children: [
            StreamBuilder(
      stream: assetsAudioPlayer.currentPosition,
      builder: (context,asyncSnapshot)=> Slider(
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        value: controller.currentPosition.inSeconds.toDouble(),
        min: 0.0,
        max: controller.dur.inSeconds.toDouble(),
        onChanged: (double newValue) {
          controller.changeToSeconds(controller.curr.toInt());
          controller.curr = newValue;
          setState(() {
            
          });
        },
      ),
    ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: controller.getDuration(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: controller.totalDuration(),
                )
              ],
            )
          ],
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/views/widgets/common_designs.dart';
import 'package:tune_in/views/widgets/miniplayer_widget/nowplaying_page_miniplayer.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/color_changing_icons.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/current_song_image.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/player_slider_controller.dart';


class NowPlaying extends StatelessWidget {
 const NowPlaying({Key? key, this.value = 100.0, this.songName = '', this.songImage})
      : super(key: key);
 final double value;
  final String? songName;
  final dynamic songImage;
  

  @override
  Widget build(BuildContext context) {
    const controllerheight = 50;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  Container(
        decoration: BoxDecoration(gradient: gradient()),
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0),
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: const Color(0XFFFFFFFF).withOpacity(0.2),
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              centerTitle: true,
              title: const Text('Now Playing'),
            ),
            body: 
              Column(
                children: [
                  SizedBox(
                    height: height*0.08,
                    child: Center(
                        child: ValueListenableBuilder(
                          valueListenable: currentSongNameNotifier,
                          builder: (BuildContext context, String title, _) {
                            return title.length>20?Marquee(text: title,
                      style:  TextStyle(fontSize: width*0.050),
                    ):Text(title, style: TextStyle(fontSize:  width*0.050));
                          }
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
//================here the song image and progress bar controll of the song================//
               const  Expanded(
                   flex: 2,
                   child:  CurrentSongImage()),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: width*0.08),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {

                              },
                              icon: const Icon(
                                Icons.timer,
                                color: Colors.white,
                              )),
                          ValueListenableBuilder(
                            valueListenable: isCurrentsongPinned,
                            builder: (BuildContext context, bool isPinned, _) {
                              return const ColorChangeIcon();
                            }
                          )
                        ],
                      ),
                    ),
                  ),
                const Sliderclass(),
              const NowplayingController()
                  //================need to edit ==============//
                ],
              ),
             
              ),
      );
  }
}

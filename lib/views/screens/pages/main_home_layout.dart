import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/views/screens/pages/album_page.dart';
import 'package:tune_in/views/screens/pages/library_page.dart';
import 'package:tune_in/views/screens/pages/main_playlist_page.dart';
import 'package:tune_in/views/screens/pages/nowplaying_page.dart';
import 'package:tune_in/views/screens/pages/search_page.dart';
import 'package:tune_in/views/screens/pages/settings_page.dart';
import 'package:tune_in/views/widgets/common_designs.dart';
import 'package:tune_in/views/widgets/miniplayer_widget/front_side_miniplyer.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({Key? key}) : super(key: key);
  final ValueNotifier<int> bottonintexnotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    List pages = [
      const Library(),
      const Albums(),
      const Playlist(),
      const Settings()
    ];
    List titles = ['Library', 'Albums', 'Playlist', 'Settings'];
    return Container(
      decoration: BoxDecoration(gradient: gradient()),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0),
        appBar: AppBar(
          actions: [
            ValueListenableBuilder(
              valueListenable: bottonintexnotifier,
              builder: (BuildContext ctx, int index, _) {
                return index < 1
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const Searchpage()));
                        },
                        icon: const Icon(Icons.search_rounded))
                    : const SizedBox();
              },
            )
          ],
          title: ValueListenableBuilder(
            valueListenable: bottonintexnotifier,
            builder: (BuildContext ctx, int index, _) {
              return Text(titles[index]);
            },
          ),
          elevation: 0,
          backgroundColor: const Color(0XFFC4C4C4).withOpacity(0.2),
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: bottonintexnotifier,
          builder: (BuildContext context, int newintex, _) {
            return BottomNavigationBar(
              unselectedItemColor: Colors.white.withOpacity(0.5),
              backgroundColor: Colors.black.withOpacity(0.3),
              type: BottomNavigationBarType.fixed,
              mouseCursor: MouseCursor.uncontrolled,
              showUnselectedLabels: false,
              onTap: (newindex) {
                bottonintexnotifier.value = newindex;
              },
              currentIndex: bottonintexnotifier.value,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_music_outlined),
                    activeIcon: Icon(Icons.library_music_rounded),
                    label: 'Library'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.album), label: 'Albums'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.headphones_sharp),
                    activeIcon: Icon(Icons.headphones_outlined),
                    label: 'Playlist'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ],
            );
          },
        ),
        body: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: bottonintexnotifier,
              builder: (BuildContext context, int index, _) {
                return pages[index];
              },
            ),

            //==================== mini player ====================//
            Positioned(
              bottom: 0,
              child: ValueListenableBuilder(
                valueListenable: isplayed,
                builder: (BuildContext context, bool isplayed, _) {
                  return Visibility(
                    replacement: const SizedBox(),
                    visible: isplayed,
                    child: OpenContainer(
                      transitionType: ContainerTransitionType.fade,
                      transitionDuration: const Duration(milliseconds: 600),
                      closedBuilder: (BuildContext ctx, action) => MiniPlayer(
                        width: width,
                      ),
                      openBuilder: (BuildContext context, action) {
                        return const NowPlaying();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

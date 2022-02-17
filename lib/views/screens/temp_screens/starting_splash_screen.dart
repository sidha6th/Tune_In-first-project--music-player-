import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/views/screens/pages/main_home_layout.dart';
import 'package:tune_in/views/screens/temp_screens/intro_screen.dart';


class TuneinScreenSplash extends StatefulWidget {
  const TuneinScreenSplash({Key? key}) : super(key: key);

  @override
  State<TuneinScreenSplash> createState() => _TuneinScreenSplashState();
}

class _TuneinScreenSplashState extends State<TuneinScreenSplash> {
  @override
  void initState() {
    super.initState();
    gotolibrary();
  }

  gotolibrary() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final isaccepted = pref.getBool('accepted');
    if (isaccepted == null || isaccepted == false) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const IntroScreen()));
    } else {
      await fetchSong(accepted: true);
      await getplaylist();
      await getThePinnedSongs();
      await getUserPlaylistSongs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: AnimatedSplashScreen(
        backgroundColor: Colors.black.withOpacity(0),
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(milliseconds: 500),
        splash: Image(
          width: MediaQuery.of(context).size.width * 0.5,
          image: const AssetImage('assets/images/logo.png'),
        ),
        nextScreen: BottomNavigation(),
      ),
    );
  }
}

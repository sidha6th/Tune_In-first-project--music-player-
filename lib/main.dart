import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/db/db_model.dart';
import 'package:tune_in/views/screens/temp_screens/starting_splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AllSongsAdapter().typeId)) {
    Hive.registerAdapter(AllSongsAdapter());
  }
  if (!Hive.isAdapterRegistered(OnlyModelplaylistAdapter().typeId)) {
    Hive.registerAdapter(OnlyModelplaylistAdapter());
  }
  if (!Hive.isAdapterRegistered(ModelPlaylistsongsAdapter().typeId)) {
    Hive.registerAdapter(ModelPlaylistsongsAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<PlayerController>(
      create: (context) => PlayerController(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'font1',
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        title: 'tune',
        home: const TuneinScreenSplash(),
      ),
    );
  }
}
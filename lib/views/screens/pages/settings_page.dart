import 'package:flutter/material.dart';
import 'package:tune_in/controller/provider.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/views/screens/pages/detailes_pages/about_page.dart';
import 'package:tune_in/views/screens/temp_screens/intro_screen.dart';


class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            showDialog(
            context: context,
            builder: (BuildContext context) {
              return getTimer(context);
            },
          );
             },
          leading: const Icon(
            Icons.timer,
            color: Colors.white60,
          ),
          title: const Text(
            'Sleep timer',
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
          trailing: ValueListenableBuilder(
            valueListenable: sleepTimerIndicator,
            builder: (BuildContext context, String time, _) {
              return Text(
                time,
                style:const TextStyle(fontSize: 17,color: Colors.white),
              );
            }
          ),
        ),
        const ListTile(
          leading: Icon(
            Icons.memory_rounded,
            color: Colors.greenAccent,
          ),
          title: Text(
            'Version',
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
          trailing: Text('V 1.0.0'),
        ),
        ListTile(
         onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (ctx){
             return const AboutPage();
           }),);
         },
          leading:const Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          title:const Text(
            'About',
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
        ),
        ListTile(
          onTap: () {
            clearalldata();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const IntroScreen()));
          },
          leading: const Icon(
            Icons.settings_backup_restore_sharp,
            color: Colors.white,
          ),
          title: const Text(
            'Reset App',
            style: TextStyle(fontSize: 19, color: Colors.red),
          ),
        ),
      ],
    );
  }
}



import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tune_in/utility/data_functions/functions.dart';
import 'package:tune_in/views/screens/pages/main_home_layout.dart';


class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image(
                      image: const AssetImage('assets/images/logo.png'),
                      width: width * 0.6,
                      height: height * 0.4,
                    )),
              ),
              Positioned(
                  top: height * 0.19,
                  left: width * 0.505,
                  child: Padding(
                    padding: EdgeInsets.only(left: width*0.01),
                    child: GradientText(
                      'une',
                      colors: const [Colors.purpleAccent, Colors.blueAccent],
                      style:  TextStyle(
                        fontFamily: 'logofont',
                        fontSize: width*0.16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: height * .06,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final SharedPreferences isaccepted =
                  await SharedPreferences.getInstance();
              isaccepted.setBool('accepted', true);
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (ctx) {
                return FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 500),()=>fetchSong(accepted: false)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Scaffold(
                            backgroundColor: Colors.blueGrey[900],
                            body: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                              const  CircularProgressIndicator(),
                                Text(
                                  'Scanning songs...',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width*0.05,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )));
                      }
                      return BottomNavigation();
                    });
              }));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              GradientText(
                'tune On',
                style:  TextStyle(fontSize: width*0.08),
                colors: const [Colors.purpleAccent, Colors.blueAccent],
              ),
              const Icon(
                Icons.arrow_right_alt,
                color: Colors.purpleAccent,
                size: 30,
              )
            ]),
          )
        ],
      ),
    );
  }
}

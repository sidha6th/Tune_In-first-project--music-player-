import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Image(
                  image: const AssetImage('assets/images/logo.png'),
                  width: width * 0.6,
                  height: height * 0.4,
                ),
              ),
               Expanded(
                child:  Align(
                  alignment: Alignment.centerLeft,
                  child:  Text('''Thank you for using this app

    its a simple offline music player, created by Sidharth using flutter
                   ''',style: TextStyle(fontSize: width*0.08,color: Colors.white,fontWeight: FontWeight.w500,fontFamily: 'aboutFont'),),
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Divider(color: Colors.white,thickness: 2,),
              ),
              SizedBox(
                width: width,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueGrey[900])),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

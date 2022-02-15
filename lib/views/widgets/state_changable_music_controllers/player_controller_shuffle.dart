import 'package:flutter/material.dart';
bool shuffle=true;
Icon icon=const Icon(Icons.shuffle);
class ShuffleIcon extends StatefulWidget {
  const ShuffleIcon({Key? key}) : super(key: key);

  @override
  State<ShuffleIcon> createState() => _SfflueButtonState();
}

class _SfflueButtonState extends State<ShuffleIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if(shuffle==true){
            setState(() {
             icon= const Icon(Icons.shuffle,color: Colors.white,);
            });
            shuffle=false;
          }else{
            setState(() {
               icon=const Icon(Icons.shuffle);
               shuffle=true;
            });
          }
        },
        icon: icon ,iconSize: 30,);
  }
}
import 'package:flutter/material.dart';
import 'package:tune_in/controller/provider.dart';



class ColorChangeIcon extends StatefulWidget {
  const ColorChangeIcon({
    Key? key,
  }) : super(key: key);

  @override
  _ColorChangeIconState createState() => _ColorChangeIconState();
}

class _ColorChangeIconState extends State<ColorChangeIcon> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isCurrentsongPinned,
        builder: (BuildContext context, bool ispinned, _) {
          return InkWell(
            child: isCurrentsongPinned.value != true
    ? const Icon(
        Icons.push_pin_outlined,
        color: Colors.white,
      )
    : const Icon(Icons.push_pin, color: Colors.red),
            onTap: 
                ()async {
                if (ispinned != true) {
                  setState(() {
                    
                  });
                  await pinSongFromNowplaying(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 150),
                    backgroundColor: Colors.blueGrey,
                    content: Text('Song Pinned'),
                    behavior: SnackBarBehavior.floating,
                  ));
                } else {
                  setState(() {
                    
                  });
                  await unPinSongFromNowplaying(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 150),
                    backgroundColor: Colors.blueGrey,
                    content: Text('Song Unpinned'),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              },
          );
        });
  }
}

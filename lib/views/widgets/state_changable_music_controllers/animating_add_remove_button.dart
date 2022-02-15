import 'package:flutter/material.dart';
Icon add=const Icon(Icons.add_circle_outline,color: Colors.white,);
Icon remove=Icon(Icons.remove_circle_outline,color: Colors.redAccent.shade700,);
Icon currentIcon = add;
class AddRemoveBtn extends StatefulWidget {
  const AddRemoveBtn({
    Key? key,
    required this.builder1(),

  }) : super(key: key);
  final Function builder1;

  @override
  _AddRemoveBtnState createState() => _AddRemoveBtnState();
} 
class _AddRemoveBtnState extends State<AddRemoveBtn> {
 

  @override
  Widget build(BuildContext context) {
    
    return IconButton(
        onPressed: () {
            setState(() {
              widget.builder1();
            });
        },
        icon: currentIcon);
  }
}

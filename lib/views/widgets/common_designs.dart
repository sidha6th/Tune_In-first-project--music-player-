import 'package:flutter/material.dart';

gradient() {
  return const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0XFF6A567B),
        Color(0XFFCE837E),
        Color(0XFF378BB0),
        Color(0XFF4CDCDD),
        Color(0XFF29A3BB),
        Color(0XFF323035),
      ]);
}

//common music controll icons
musicControllerIcon({icon, builder}) {
  return IconButton(
      onPressed: () {
        builder();
      },
      icon: Icon(
        icon,
        size: 35,
      ));
}

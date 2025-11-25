import 'package:flutter/material.dart';
class Socialbutton extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onPressed;
  const Socialbutton({super.key,required this.imagePath,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.indigoAccent),
          boxShadow: [BoxShadow(
          spreadRadius: 1,
            blurRadius: 1,
      )]
        ),
        child: Image.asset(imagePath),
      );

  }
}

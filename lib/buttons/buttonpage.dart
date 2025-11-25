import 'dart:ffi';

import 'package:flutter/material.dart';
class Button extends StatelessWidget {
  final double? height;
  final double width;
  final String? text;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final VoidCallback? onpressed;
  final String? imagePath;
  const Button({super.key,this.height,required this.width, this.text,required this.backgroundColor,this.borderColor,this.textStyle,this.onpressed,this.imagePath});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: backgroundColor,
          border: Border.all(color: borderColor??Colors.indigoAccent),

        ),
        child: Center(child: text!=null?Text(text!,style: textStyle):Image.asset(imagePath!,height: 20,width: 30,)),

      ),
    );
  }
}

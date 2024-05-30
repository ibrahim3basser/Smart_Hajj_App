import 'package:flutter/material.dart';
import 'package:hajj_app/constants.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
   CustomButton({super.key, this.onTap,required this.text});
   VoidCallback? onTap;
  String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:120,
        height: 50,
        decoration: BoxDecoration(
          color: KIconColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Center(
          child: Text(
            text,
            style:const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
    
  }
}
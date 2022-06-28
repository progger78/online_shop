import 'package:flutter/material.dart';


import '../utils/dimensions.dart';

class AppIcon extends StatelessWidget {
  AppIcon(
      {Key? key,
      required this.icon,
      this.onPressed,
      this.backgorundColor = Colors.white54,
      this.iconColor = Colors.black
      })
      : super(key: key);

  final IconData icon;
  Color? backgorundColor;
  Color? iconColor;
  VoidCallback? onPressed;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: Dimensions.height45+5,
        width: Dimensions.width45+5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgorundColor,
        ),
        child: Icon(
          
          icon,
          color: iconColor,
          size: Dimensions.height25,
        ),
      ),
    );
  }
}

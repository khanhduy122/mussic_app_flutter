import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';

class containerTextField extends StatelessWidget {
  const containerTextField({super.key, required this.hintText, required this.icon, required this.height, required this.radius });

  final String hintText;
  final String icon;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: appColor.darkGrey,
        borderRadius: BorderRadius.circular(radius)
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset(icon, color: appColor.LightGray,),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: appColor.LightGray),
                border: InputBorder.none
              ),
            ),
          ),
        ],
      ),
    );
  }
}
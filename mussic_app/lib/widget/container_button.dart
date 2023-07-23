import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';

class ContainerButton extends StatelessWidget {
  const ContainerButton({super.key, required this.ontap, required this.height, required this.width, required this.radius, required this.child});
  
  final double height;
  final double width;
  final double radius;
  final Function() ontap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: gradient.GradientButtonPlay,
          borderRadius: BorderRadius.circular(radius)
        ),
        child: Center(child: child)
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';

class ContainerSeeMore extends StatelessWidget {
  const ContainerSeeMore({super.key, required this.ontap, required this.title});

  final String title;
 final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        height: 30,
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xff222222),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          child: Text(title,
            style: const TextStyle(color: appColor.LightGray, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
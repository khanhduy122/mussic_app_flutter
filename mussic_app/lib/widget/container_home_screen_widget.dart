import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';

class ContainerHomeWidget extends StatelessWidget {
  const ContainerHomeWidget({super.key, required this.icon, required this.title, required this.ontap});

  final String icon;
  final String title;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 70,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: appColor.darkGrey,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Image.asset(icon),
          ),
          Text(title,
          style: const TextStyle(color: appColor.LightGray, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
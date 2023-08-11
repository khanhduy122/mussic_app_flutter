import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';

class ContainerItemUserScreen extends StatelessWidget {
  const ContainerItemUserScreen({super.key, required this.icon, required this.tiltle, required this.ontap});

  final String icon;
  final String tiltle;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: appColor.darkGrey,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(icon,
              height: 30,
              fit: BoxFit.fill,
            ),
            Text(tiltle,
              style: const TextStyle(color: appColor.LightGray, fontSize: 12, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
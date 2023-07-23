import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            color: appColor.primaryColor,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            appAsset.imgLogo,
            height: size.height/2,
            width: size.width/2,
            ),
        )
      ],
    );
  }
}
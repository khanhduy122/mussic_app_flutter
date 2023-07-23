import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';

class containerAppBar extends StatelessWidget {
  const containerAppBar({super.key, required this.imageNetWork, required this.title, this.subTitle});

  final String imageNetWork;
  final String title;
  final String? subTitle;


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageNetWork),
                fit: BoxFit.fill
              ),
            ),
          ),
          Container(
            height: 360,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  appColor.primaryColor
                ]
              )
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  subTitle != null ?
                  Text(subTitle!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ) : Container()
                ],
              ),
            ),
          ),
          Positioned(
            top: 48,
            left: 24,
            child: containerBack(context)
          )
        ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/playlist.dart';

class ContainerPlayListHot extends StatelessWidget {
  const ContainerPlayListHot({super.key, required this.playList, required this.axis, required this.ontap, required this.width, required this.height});

  final PlayList playList;
  final Axis axis;
  final double width;
  final double height;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return axis == Axis.vertical ? GestureDetector(
      onTap: ontap,
      child: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: height-30,
              width: width-30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(playList.thumbnail!),
                  fit:  BoxFit.fill
                ),
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            Container(
              width: width-30,
              alignment: Alignment.center,
              child: Text(playList.title!,
                maxLines: 2, 
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: appColor.LightGray, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    ) : GestureDetector(
      onTap: ontap,
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height,
              width: width,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(playList.thumbnail!),
                  ),
                  borderRadius: BorderRadius.circular(5)),
            ),
            Expanded(
              child: Text(
                playList.title!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
            )
          ],
        ),
      ),
    );
  }
}
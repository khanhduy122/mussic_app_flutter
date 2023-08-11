import "package:flutter/material.dart";
import 'package:mussic_app/component/app_color.dart';
import '../model/mv.dart';

class ContainerMV extends StatelessWidget {
  const ContainerMV({super.key, required this.mv, required this.symmetric, required this.onTap});

  final MV mv;
  final Axis symmetric;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (symmetric == Axis.vertical) {
      return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 300,
            margin: const EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(mv.thumbnailM!), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          height: 20,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            formatTime(mv.duration!),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(mv.artists![0].thumbnail!),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        Container(
                          width: size.width-100,
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mv.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: appColor.LightGray,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                mv.artistsNames!,
                                style: const TextStyle(
                                    color: Color(0xffaaaaaa),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
        );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(mv.thumbnail!), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          height: 20,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            formatTime(mv.duration!),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width-20,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              mv.title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: appColor.LightGray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            mv.artistsNames!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Color(0xffaaaaaa),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
      );
    }
  }

  String formatTime(int duration){
    if((duration % 60).toString().length == 1){
      return "${duration ~/ 60}:0${duration % 60}";
    }else{
      return "${duration ~/ 60}:${duration % 60}";
    }
  }
}

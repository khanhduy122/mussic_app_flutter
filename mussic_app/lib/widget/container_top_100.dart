import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/widget/container_button.dart';

class containerTop100 extends StatelessWidget {
  const containerTop100(
      {super.key,
      this.gradient,
      });

  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 300,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: gradient == null ? appColor.darkGrey : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin:const  EdgeInsets.only(left: 24, top: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContainerButton(
                    height: 30,
                    width: 30,
                    radius: 15,
                    child: Image.asset(appAsset.iconPlay, height: 15,),
                    ontap: () {},
                  )
                ],
              ),
            ),
            // ContainerTopMussic(
            //   song: songTemp, 
            //   ontap: (){}
            // ),
            // ContainerTopMussic(
            //   song: songTemp, 
            //   ontap: (){}
            // ),
            // ContainerTopMussic(
            //   song: songTemp, 
            //   ontap: (){}
            // ),
            // Container(
            //   margin: EdgeInsets.only(top: 10),
            //   alignment: Alignment.center,
            //   child: ContainerSeeMore(
            //     ontap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) =>
            //                 ListMussicTop100Screen(charts: charts),
            //           ));
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

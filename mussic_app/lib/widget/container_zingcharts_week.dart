import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/charts.dart';


class containerZingChartsWeek extends StatelessWidget {
  const containerZingChartsWeek({super.key,required this.itemWeekChart, required this.ontap});

  final ItemWeekChart itemWeekChart;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 150,
        width: size.width,
        decoration: BoxDecoration(
          color: appColor.darkGrey,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(itemWeekChart.songs![0].thumbnail!),
                  fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            SizedBox(
              width: size.width - 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(itemWeekChart.country! == "vn" ? "Việt Nam" : itemWeekChart.country! == "us" ? "US - UK" : "K - Pop",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('1. ${itemWeekChart.songs![0].title}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text('2. ${itemWeekChart.songs![1].title}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text('3. ${itemWeekChart.songs![2].title}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
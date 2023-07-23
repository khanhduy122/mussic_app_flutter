import 'package:flutter/material.dart';
import 'package:mussic_app/model/song.dart';

class ContainerListMussicNew extends StatelessWidget {
  const ContainerListMussicNew({super.key, required this.song, required this.ontap, this.onLongPress});

  final Song song;
  final Function() ontap;
  final Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onLongPress: onLongPress,
      onTap: ontap,
      child: Container(
        height: 60,
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(song.thumbnail!),
                  fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(song.artistsNames!,
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 13),
                  )
                ],
              ),
            ),
            const Icon(Icons.more_horiz_rounded, color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
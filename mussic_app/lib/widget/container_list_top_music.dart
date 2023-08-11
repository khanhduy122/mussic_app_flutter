import 'package:flutter/material.dart';
import 'package:mussic_app/model/song.dart';

class ContainerTopMussic extends StatelessWidget {
  const ContainerTopMussic({super.key, required this.song, required this.ontap, required this.position, });

  final Song song;
  final int position;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: Text(
                position.toString(),
                style: position == 1 ? const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 40)
                : position == 2 ? const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 35):
                position == 3 ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30):
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
              ),
            ),
            Container(
              height: 50,
              width: 50,
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
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.title!,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(song.artistsNames!,
                      maxLines: 3,
                      style: const TextStyle(color: Color(0xffbbbbbb), fontWeight: FontWeight.w500, fontSize: 13),
                    )
                  ],
                ),
              ),
            ),
            const Icon(Icons.more_horiz_rounded, color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
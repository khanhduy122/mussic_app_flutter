import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mussic_app/model/artist.dart';

class containerItemArtist extends StatelessWidget {
  const containerItemArtist({super.key, required this.artist, required this.ontap, required this.axis,});

  final Artist artist;
  final Axis axis;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return axis == Axis.vertical ?  GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: artist.thumbnail!,
              placeholder: (context, url) => Container(
                height: 80, width: 80,
                decoration: BoxDecoration(color:  Colors.grey[200]),
              ),
              imageBuilder: (context, imageProvider) => Container(
                height: 80,
                width: 80,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.circular(40)
                ),
              ),
            ),
            Text(artist.name!,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                artist.totalFollow!.toString().length == 4 ? '${artist.totalFollow! ~/ 1000}K Quan Tâm'
                : artist.totalFollow!.toString().length == 5 ? '${artist.totalFollow! ~/ 1000}K Quan Tâm' :
                artist.totalFollow!.toString().length == 6 ? '${artist.totalFollow! ~/ 1000}K Quan Tâm' :
                artist.totalFollow!.toString().length == 7 ? '${(artist.totalFollow! / 1000000).toStringAsFixed(1)}M Quan Tâm' 
                : '${artist.totalFollow} Quan Tâm',
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    ) : GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(artist.thumbnail!,),
                fit: BoxFit.fill
              ),
              borderRadius: BorderRadius.circular(30)
            ),
          ),
    
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(artist.name!,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              artist.totalFollow != null ? Text(
                artist.totalFollow!.toString().length == 4 ? '${artist.totalFollow! ~/ 1000}K Quan Tâm'
                : artist.totalFollow!.toString().length == 5 ? '${artist.totalFollow! ~/ 1000}K Quan Tâm' :
                artist.totalFollow!.toString().length == 6 ? '${artist.totalFollow! ~/ 1000}K Quan Tâm' :
                artist.totalFollow!.toString().length == 7 ? '${(artist.totalFollow! / 1000000).toStringAsFixed(1)}M Quan Tâm' 
                : '${artist.totalFollow} Quan Tâm',
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ) : Container(),
            ],
          )
        ],
      ),
    );
  }
}
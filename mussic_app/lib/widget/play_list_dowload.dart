import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mussic_app/model/playlist.dart';

class PlayListDowload extends StatelessWidget {
  const PlayListDowload({super.key, required this.playlists});

  final List<PlayList> playlists;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'PlayList',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 24,
        ),
        Expanded(
            child: ListView.builder(
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            return Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: playlists[index].thumbnail!,
                      placeholder: (context, url) => Container(
                        height: 70, width: 70,
                        decoration: BoxDecoration(color:  Colors.grey[200]),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlists[index].title!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          
                        ],
                      ),
                    )
                  ],
                ));
          },
        ))
      ],
    );
  }
}

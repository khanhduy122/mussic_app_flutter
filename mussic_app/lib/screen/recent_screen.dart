import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/screen/list_artist_recent.dart';
import 'package:mussic_app/screen/list_playlist_recent.dart';
import 'package:mussic_app/screen/list_song_recent.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int indextab = 0;
    return DefaultTabController(
      length: 3,
      initialIndex: indextab,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor.primaryColor,
          leading: containerBack(context),
          title: const Text("Gần Đây",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
          tabs: [
              Tab(
                child: Text("Bài Hát",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Tab(
                child: Text("PlayList",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Tab(
                child: Text("Artist",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ]
          )
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const TabBarView(
            children:  [
              ListSongRecent(),
              ListPlayListRecent(),
              ListArtistRecent()
            ]
          ),
        ),
      ),
    );
  }
}
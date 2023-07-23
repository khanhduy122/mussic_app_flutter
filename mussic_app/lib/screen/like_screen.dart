import 'package:flutter/material.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/screen/like_playlist_tab_screen.dart';
import 'package:mussic_app/screen/like_song_tab_screen.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {

  int indextab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: indextab,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor.primaryColor,
          leading: containerBack(context),
          title: const Text("Yêu Thích",
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
                child: Text("Video",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ]
          )
        ),
        body: TabBarView(
          children: [
            const LikeSongTabScreen(),
            const LikePlayListTabScreen(),
            Container(),
          ]
        ),
      ),
    );
  }
}
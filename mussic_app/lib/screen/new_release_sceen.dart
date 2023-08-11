import 'package:flutter/material.dart';
import 'package:mussic_app/model/HomeData.dart';
import 'package:mussic_app/screen/list_song_tab_screen.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/component/app_color.dart';

class NewReleaseScreen extends StatefulWidget {
  const NewReleaseScreen({super.key, required this.newRelease});

  final homeItem newRelease;

  @override
  State<NewReleaseScreen> createState() => _NewReleaseScreenState();
}

class _NewReleaseScreenState extends State<NewReleaseScreen> {

 
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor.primaryColor,
          leading: containerBack(context),
          title: const Text("Nhạc Mới Phát Hành",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
          tabs: [
              Tab(
                child: Text("Tất Cả",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Tab(
                child: Text("Việt Nam",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Tab(
                child: Text("Nước Ngoài",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ]
          )
        ),
        body: TabBarView(
          children: [
            ListSongTabScreen(listSong: widget.newRelease.itemNewRelease!.allSongs!),
            ListSongTabScreen(listSong: widget.newRelease.itemNewRelease!.vpop!),
            ListSongTabScreen(listSong: widget.newRelease.itemNewRelease!.other!)
          ]
        ),
      ),
    );
  }
}
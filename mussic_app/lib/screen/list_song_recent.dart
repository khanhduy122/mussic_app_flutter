import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/audioPlayer/events/audio_player_event.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListSongRecent extends StatefulWidget {
  const ListSongRecent({super.key});

  @override
  State<ListSongRecent> createState() => _ListSongRecentState();
}

class _ListSongRecentState extends State<ListSongRecent> {
  final List<Song> listSong = [];
  @override
  void initState() {
    // TODO: implement initState
    getListSongRecent();
    super.initState();
  }

  Future<void> getListSongRecent() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listSongRecent = prefs.getStringList(appKey.listSongRecent) ?? [];
    listSong.clear();
    listSongRecent.forEach((element) {
      listSong.add(Song.fromJson(jsonDecode(element)));
    });
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        SizedBox(
          height: listSong.length * 70,
          child: ListView.builder(
            itemCount: listSong.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ContainerListMussicNew(
                    song: listSong[index], 
                    ontap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                    },
                  ),
                  const SizedBox(height: 10,),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
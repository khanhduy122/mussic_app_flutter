import 'package:flutter/material.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_list_top_music.dart';

class ListSongTabScreen extends StatelessWidget {
  const ListSongTabScreen({super.key, required this.listSong});
  
  final List<Song> listSong;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 24),
                      child: Image.asset(appAsset.iconDowloadAll),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 24),
                    child: ContainerButton(
                      ontap: (){
                        appState.currentSong = listSong[0];
                        appState.listSong = listSong.sublist(0);
                        appState.isShuffle = null;
                        appState.indexSong = 0;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen()));
                      }, 
                      height: 40, 
                      width: 40, 
                      radius: 20, 
                      child: Image.asset(appAsset.iconPlay)
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: listSong.length * 60,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listSong.length,
                  itemBuilder: (context, index) {
                    return ContainerTopMussic(
                      song: listSong[index],
                      ontap: (){
                        appState.currentSong = listSong[index];
                        appState.listSong = listSong.sublist(0);
                        appState.isShuffle = null;
                        appState.indexSong = index;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                      }, 
                      position: index + 1
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
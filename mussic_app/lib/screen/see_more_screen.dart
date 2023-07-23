
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/screen/play_mv_screen.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';
import 'package:mussic_app/widget/container_mv_.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';
import 'package:mussic_app/widget/dialo_erro.dart';

class SeeMoreScreen extends StatelessWidget {
  const SeeMoreScreen({super.key, this.listMV, this.listPlayList, this.listSong, required this.title});

  final List<PlayList>? listPlayList;
  final List<MV>? listMV;
  final List<Song>? listSong;
  final String title;

  @override
  Widget build(BuildContext context) {
    final _getInfoPlayList = PlayMussicBloc();

    return BlocListener<PlayMussicBloc, PlayMussicState>(
      bloc: _getInfoPlayList,
      listener: (context, state) {
        if(state.isLoading == true){
          appDiaLog.ShowDialogLoading(context);
        }
        if(state.playList != null){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListScreen(playList: state.playList!),));
        }

        if(state.erro != null){
          Navigator.pop(context);
          showDialogErro(context: context, erro: state.erro!);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: appColor.primaryColor,
            leading: containerBack(context),
            title: Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
             listSong != null ? Padding(
               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
               child: ContainerButton(
                  ontap: (){
                    appState.currentSong = listSong![0];
                    appState.listSong = listSong!.sublist(0);
                    appState.indexSong = 0;
                    appState.isShuffle = null;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                  }, 
                  height: 40, 
                  width: 40, 
                  radius: 20, 
                  child: const Icon(Icons.play_arrow)
                ),
             ) : Container()
            ],
          ),
          body: listPlayList != null ? 
          GridView.builder(
            itemCount: listPlayList!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10), 
            itemBuilder: (context, index) {
              return ContainerPlayListHot(
                height: 180,
                width: 180,
                playList: listPlayList![index], 
                axis: Axis.vertical, 
                ontap: (){
                  _getInfoPlayList.add(getInfoPlayListEvent(encodeId: listPlayList![index].encodeId!));
                }
              );
            },
          )
          : listMV != null ? Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SizedBox(
              height: listMV!.length * 120,
              child: ListView.builder(
                itemCount: listMV!.length,
                itemBuilder: (context, index) {
                  return ContainerMV(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayMvScreen(mv: listMV![index]),));
                    },
                    mv: listMV![index], 
                    symmetric: Axis.horizontal
                  );
                },
              ),
            ),
          ): 
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${listSong!.length} Bài hát" ,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        onPressed: (){
            
                        }, 
                        icon: const Icon(Icons.download, color: Colors.white, size: 25,)
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: listSong!.length * 70,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listSong!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ContainerListMussicNew(
                              song: listSong![index], 
                              ontap: (){
                                appState.currentSong = listSong![index];
                                appState.listSong = listSong!.sublist(0);
                                appState.indexSong = index;
                                appState.isShuffle = null;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                              }
                            ),
                            const SizedBox(height: 10,)
                          ],
                        );
                      },
                    ),
                  )
                ]
              ),
            ),
          )
        ),
    );
  }
}
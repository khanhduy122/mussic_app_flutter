import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/dowload/blocs/dowload_bloc.dart';
import 'package:mussic_app/moduels/dowload/events/dowload_event.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DowloadScreen extends StatefulWidget {
  const DowloadScreen({super.key});

  @override
  State<DowloadScreen> createState() => _DowloadScreenState();
}

class _DowloadScreenState extends State<DowloadScreen> {

  List<Song> songs= [];

  @override
  void initState() {
    // TODO: implement initState
    getListSongDowload();
    super.initState();
  }

  Future<void> getListSongDowload() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(_prefs.getStringList(appKey.listSongDowloaded) != null){
      List<String> listsongs = _prefs.getStringList(appKey.listSongDowloaded)!.sublist(0);
      songs.clear();
      listsongs.forEach((element) {
        songs.add(Song.fromJson(jsonDecode(element)));
      });
      setState(() {});
    }
   
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor.primaryColor,
        leading: containerBack(context),
        title: const Text("Bài Hát Đã Tải",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<DownLoadBloc, DownLoadState>(
        bloc: appState.dowLoadBloc,
        listener: (context, state) {
          if(state is DownloadSuccess){
            songs.insert(0, state.song);
            setState(() {
              
            });
          }
        },
        child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      BlocBuilder<DownLoadBloc, DownLoadState>(
                        bloc: appState.dowLoadBloc,
                        builder: (context, state) {
                          if(state is DownloadingState){
                            if(state.isDowloading != null && state.isDowloading == true){
                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 60,
                                        child: ContainerListMussicNew(
                                          song: state.song!, 
                                          ontap: (){
                
                                          }
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        width: size.width,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          child: CircularProgressIndicator(
                                            value: state.progress,
                                          ),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                ],
                              );
                            }
                          }
                          return Container();
                        }
                      ),
                      SizedBox(
                        height: songs.length * 80,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ContainerListMussicNew(
                                  song: songs[index], 
                                  onLongPress: () async {
                                    if(await appDiaLog.showModalComfirm(context: context, tiltle: "Xác Nhận", subTitle: "Bạn có muốn xóa bài hát ${songs[index].title} ra khỏi danh sách tải về không ?")){
                                      appState.dowLoadBloc.add(DeleteSongDownloadEvent(song: songs[index]));
                                      songs.removeAt(index);
                                      setState(() {
                                        
                                      });
                                    }
                                  },
                                  ontap: (){
                                    appState.currentSong = songs[index];
                                    appState.listSong = songs;
                                    appState.indexSong = index;
                                    appState.isShuffle = null;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen()));
                                  }
                                ),
                                const SizedBox(height: 10,)
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            )
      )
    );
  }
}
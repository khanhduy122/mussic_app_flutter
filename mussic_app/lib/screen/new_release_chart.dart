import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/widget/container_app_bar.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_list_top_music.dart';

class NewReleaseChartScreen extends StatefulWidget {
  const NewReleaseChartScreen({super.key, required this.songs});

  final List<Song> songs;

  @override
  State<NewReleaseChartScreen> createState() => _NewReleaseChartScreenState();
}

class _NewReleaseChartScreenState extends State<NewReleaseChartScreen> {

  int lengthNewCharts = 20;
  final DateTime now = DateTime.now();
  final StreamController<int> _controller = StreamController<int>.broadcast();

  @override
  void initState() {
    // TODO: implement initState
    _controller.sink.add(20);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          containerAppBar(
            imageNetWork: widget.songs[0].thumbnailM!,
            title: "BXH NHẠC MỚI",
            subTitle: "Cập nhật ${now.day}/${now.month}/${now.year}",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 24),
                    child: Image.asset(appAsset.iconDowloadAll),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 24),
                child: ContainerButton(
                  ontap: (){
                    appState.currentSong = widget.songs[0];
                    appState.listSong = widget.songs.sublist(0);
                    appState.isShuffle = null;
                    appState.indexSong = 0;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                  }, 
                  height: 40, 
                  width: 40, 
                  radius: 20, 
                  child: Image.asset(appAsset.iconPlay)
                ),
              )
            ]
          ),
          StreamBuilder<Object>(
            stream: _controller.stream,
            builder: (context, snapshot) {
              return Container(
                  height: lengthNewCharts == 20 ? 1300 : 6100,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: lengthNewCharts * 60+40,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lengthNewCharts,
                          itemBuilder: (context, index) {
                            return ContainerTopMussic(
                              position: index+1,
                              song: widget.songs[index], 
                              ontap: () { 
                                appState.currentSong = widget.songs[index];
                                appState.listSong = widget.songs.sublist(0);
                                appState.isShuffle = null;
                                appState.indexSong = index;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                              },  
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24,),
                      GestureDetector(
                        onTap: (){
                          if(lengthNewCharts == 20){
                            lengthNewCharts = widget.songs.length;
                            _controller.sink.add(widget.songs.length);
                          }else{
                            lengthNewCharts = 20;
                            _controller.sink.add(20);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                            color: appColor.darkGrey,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: StreamBuilder<int>(
                            stream: _controller.stream,
                            builder: (context, snapshot) {
                              return Container(
                                child: Text(lengthNewCharts == 20 ? "Xem Thêm" : "Thu nhỏ",
                                  style: const TextStyle(color: appColor.LightGray, fontWeight: FontWeight.w500),
                                ),
                              );
                            }
                          ),
                        ),
                      )
                    ],
                  ),
                );
            }
          ),
          ]
        )
      )
    );
  }
}
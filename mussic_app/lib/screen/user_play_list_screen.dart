import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/moduels/firebase/blocs/firebase_bloc.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/screen/login_screen.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';

class UserPlayListScreen extends StatefulWidget {
  const UserPlayListScreen({super.key, required this.playList});

  final PlayList playList;

  @override
  State<UserPlayListScreen> createState() => _UserPlayListScreenState();
}

class _UserPlayListScreenState extends State<UserPlayListScreen> {
  @override
  Widget build(BuildContext context) {
    bool isHeart = false;
    if(widget.playList.encodeId != null){
      appState.firebaseBloc.add(getLikePlayListEvent(encodeId: widget.playList.encodeId!));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                widget.playList.thumbnailM != null ? Container(
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.playList.thumbnailM!),
                      fit: BoxFit.fill
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  ),
                ) : widget.playList.songs != null ? 
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.playList.songs![0].thumbnailM!),
                      fit: BoxFit.fill
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  ),
                  child: Image.asset(appAsset.iconMussicNote, color: Colors.black,),
                )
                : Container(
                  height: 350,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  ),
                  child: Image.asset(appAsset.iconMussicNote, color: Colors.black,),
                ),
                Positioned(
                  top: 48,
                  left: 24,
                  child: containerBack(context)
                )
              ],
           ),
            const SizedBox(height: 24,),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.playList.title!,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              BlocBuilder<FirebaseBloc, FirebaseStata>(
                                bloc: appState.firebaseBloc,
                                builder: (context, state) {
                                  if(state is LikePlayListState){
                                    isHeart = state.isHeart;
                                  }
                                  return GestureDetector(
                                    onTap: (){
                                      if(appState.user != null){
                                        appState.firebaseBloc.add(likePlaylistEvent(isHeart: isHeart, playList: widget.playList));
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 24),
                                      child: isHeart ? Image.asset(appAsset.iconHeartPress) : Image.asset(appAsset.iconHeart),
                                    ),
                                  );
                                }
                              ),
                              GestureDetector(
                                onTap: (){},
                                child: Container(
                                  height: 30,
                                  margin: const EdgeInsets.only(right: 24),
                                  child: Image.asset(appAsset.iconDowloadAll),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ContainerButton(
                          ontap: (){
                            Random random = Random();
                            int indexRandom = random.nextInt(widget.playList.songs!.length);
                            appState.currentSong = widget.playList.songs![indexRandom];
                            appState.listSong = widget.playList.songs!.sublist(0);
                            appState.isShuffle = true;
                            appState.indexSong = indexRandom;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                          }, 
                          height: 40, 
                          width: 200, 
                          radius: 30, 
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(appAsset.iconShuffle),
                              ),
                              const Text("Phát Ngẩu Nhiên",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: const Divider(color: Colors.white30,)
            ),
            StreamBuilder(
              stream: FirebaseRepo.getAllSongUserPlayList(encodeID: widget.playList.timestamp!),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Container();
                }else{
                  if(snapshot.hasData){
                    return SizedBox(
                      height: widget.playList.songs!.length * 70 + 24,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.playList.songs!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                ContainerListMussicNew(
                                  song: widget.playList.songs![index],
                                  isUserPlayList: true,
                                  ontap: (){
                                    appState.currentSong = widget.playList.songs![index];
                                    appState.listSong = widget.playList.songs!.sublist(0);
                                    appState.isShuffle = null;
                                    appState.indexSong = index;
                                    Navigator.push(context, 
                                      MaterialPageRoute(builder: (context) => playMussicScreen(),)
                                    );
                                  }, 
                                ),
                                const SizedBox(height: 10,)

                              ],
                            ),
                          );
                        },
                      )
                    );
                  }else{
                    return const Center(child: CircularProgressIndicator(),);
                  }
                }
                
              }
            ) 
          ]
        ),
      ),
    );
  }
}


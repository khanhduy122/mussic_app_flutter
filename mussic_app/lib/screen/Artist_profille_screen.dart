import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/moduels/firebase/blocs/firebase_bloc.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/login_screen.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/screen/play_mv_screen.dart';
import 'package:mussic_app/screen/see_more_screen.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/widget/container_item_artist.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';
import 'package:mussic_app/widget/container_mv_.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';
import 'package:mussic_app/widget/dialo_erro.dart';

class ArtistProfileScreen extends StatefulWidget {
  const ArtistProfileScreen({super.key, required this.artist});

  final Artist artist;

  @override
  State<ArtistProfileScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistProfileScreen> {

  final PageController _pageControllerMV = PageController(
    viewportFraction: 0.9
  );  
  final _getInfo = PlayMussicBloc();
  bool isFollow = false;

  @override
  void initState() {
    // TODO: implement initState
    if(appState.user != null){
      appState.firebaseBloc.add(getFollowArtistEvent(id: widget.artist.id!));
    }
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _pageControllerMV.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    
    return BlocListener<PlayMussicBloc, PlayMussicState>(
      bloc: _getInfo,
      listener: (context, state) {
        if(state.isLoading == true){
          appDiaLog.ShowDialogLoading(context);
        }
        if(state.playList != null){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListScreen(playList: state.playList!),));
        }

        if(state.artist != null){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistProfileScreen(artist: state.artist!),));
        }

        if(state.mv != null){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayMvScreen(mv: state.mv!),));
        }

        if(state.erro != null){
          Navigator.pop(context);
          showDialogErro(context: context, erro: state.erro!);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: size.height/2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.artist.thumbnailM!),
                          fit: BoxFit.fill
                        ),
                        borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ) 
                      ),
                    ),
                    Positioned(
                      top: 48,
                      left: 24,
                      child: containerBack(context)
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: size.height/3),
                        child: Column(
                          children: [
                            Container(
                              child: Text(widget.artist.name!,
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('${widget.artist.totalFollow} Người Quan Tâm',
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),

                            BlocBuilder<FirebaseBloc, FirebaseStata>(
                              bloc: appState.firebaseBloc,
                              builder: (context, state) {
                                if(state is FollowArtistState){
                                  isFollow = state.isFollow;
                                }
                                return GestureDetector(
                                  onTap: (){
                                    if(appState.user != null){
                                      appState.firebaseBloc.add(FollowArtistEvent(isFollow: isFollow, artist: widget.artist));
                                    }else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                                    }
                                  },
                                  child: isFollow ? Container(
                                    height: 40, 
                                    width: 150, 
                                    decoration: 
                                    BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white, width: 1)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: Image.asset(appAsset.iconFollowed, color: Colors.white,),
                                        ),
                                        const Text('Hủy Follow',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ) : Container(
                                    height: 40, 
                                    width: 120, 
                                    decoration: 
                                    BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: const Icon(Icons.person_add, color: Colors.white,),
                                        ),
                                        const Text('Follow',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.artist.sectionSong!.title!,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ContainerButton(
                        ontap: () {
                          appState.currentSong = widget.artist.sectionSong!.songItems![0];
                          appState.listSong = widget.artist.sectionSong!.songItems!.sublist(0);
                          appState.indexSong = 0;
                          appState.isShuffle = null;
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => playMussicScreen(),),
                          );
                        }, 
                        height: 40, 
                        width: 40, 
                        radius: 20, 
                        child: Image.asset(appAsset.iconPlay, height: 20,)
                      )
                    ],
                  ),
                ),
    
                
                Container(
                  height: widget.artist.sectionSong!.songItems!.length >= 5 ? 380 : widget.artist.sectionSong!.songItems!.length * 80,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.artist.sectionSong!.songItems!.length >= 5 ? 5 : widget.artist.sectionSong!.songItems!.length,
                    itemBuilder: (context, index){
                      return Column(
                        children: [
                          ContainerListMussicNew(
                            song: widget.artist.sectionSong!.songItems![index],
                            ontap: (){
                              appState.currentSong = widget.artist.sectionSong!.songItems![index];
                              appState.listSong = widget.artist.sectionSong!.songItems!.sublist(0);
                              appState.indexSong = index;
                              appState.isShuffle = null;
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => playMussicScreen(),)
                              );
                            },
                          ),
                          const SizedBox(height: 10,),
                        ],
                      );
                    }
                  )
                ),
                const SizedBox(height: 10,),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SeeMoreScreen(listSong: widget.artist.sectionSong!.songItems!, title: "Bài Hát",),));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xff222222),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Text("Xem Thêm",
                        style: TextStyle(color: appColor.LightGray, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
    
                const SizedBox(height: 20,),

                widget.artist.sectionMV != null ?
                widget.artist.sectionMV!.MVItems != null ? 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _containerTitle("MV"),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SeeMoreScreen(listMV: widget.artist.sectionMV!.MVItems, title: "Video",),));
                      },
                      child: const Text("See More",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ) : 
                  Container(): Container(),
    
                widget.artist.sectionMV != null ? widget.artist.sectionMV!.MVItems != null ? const SizedBox(height: 10,) : Container() : Container(),

                widget.artist.sectionMV != null ?
                widget.artist.sectionMV!.MVItems != null ? 
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: _pageControllerMV,
                    itemCount: widget.artist.sectionMV!.MVItems!.length >= 4 ? 4 : widget.artist.sectionMV!.MVItems!.length,
                    itemBuilder: (context, index) {
                      return ContainerMV(
                        onTap: (){
                          _getInfo.add(getInfoVideoEvent(encodeId: widget.artist.sectionMV!.MVItems![index].encodeId!));
                        },
                        mv: widget.artist.sectionMV!.MVItems![index], 
                        symmetric: Axis.vertical
                      );
                    },
                  ),
                ) : Container(): Container(),
    
                widget.artist.sectionMV != null ? widget.artist.sectionMV!.MVItems != null ? const SizedBox(height: 20,) : Container() : Container(),

                widget.artist.listSectionPlayList != null ?
                widget.artist.listSectionPlayList!.isNotEmpty ? 
                Container(
                  height: widget.artist.listSectionPlayList!.length * 240,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.artist.listSectionPlayList!.length,
                    itemBuilder: (context, indexSection) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _containerTitle(widget.artist.listSectionPlayList![indexSection].title!),
                              TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SeeMoreScreen(listPlayList: widget.artist.listSectionPlayList![indexSection].playListitems, title: widget.artist.listSectionPlayList![indexSection].title!,),));
                                },
                                child: const Text("See More",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.artist.listSectionPlayList![indexSection].playListitems!.length >= 5 ? 5 : widget.artist.listSectionPlayList![indexSection].playListitems!.length,
                              itemBuilder: (context, index) {
                                return ContainerPlayListHot(
                                  height: 130,
                                  width: 130,
                                  playList: widget.artist.listSectionPlayList![indexSection].playListitems![index], 
                                  axis: Axis.vertical, 
                                  ontap: (){
                                    _getInfo.add(getInfoPlayListEvent(encodeId: widget.artist.listSectionPlayList![indexSection].playListitems![index].encodeId!));
                                  }
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20,),
                        ],
                      );
                    },
                  ),
                ) : Container() : Container(),
    
                widget.artist.sectionArtist != null ? const SizedBox(height: 20,) : Container(),
                widget.artist.sectionArtist != null ?  _containerTitle(widget.artist.sectionArtist!.title!) : Container(),
                widget.artist.sectionArtist != null ? const SizedBox(height: 10,) : Container(),

                widget.artist.sectionArtist != null ?
                Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.artist.sectionArtist!.artistIteam!.length,
                    itemBuilder: (context, index) {
                      return containerItemArtist(
                        artist: widget.artist.sectionArtist!.artistIteam![index],
                        ontap: () {
                          _getInfo.add(getInfoArtistEvent(name: widget.artist.sectionArtist!.artistIteam![index].alias!));
                        }, 
                        axis: Axis.vertical,
                      );
                    },
                  ),
                ) : Container(),
                const SizedBox(height: 20,),
    
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text('Thông Tin',
                    style: TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 24,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Họ và tên : ${widget.artist.realname}",
                    style: const TextStyle(
                      color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                  Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Sinh Nhật : ${widget.artist.birthday}",
                    style: const TextStyle(
                      color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Quốc Gia : ${widget.artist.national}",
                    style: const TextStyle(
                      color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(widget.artist.biography!,
                    style: const TextStyle(
                      color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            ),
          ),
        
      )
    );
  }

  Container _containerTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(title,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  
}


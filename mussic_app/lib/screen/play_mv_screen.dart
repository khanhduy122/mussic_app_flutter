import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:flutter/cupertino.dart';
import 'package:mussic_app/moduels/firebase/blocs/firebase_bloc.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/moduels/videoPlayer/blocs/video_player_bloc.dart';
import 'package:mussic_app/moduels/videoPlayer/events/video_player_event.dart';
import 'package:mussic_app/screen/Artist_profille_screen.dart';
import 'package:mussic_app/screen/login_screen.dart';
import 'package:mussic_app/widget/container_item_artist.dart';
import 'package:mussic_app/widget/container_mv_.dart';
import 'package:mussic_app/widget/dialo_erro.dart';

class PlayMvScreen extends StatefulWidget {
  const PlayMvScreen({super.key, required this.mv});

  final MV mv;

  @override
  State<PlayMvScreen> createState() => _PlayMvScreenState();
}

class _PlayMvScreenState extends State<PlayMvScreen> {
  bool switchAutoplay = true;
  bool isSwith = true;
  bool isInitialized = false;
  bool isHeart = false;
  final VideoPlayerBloc _videoPlayerBloc = VideoPlayerBloc();
  final _getInfo = PlayMussicBloc();

  @override
  void initState() {
    _videoPlayerBloc.add(VideoPlayerLoadURLEvent(url: widget.mv.streaming!.mp4!.s720p!));
    appState.firebaseBloc.add(getLikeVideoEvent(encodeId: widget.mv.encodeId!));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerBloc.dispose();

  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<VideoPlayerBloc, VideoPlayerState>(
          bloc: _videoPlayerBloc,
          listener: (context, state) {
            if(state.isNextVideo == true){
              if(isSwith){
                _getInfo.add(getInfoVideoEvent(encodeId: widget.mv.recommends![0].encodeId!));
              }
            }
          },
          child: BlocListener<PlayMussicBloc, PlayMussicState>(
              bloc: _getInfo,
              listener: (context, state) {
                if(state.isLoading == true){
                  appDiaLog.ShowDialogLoading(context);
                }
        
                if(state.artist != null){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ArtistProfileScreen(artist: state.artist!),));
                  if(mounted == false){
                    _videoPlayerBloc.dispose();
                  }
                }
            
                if(state.mv != null){
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlayMvScreen(mv: state.mv!),));
                   if(mounted == false){
                    _videoPlayerBloc.dispose();
                  }
                }
            
                if(state.erro != null){
                  Navigator.pop(context);
                  showDialogErro(context: context, erro: state.erro!);
                }
              },
              child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                            bloc: _videoPlayerBloc,
                            builder: (context, state) {
                              if(state.isLoading == true || state.isLoading == null){
                                return SizedBox(
                                  height: size.height/3 - 50,
                                  width: size.width,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: size.height/3 - 50,
                                        width: size.width,
                                        child: Image.network(widget.mv.thumbnailM!, fit: BoxFit.cover,)
                                      ),
                                      const Center(child: CircularProgressIndicator(color: Colors.white,),)
                                    ],
                                  ),
                                );
                              }else{
                                return SizedBox(
                                  height: size.height/3 - 50,
                                  width: size.width,
                                  child: Chewie(
                                    controller: state.chewieController!,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.mv.title!,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              children: [
                                BlocConsumer<FirebaseBloc, FirebaseStata>(
                                  bloc: appState.firebaseBloc,
                                  buildWhen: (previous, current) {
                                    return (current is LikeVideoState);
                                  },
                                  listener: (context, state) {},
                                  builder: (context, state) {
                                    if(state is LikeVideoState){
                                      isHeart = state.isHeart;
                                    }
                                    return GestureDetector(
                                      onTap: (){
                                        if(appState.user != null){
                                          appState.firebaseBloc.add(likeVideoEvent(isLike: isHeart, mv: widget.mv));
                                        }else{
                                          _videoPlayerBloc.dispose();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                                        }
                                      },
                                      child: Image.asset(isHeart ? appAsset.iconHeartPress : appAsset.iconHeart, height: 30, fit: BoxFit.cover,)
                                    );
                                  }
                                ),
                                const SizedBox(width: 20,),
                                Image.asset(appAsset.iconDownload, color: Colors.white, height: 30,fit: BoxFit.cover)
                              ],
                            ),
                            const SizedBox(height: 20,),
                            const Divider(color: appColor.darkGrey,),
                            GestureDetector(
                              onTap: () => showModelbottomSheetArtist(context, widget.mv.artists!),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: widget.mv.artists!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: NetworkImage(widget.mv.artists![index].thumbnail!)
                                            )
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: SizedBox(
                                      height: 20,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: widget.mv.artists!.length,
                                        itemBuilder: (context, index) {
                                          return  Text(index == widget.mv.artists!.length - 1 ? widget.mv.artists![index].name! : "${widget.mv.artists![index].name!}, ", 
                                          overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                          );
                                        },
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                            const Divider(color: appColor.darkGrey,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Xem Tiếp",
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    const Text("Tự Động Phát",
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    CupertinoSwitch(
                                      activeColor: Colors.blue,
                                      value: isSwith, 
                                      onChanged: (bool){
                                        setState(() {
                                        isSwith = bool;
                                        });
                                      }
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            SizedBox(
                              height: widget.mv.recommends!.length * 120,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.mv.recommends!.length,
                                itemBuilder: (context, index) {
                                  return ContainerMV(
                                    mv: widget.mv.recommends![index], 
                                    symmetric: Axis.horizontal, 
                                    onTap: (){
                                      _getInfo.add(getInfoVideoEvent(encodeId: widget.mv.recommends![index].encodeId!));
                                    }
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            )
        ),
      )
    );
    
  }

  void showModelbottomSheetArtist(BuildContext context, List<Artist> artists){
    showModalBottomSheet(
      context: context, 
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: artists.length == 1 ? 0.2 : artists.length * 0.15,
          child: Container(
            decoration: const BoxDecoration(
              gradient: gradient.defaultGradientBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Center(
                    child: Container(
                      height: 5,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    )
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: artists.length * 80,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: artists.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            containerItemArtist(
                              artist: artists[index],
                              ontap: (){
                                _getInfo.add(getInfoArtistEvent(name: artists[index].alias!));
                              }, axis: Axis.horizontal,
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
          ),
        );
      },
    );
  }

}



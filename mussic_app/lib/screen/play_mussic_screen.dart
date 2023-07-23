
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/moduels/dowload/blocs/dowload_bloc.dart';
import 'package:mussic_app/moduels/dowload/events/dowload_event.dart';
import 'package:mussic_app/moduels/firebase/blocs/firebase_bloc.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/audioPlayer/bloc/audio_player_bloc.dart';
import 'package:mussic_app/moduels/audioPlayer/events/audio_player_event.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/Artist_profille_screen.dart';
import 'package:mussic_app/screen/login_screen.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/widget/container_item_artist.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';
import 'package:mussic_app/widget/dialo_erro.dart';

class playMussicScreen extends StatefulWidget {
   playMussicScreen({super.key});

  @override
  State<playMussicScreen> createState() => __playMusicState();
}

class __playMusicState extends State<playMussicScreen> {

  bool isHeart = false;
  bool isRepeate = false;
  bool isShuffle = false;
  bool isPlaying = false;
  bool isCompleted = false;
  bool isDowload = false;
  final _artistBloc = PlayMussicBloc();

  @override
  void initState() {
    // TODO: implement initState
    if(appState.isGetSongPlayed == false){
      appState.isGetSongPlayed = true;
      appState.audioBloc.add(audioPlayerSetMp3(song: appState.currentSong!, isGetSongPlayed: true));
    }else{
      appState.audioBloc.add(audioPlayerSetMp3(song: appState.currentSong!, isGetSongPlayed: false));
    }
    initSetupMussic();
    super.initState();
  }
  
  @override
  void dispose()async {
    // TODO: implement dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    appState.firebaseBloc.add(getLikeSongEvent(encodeId: appState.currentSong!.encodeId!));
    appState.dowLoadBloc.add(getIsDownLoad(song: appState.currentSong!));

    return appState.currentSong == null ? Container() :
     BlocListener(
      bloc: appState.audioBloc,
      listener: (context, state) {
        if(state is nextMussic) {
          setState(() {});
        }
    
        if(state is backMussic){
          setState(() {});
        }
      },
      child: Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: size.height/1.5,
                width: size.width,
                child: Image.network(appState.currentSong!.thumbnailM== null ? appState.currentSong!.thumbnail! : appState.currentSong!.thumbnailM!,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                  gradient: gradient.GradientPlayMussic
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 48,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            containerBack(context),
                            GestureDetector(
                              onTap: (){
                                showModalBottomSheetPlayList();
                              },
                              child: const  Icon(
                                Icons.playlist_play,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Center(
                        child: Container(
                          height: 300,
                          width: 300,
                          
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(appState.currentSong!.thumbnailM!),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 80),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appState.currentSong!.title!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        showModelbottomSheetArtist();
                                      },
                                      child: Text(
                                        appState.currentSong!.artistsNames!,
                                        style: const TextStyle(
                                            color: appColor.LightGray,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            BlocBuilder<DownLoadBloc, DownLoadState>(
                              bloc: appState.dowLoadBloc,
                              builder: (context, state) {
                                if(state.isDowload == false && state.isDowload != null){
                                  return GestureDetector(
                                    onTap: () async {
                                      if(await appDiaLog.showModalComfirm(context: context, tiltle: "Xác Nhận", subTitle: "Bạn có chắc muốn tải bài hát ${appState.currentSong!.title} về máy không ?")){
                                        appState.dowLoadBloc.add(DowloadSongEvent(song: appState.currentSong!));
                                      }
                                    },
                                    child: Image.asset(appAsset.iconDownload, color: Colors.white,),
                                  );
                                }else{
                                  return GestureDetector(
                                    onTap: () async {
                                      if(await appDiaLog.showModalComfirm(context: context, tiltle: "Xác Nhận", subTitle: "Bạn có chắc muốn xóa bài hát ${appState.currentSong!.title} ra khỏi máy không ?")){
                                        appState.dowLoadBloc.add(DeleteSongDownloadEvent(song: appState.currentSong!));
                                      }
                                    },
                                    child: Image.asset(appAsset.iconDownloaded, color: Colors.white,),
                                  );
                                }
                              }
                            ),
                            const SizedBox(width: 20,),
                            BlocBuilder<FirebaseBloc, FirebaseStata>(
                              bloc: appState.firebaseBloc,
                              builder: (context, state) {
                                if(state is LikeSongState){
                                  isHeart = state.isHeart;
                                }
                                return GestureDetector(
                                  onTap: () {
                                    if(appState.user != null){
                                      appState.firebaseBloc.add(LikeSongEvent(isHeart: isHeart, song: appState.currentSong!));
                                    }else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  const loginScreen(),));
                                    }
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    child: Image.asset(
                                      isHeart
                                          ? appAsset.iconHeartPress
                                          : appAsset.iconHeart,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                
                      BlocBuilder<AudioPlayerBloc, audiPlayerState>(
                        bloc: appState.audioBloc,
                        builder: (context, state) {
                          
                          if(state is audiPlayerState){
                  
                            if(state.isLoading == false && state.isPlaying == true && state.duration != null){
                              if(state.currentPosition! >= state.duration!){
                                appState.audioBloc.add(audioPlayerEventCompleted(isListMussic: appState.listSong == null ? false : true));
                              }
                              return Column(
                                children: [
                                  Slider(
                                    min: 0,
                                    max: state.duration!.inSeconds.toDouble(),
                                    onChanged: (value)  {
                                      appState.audioBloc.add(audioPlayerEventSeekPosition(duration: Duration(seconds: value.toInt()) ));
                                    },
                                    value: state.currentPosition!.inSeconds.toDouble(),
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.white30,
                                  ),
                  
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatTime(state.currentPosition!),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          formatTime(state.duration!),
                                          style: const TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                  
                            if(state.isLoading == false && state.isPlaying == false && state.duration != null){
                              return Column(
                                children: [
                                  Slider(
                                    min: 0,
                                    max: state.duration!.inSeconds.toDouble(),
                                    onChanged: (value)  {
                                      appState.audioBloc.add(audioPlayerEventSeekPosition(duration: Duration(seconds: value.toInt()) ));
                                    },
                                    value: state.currentPosition!.inSeconds.toDouble(),
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.white30,
                                  ),
                  
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatTime(state.currentPosition!),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          formatTime(state.duration!),
                                          style: const TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                  
                            if(state.erro != null){
                              return Center(child: CircularProgressIndicator(),);
                            }
                
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                  child: const LinearProgressIndicator(
                                      backgroundColor: Colors.white30,
                                      color: Colors.white,
                                    ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatTime(Duration.zero),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        formatTime(Duration.zero),
                                        style: const TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                
                          }
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                child: const LinearProgressIndicator(
                                    backgroundColor: Colors.white30,
                                    color: Colors.white,
                                  ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatTime(Duration.zero),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      formatTime(Duration.zero),
                                      style: const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            BlocBuilder<AudioPlayerBloc, audiPlayerState>(
                              bloc: appState.audioBloc ,
                              builder: (context, state) {
                                if(state is audiPlayerState){
                  
                                  if(state.isShuffle != null){
                                    isShuffle = state.isShuffle!;
                                  }
                                  return InkWell(
                                    onTap: () {
                                      appState.audioBloc.add(audioPlayerEventShuffle(isShuffle: !isShuffle));
                                    },
                                    child: isShuffle
                                        ? Image.asset(
                                            appAsset.iconShuffle,
                                            color: appColor.blue,
                                          )
                                        : Image.asset(
                                            appAsset.iconShuffle,
                                          ),
                                  );
                                }else{
                                  return InkWell(
                                    onTap: () {
                                      appState.audioBloc.add(audioPlayerEventShuffle(isShuffle: !isShuffle));
                                    },
                                    child: isShuffle
                                        ? Image.asset(
                                            appAsset.iconShuffle,
                                            color: appColor.blue,
                                          )
                                        : Image.asset(
                                            appAsset.iconShuffle,
                                          ),
                                  );
                                }
                            }),
                            const SizedBox(
                              height: 24,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      appState.audioBloc.add(audioPlayerEventBackMussic());
                                    },
                                    child: Image.asset(
                                        appAsset.iconPrevious),
                                  ),
                  
                                  BlocBuilder<AudioPlayerBloc, audiPlayerState>(
                                    bloc: appState.audioBloc,
                                    builder: (context, state) {
                                      if(state is audiPlayerState){
                                        if(state.isPlaying != null){
                                          isPlaying = state.isPlaying!;
                                        }
                                        if(state.isCompleted != null){
                                          isCompleted = state.isCompleted!;
                                        }
                                        return ContainerButton(
                                          height: 60,
                                          width: 60,
                                          radius: 30,
                                          child: Image.asset(
                                            isPlaying
                                                ? appAsset.iconPause
                                                : appAsset.iconPlay,
                                            height: 30,
                                          ),
                                          ontap: () {
                                            if(isCompleted == true){
                                              appState.audioBloc.add(audioPlayerEventSeekPosition(duration: Duration.zero));
                                              appState.audioBloc.add(audioPlayerEventPlayPause());
                                              isCompleted = false;
                                            }else{
                                            appState.audioBloc.add(audioPlayerEventPlayPause());
                                            }
                                          },
                                        );
                                      }else{
                                        return ContainerButton(
                                          height: 60,
                                          width: 60,
                                          radius: 30,
                                          child: Image.asset(
                                            isPlaying
                                                ? appAsset.iconPause
                                                : appAsset.iconPlay,
                                            height: 30,
                                          ),
                                          ontap: () {
                                            if(isCompleted == true){
                                              appState.audioBloc.add(audioPlayerEventSeekPosition(duration: Duration.zero));
                                              isCompleted = false;
                                            }else{
                                              appState.audioBloc.add(audioPlayerEventPlayPause());
                                            }
                                          },
                                        );
                                      }
                                    }
                                  ),
                  
                                  InkWell(
                                    onTap: (){
                                      appState.audioBloc.add(audioPlayerEventNextMussic());
                                    },
                                    child: Image.asset(appAsset.iconNext),
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<AudioPlayerBloc, audiPlayerState>(
                              bloc: appState.audioBloc,
                              builder: (context, state) {
                                if(state is audiPlayerState){
                                  if(state.isRepeate != null){
                                    isRepeate = state.isRepeate!;
                                  }
                                  return InkWell(
                                    onTap: () {
                                        appState.audioBloc.add(audioPlayerEventRepeate(isRepeate: !isRepeate));
                                    },
                                    child: isRepeate
                                        ? Image.asset(
                                            appAsset.iconRepeate,
                                            color: appColor.blue,
                                          )
                                          
                                        : Image.asset(
                                            appAsset.iconRepeate),
                                  );
                                } else{
                                  return InkWell(
                                    onTap: () {
                                        appState.audioBloc.add(audioPlayerEventRepeate(isRepeate: !isRepeate));
                                    },
                                    child: isRepeate
                                        ? Image.asset(
                                            appAsset.iconRepeate,
                                            color: appColor.blue,
                                          )
                                          
                                        : Image.asset(
                                            appAsset.iconRepeate),
                                  );
                                }
                                
                              }
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  void initSetupMussic(){
    if(appState.listSong != null && appState.indexSong != null){
      if(appState.isShuffle == null){
        appState.listSongCompleted = appState.listSong!.sublist(0, appState.indexSong! + 1);
        appState.listSongNext = appState.listSong!.sublist(appState.indexSong! + 1, appState.listSong!.length);
      }else{
        isShuffle = appState.isShuffle!;
        appState.listSongCompleted.add(appState.listSong![appState.indexSong!]);
        appState.listSongNext = appState.listSong!.sublist(0);
        appState.listSongNext.removeAt(appState.indexSong!);
        appState.listSongNext.shuffle();
      }
    }
  }

  void showModelbottomSheetArtist(){
    showModalBottomSheet(
      context: context, 
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: appState.currentSong!.artists!.length == 1 ? 0.2 : appState.currentSong!.artists!.length * 0.15,
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
                  BlocListener<PlayMussicBloc, PlayMussicState>(
                    bloc: _artistBloc,
                    listener: (context, state) {
                      if(state.isLoading == true){
                        appDiaLog.ShowDialogLoading(context);
                      }
                      if(state.artist != null){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistProfileScreen(artist: state.artist!),));
                      }
                      if(state.erro != null){
                        Navigator.pop(context);
                        showDialogErro(context: context, erro: state.erro!);
                      }
                    },
                    child: SizedBox(
                      height: appState.currentSong!.artists!.length * 80,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appState.currentSong!.artists!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              containerItemArtist(
                                artist: appState.currentSong!.artists![index],
                                ontap: (){
                                  print(appState.currentSong!.artists![index].alias!);
                                  _artistBloc.add(getInfoArtistEvent(name: appState.currentSong!.artists![index].alias!));
                                }, axis: Axis.horizontal,
                              ),
                              const SizedBox(height: 10,)
                            ],
                          );
                        },
                      ),
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

  void showModalBottomSheetPlayList(){
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Container(
            decoration: const BoxDecoration(
              gradient: gradient.defaultGradientBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      appState.listSongCompleted.isEmpty ? 
                      ContainerListMussicNew(
                        song: appState.currentSong!, 
                        ontap: (){
                          appState.audioBloc.add(audioPlayerEventSeekPosition(duration: Duration.zero));
                        },
                      ) :
                      SizedBox(
                        height: appState.listSongCompleted.length * 70 ,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: appState.listSongCompleted.length,
                          itemBuilder: (context, index) {
                            return index != appState.listSongCompleted.length-1 ? Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ContainerListMussicNew(
                                    song: appState.listSongCompleted[index], 
                                    ontap: (){
                                      if(appState.listSongCompleted[index] == appState.currentSong){
                                       appState.audioBloc.add(audioPlayerEventSeekPosition(duration: Duration.zero));
                                      }else{
                                        appState.listSongNext.insertAll(0, appState.listSongCompleted.sublist(index+1));
                                        appState.listSongCompleted.removeRange(index+1, appState.listSongCompleted.length);
                                        Navigator.pop(context);
                                        setState(() {
                                          appState.currentSong = appState.listSongCompleted.last;
                                        });
                                        appState.audioBloc.add(audioPlayerSetMp3(song: appState.currentSong!, isGetSongPlayed: false));
                                      }
                                    },
                                  ) 
                                ),
                                const SizedBox(height: 10,),
                              ],
                            ) : Column(
                              children: [
                                Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      child: ContainerListMussicNew(
                                      song: appState.listSongCompleted[index], 
                                      ontap: (){
                                        if(appState.listSongCompleted[index] == appState.currentSong){
                                          appState.audioBloc.add(audioPlayerEventSeekPosition(duration: Duration.zero));
                                        }else{
                                          appState.listSongNext.insertAll(0, appState.listSongCompleted.sublist(index+1));
                                          appState.listSongCompleted.removeRange(index+1, appState.listSongCompleted.length);
                                          Navigator.pop(context);
                                          setState(() {
                                            appState.currentSong = appState.listSongCompleted.last;
                                          });
                                          appState.audioBloc.add(audioPlayerSetMp3(song: appState.currentSong!, isGetSongPlayed: false));
                                        }
                                      },
                                                                  ),
                                    ),
                                 ),
                                 const SizedBox(height: 10,)
                              ],
                            );
                          }
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text(
                          "Bài hát tiếp theo",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)
                        ),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        height: appState.listSongNext.length * 70 + 30,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: appState.listSongNext.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ContainerListMussicNew(
                                    song: appState.listSongNext[index], 
                                    ontap: (){
                                      appState.listSongCompleted.insertAll(appState.listSongCompleted.length, appState.listSongNext.sublist(0, index+1));
                                      appState.listSongNext.removeRange(0, index+1);
                                      Navigator.pop(context);
                                      setState(() {
                                        appState.currentSong = appState.listSongCompleted.last;
                                      });
                                     appState.audioBloc.add(audioPlayerSetMp3(song: appState.currentSong!, isGetSongPlayed: false));
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10,)
                              ],
                            );
                          }
                        )
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ),
        );
      },
    );
  }


  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}


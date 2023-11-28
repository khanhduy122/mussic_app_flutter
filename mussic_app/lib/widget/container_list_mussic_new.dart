import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/dowload/blocs/dowload_bloc.dart';
import 'package:mussic_app/moduels/dowload/events/dowload_event.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/login_screen.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/widget/container_item_artist.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';

class ContainerListMussicNew extends StatefulWidget {
  const ContainerListMussicNew({super.key, required this.song, required this.ontap, this.onLongPress, this.isUserPlayList});

  final Song song;
  final Function() ontap;
  final Function()? onLongPress;
  final bool? isUserPlayList;

  @override
  State<ContainerListMussicNew> createState() => _ContainerListMussicNewState();
}

class _ContainerListMussicNewState extends State<ContainerListMussicNew> {

  PlayMussicBloc getInfoArtist = PlayMussicBloc();
  bool isDowload = false;

  @override
  void initState() {
    // TODO: implement initState
    appState.dowLoadBloc.add(getIsDownLoad(song: widget.song));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<PlayMussicBloc, PlayMussicState>(
      bloc: getInfoArtist,
      listener: (context, state) {
        
      },
      child: BlocListener<DownLoadBloc, DownLoadState>(
          bloc: appState.dowLoadBloc,
          listener: (context, state) {
            if(state is DownloadSuccess){
              isDowload = true;
            }
          },
          child: InkWell(
              onLongPress: widget.onLongPress,
              onTap: widget.ontap,
              child: SizedBox(
                height: 60,
                width: size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.song.thumbnail!,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: imageProvider
                            )
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Image.asset(appAsset.iconMussicNote, color: Colors.grey,)
                        ),
                    ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.song.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(widget.song.artistsNames!,
                            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 13),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottonMoreSong(context);
                      },
                      child: const Icon(Icons.more_horiz_rounded, color: Colors.white,)
                    )
                  ],
                ),
              ),
            )
        )
    );
}


  void showModalBottonMoreSong(BuildContext context){
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: appColor.primaryColor,
      context: context, 
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.35,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.song.thumbnail!,
                      fadeInDuration:  Duration.zero,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(10)
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10,),
                    Text(widget.song.title!,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                const Divider(height: 5, color: Colors.grey,),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    if(appState.user != null){
                      showModalBottomSheetChoosePlayList(context);
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.playlist_add, color: Colors.white,),
                      SizedBox(width: 10,),
                      Text("Thêm vào playlist",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),

                InkWell(
                  onTap: () {
                    showModelbottomSheetArtist();
                  },
                  child: Row(
                    children: [
                      Image.asset(appAsset.iconArtist, color: Colors.white,),
                      const SizedBox(width: 10,),
                      const Text("Nghệ Sĩ",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),

                BlocBuilder<DownLoadBloc, DownLoadState>(
                  bloc: appState.dowLoadBloc,
                  builder: (context, state) {
                    if(state.isDowload != null){
                      isDowload = state.isDowload!;
                    }
                    return InkWell(
                      onTap: () async {
                        if(await appDiaLog.showModalComfirm(context: context, tiltle: "Xác Nhận", subTitle: "Bạn có chắc muốn tải bài hát \"${widget.song.title}\" về máy không ?")){
                          appState.dowLoadBloc.add(DowloadSongEvent(song: widget.song));
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset( isDowload ? appAsset.iconDownloaded : appAsset.iconDownload, color: Colors.white,),
                          const SizedBox(width: 10,),
                          const Text("Tải nhạc",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    );
                  }
                ),
                const SizedBox(height: 20,),

              ],
            ),
          ),
       );
      },
    );
  }

  void showModalBottomSheetChoosePlayList(BuildContext context){
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: appColor.primaryColor,
      context: context, 
      builder: (context) {
        return FractionallySizedBox(
          heightFactor:  0.8,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const Center(
                      child: Text("Chọn playlist để thêm bài hát",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () {
                        appDiaLog.showModuelBottonNewPlaylist(context);
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(left: 10),
                            child: Image.asset(appAsset.iconAdd, color: Colors.blue,),
                          ),
                          const SizedBox(width: 10,),
                          const Text("Tạo PlayList",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    StreamBuilder(
                      stream: FirebaseRepo.getAllUserPlayList(),
                      builder: (context, snapshot) {
                        if(snapshot.hasError){
                          return  const Center(child: Icon(Icons.refresh));
                        }else{
                          if(snapshot.hasData){
                            final data = snapshot.data!.docs;
                            List<PlayList> listUserPlaylist = data.map((e) => PlayList.fromJsonFirebase(e.data())).toList();
                            return SizedBox(
                              height: listUserPlaylist.length * 60,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listUserPlaylist.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ContainerPlayListHot(
                                        playList: listUserPlaylist[index], 
                                        axis: Axis.horizontal, 
                                        ontap: () {
                                          FirebaseRepo.addSongToUserPlayList(song: widget.song, playList: listUserPlaylist[index]);
                                          appDiaLog.ToastNotifi(title: "Đã thêm bài hát vào ${listUserPlaylist[index].title}");
                                          Navigator.pop(context);

                                        }, 
                                        width: 50, 
                                        height: 50
                                      ),
                                      const SizedBox(height: 10,)
                                    ],
                                  );
                                },
                              ),
                            );
                          }else{
                            return Container();
                          }
                        }
                      },
                    )
                  ],
                ),
              );
            }
          ),
        );
      },
    );
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
                  SizedBox(
                    height: widget.song.artists!.length * 80,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.song.artists!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            containerItemArtist(
                              artist: widget.song.artists![index],
                              ontap: (){
                                getInfoArtist.add(getInfoArtistEvent(name: widget.song.artists![index].alias!));
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
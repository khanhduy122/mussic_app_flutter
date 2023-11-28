import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/search.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/Artist_profille_screen.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/screen/play_mv_screen.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/widget/container_item_artist.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';
import 'package:mussic_app/widget/container_mv_.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';
import 'package:mussic_app/widget/dialo_erro.dart';


class ResultSearchScreen extends StatefulWidget {
  const ResultSearchScreen({super.key, required this.keySearch, required this.search});

  final String keySearch;
  final Search search;

  @override
  State<ResultSearchScreen> createState() => _ResultSearchScreenState();
}

class _ResultSearchScreenState extends State<ResultSearchScreen> {
  
    final PlayMussicBloc _getInfo = PlayMussicBloc();
    final PageController _pageControllerMV = PageController(viewportFraction: 0.9);
    final _getInfoArtistBloc = PlayMussicBloc();


  @override
  Widget build(BuildContext context) {

    return BlocListener<PlayMussicBloc, PlayMussicState>(
      bloc: _getInfoArtistBloc,
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
      child: BlocListener<PlayMussicBloc, PlayMussicState>(
          bloc: _getInfo,
          listener: (context, state) {
            if(state.isLoading == true){
              appDiaLog.ShowDialogLoading(context);
            }
    
            if(state.playList != null){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListScreen(playList: state.playList!),));
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
              body: DefaultTabController(
                length: 5,
                child: Column(
                  children: [
                    const SizedBox(height: 48,),
                    Container(
                      margin: const  EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          containerBack(context,),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                margin: const  EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: appColor.darkGrey,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(widget.keySearch,
                                          style: const TextStyle(color: Colors.white, fontSize: 16),
                                        )
                                      )
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Image.asset(appAsset.iconSeach, color: appColor.LightGray,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24,),
                    const SizedBox(
                      child: TabBar(
                        tabs: [
                          Tab(
                            child: Text('Nổi Bật',
                              style: TextStyle(color: Colors.white, fontSize: 10, ),
                            ),
                          ),
                          Tab(
                            child: Text('Bài Hát',
                              style: TextStyle(color: Colors.white, fontSize: 10,),
                            ),
                          ),
                          Tab(
                            child: Text('Nghệ Sĩ',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                          Tab(
                            child: Text('Playlist',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                          Tab(
                            child: Text('MV',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          )
                        ],
                        
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          allResultSearch(widget.search, _pageControllerMV),
                          AllSongs(widget.search),
                          AllArtist(widget.search),
                          AllPlaylist(widget.search),
                          allMV(widget.search),
                        ]
                      ),
                    )
                  ],
                ),
              )
            )
        )
    );
  }
  Widget allResultSearch(Search search, PageController pageController){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          search.topArtist != null || search.topPlaylist != null || search.topPlaylist != null ? 
          GestureDetector(
            onTap: (){
              if(search.topArtist != null){
                _getInfoArtistBloc.add(getInfoArtistEvent(name: search.topArtist!.alias!));
              }else{
                if(search.topPlaylist != null){
                  _getInfo.add(getInfoPlayListEvent(encodeId: search.topPlaylist!.encodeId! ));
                }else{
                  appState.currentSong = search.topSong!;
                  appState.listSong = null;
                  appState.indexSong = null;
                  appState.isShuffle = null;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                }
              }
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: appColor.darkGrey,
                borderRadius: BorderRadius.circular(10)
              ),
              child: search.topArtist == null && search.topPlaylist == null && search.topPlaylist == null ? null : 
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          search.topArtist != null ? search.topArtist!.thumbnail!
                          : search.topPlaylist != null ? search.topPlaylist!.thumbnail! : search.topSong!.thumbnail!
                        ),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.circular(search.topArtist != null ? 40 : 10)
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          search.topSong != null ? 'Bài Hát' 
                          : search.topArtist != null ? 'Nghệ Sĩ' : 'PlayList',
                          style: const TextStyle(color: Colors.white, fontSize: 12), 
                        ),
                        Text(
                          search.topSong != null ? search.topSong!.title! 
                          : search.topArtist != null ? search.topArtist!.name!
                          : search.topPlaylist!.title!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), 
                        ),
                        Text(
                          search.topSong != null ? search.topSong!.artistsNames! 
                          : search.topArtist != null ?
                          (search.artists![0].totalFollow!.toString().length >= 4 && search.artists![0].totalFollow.toString().length < 7 ? '${search.artists![0].totalFollow! ~/ 1000}K Quan Tâm' : search.artists![0].totalFollow!.toString().length < 4 ? '${search.artists![0].totalFollow}Quan Tam' :  '${(search.artists![0].totalFollow! / 1000000).toStringAsFixed(1)}M Quan Tâm')
                          : search.topPlaylist!.artistsNames!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), 
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ) : Container(),
    
          search.songs != null ? const SizedBox(height: 24,) : Container(),
          search.songs != null ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'Bài Hát',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ) : Container(),
          search.songs != null ? const SizedBox(height: 10,) : Container(),
          search.songs != null ? SizedBox(
            height: search.songs!.length * 70,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: search.songs!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ContainerListMussicNew(
                      song: search.songs![index],
                      ontap: (){
                        appState.currentSong = search.songs![index];
                        appState.listSong = search.songs!.sublist(0);
                        appState.indexSong = index;
                        appState.isShuffle = null;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                      },
                    ),
                    const SizedBox(height: 10,)
                  ],
                );
              },
            ),
          ) : Container(),
    
          search.playlists != null ? const SizedBox(height: 24,) : Container(),
          search.playlists != null ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'PlayList / Album',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ) : Container(),
          search.playlists != null ? const SizedBox(height: 10,) : Container(),
          search.playlists != null ? Container(
            height: 160,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: search.playlists!.length > 10 ? 10 : search.playlists!.length,
              itemBuilder: (context, index) {
                return ContainerPlayListHot(
                  height: 130,
                  width: 130,
                  playList: search.playlists![index], 
                  axis: Axis.vertical,
                  ontap: (){
                    _getInfo.add(getInfoPlayListEvent(encodeId: search.playlists![index].encodeId!));
                  },
                );
              },
            ),
          ) : Container(),
    
          search.videos != null ? const SizedBox(height: 24,) : Container(),
          search.videos != null ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'MV',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ) : Container(),
          search.videos != null ? const SizedBox(height: 10,) : Container(),
          search.videos != null ? SizedBox(
            height: 300,
            child: PageView.builder(
              controller: pageController,
              itemCount: search.videos!.length,
              itemBuilder: (context, index) {
                return ContainerMV(
                  onTap: (){
                    _getInfo.add(getInfoVideoEvent(encodeId: search.videos![index].encodeId!));
                  },
                  mv: search.videos![index], 
                  symmetric: Axis.vertical,
                );
              },
            ),
          ) : Container(),
    
          search.artists != null ? const SizedBox(height: 24,) : Container(),
          search.artists != null ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'Nghệ Sĩ',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ) : Container(),
          search.artists != null ? const SizedBox(height: 10,) : Container(),
          search.artists != null ? Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: search.artists!.length,
              itemBuilder: (context, index) {
                return containerItemArtist(
                  artist: search.artists![index],
                  ontap: (){
                    _getInfoArtistBloc.add(getInfoArtistEvent(name: search.artists![index].alias!));
                  }, 
                  axis: Axis.vertical,
                );
              },
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget AllSongs(Search search){
    return search.songs != null ? SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20,),
          SizedBox(
            height: search.songs!.length * 70,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: search.songs!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ContainerListMussicNew(
                      song: search.songs![index],
                      ontap: (){
                        appState.currentSong = search.songs![index];
                        appState.listSong = search.songs!.sublist(0);
                        appState.indexSong = index;
                        appState.isShuffle = null;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                      },
                    ),
                    const SizedBox(height: 10,),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ) : const Center(
      child:  Text(
        'Trống',
        style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget AllPlaylist(Search search){
    return search.playlists != null ? 
    SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20,),
          SizedBox(
            height: search.playlists!.length * 70,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: search.playlists!.length,
              itemBuilder: (context, index) {
                return ContainerPlayListHot(
                  height: 70,
                  width: 70,
                  playList: search.playlists![index], 
                  axis: Axis.horizontal,
                  ontap: (){
                    _getInfo.add(getInfoPlayListEvent(encodeId: search.playlists![index].encodeId!));
                  },
                );
              },
            ),
          ),
        ],
      ),
    ) : const Center(
      child: Text(
        'Trống',
        style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget allMV(Search search ){
    return search.videos != null ?
    SingleChildScrollView(
      child: Container(
        height: search.videos!.length * 100,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: search.videos!.length,
          itemBuilder: (context, index) {
            return ContainerMV(
              onTap: (){
                _getInfo.add(getInfoVideoEvent(encodeId: search.videos![index].encodeId!));
              },
              mv: search.videos![index], 
              symmetric: Axis.vertical,
            );
          },
        ),
      ),
    ) : const Center(
      child: Text('Trống',
        style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget AllArtist(Search search){
    return search.artists != null ? 
    SizedBox(
      height: search.artists!.length * 60,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: search.artists!.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              containerItemArtist(
                artist: search.artists![index],
                ontap: () {
                  _getInfoArtistBloc.add(getInfoArtistEvent(name: search.artists![index].alias!));
                }, 
                axis: Axis.horizontal,
              ),
              const SizedBox(height: 10,)
            ],
          );
        },
      ),
    ) : const Center(
      child: Text(
        'Trống',
        style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
  
  



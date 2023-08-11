import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/HomeData.dart';
import 'package:mussic_app/model/exceptions.dart';
import 'package:mussic_app/moduels/homeItem/blocs/get_chart_bloc.dart';
import 'package:mussic_app/moduels/homeItem/blocs/get_home_data_bloc.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/new_release_chart.dart';
import 'package:mussic_app/screen/new_release_sceen.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/screen/search_screen.dart';
import 'package:mussic_app/screen/top100_screen.dart';
import 'package:mussic_app/screen/zing_charts.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';
import 'package:mussic_app/widget/container_list_top_music.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';
import 'package:mussic_app/widget/container_home_screen_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/widget/dialo_erro.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.homeData});

  final HomeData homeData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  int _currenIndexIndicator = 0;
  int indexTabNew = 0;
  late Timer _timer;
  final PageController _pageControllerTabViewNew = PageController(initialPage: 0, viewportFraction: 0.9);
  final PageController _pageControllerBanner = PageController(initialPage: 0);
  final StreamController<int> streamCtlrIndicator = StreamController<int>();
  final StreamController<int> streamCtlrTabnew = StreamController<int>();

  final _playMussicBloc = PlayMussicBloc();
  final _getChart = GetChartBloc();
  final _homeDataBloc = getHomeDataBloc();


  @override
  void initState() {
    _homeDataBloc.add(getHomeDataEvent());
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currenIndexIndicator < widget.homeData.banner!.items!.length-1) {
        _currenIndexIndicator ++;
        _pageControllerBanner.animateToPage(_currenIndexIndicator,
            duration:const Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        _currenIndexIndicator = 0;
        _pageControllerBanner.jumpToPage(0);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageControllerBanner.dispose();
    _pageControllerTabViewNew.dispose();
    streamCtlrIndicator.close();
    streamCtlrTabnew.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: BlocListener<GetChartBloc, GetChartState>(
          bloc: _getChart,
          listener: (context, state) {
            if(state.isLoaded == true){
              appDiaLog.ShowDialogLoading(context);
            }
            if(state.chart != null){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ZingCharts(chart: state.chart!,),));
            }

            if(state.top100 != null){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Top100Screen(top100s: state.top100!,),));
            }

            if(state.newReleaseChart != null){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewReleaseChartScreen(songs: state.newReleaseChart!,),));
            }

            if(state.erro != null){
              Navigator.pop(context);
              showDialogErro(context: context, erro: state.erro!);
            }
          },
         child: BlocListener<PlayMussicBloc, PlayMussicState>(
              bloc: _playMussicBloc,
              listener: (context, state) async {
                final isLoading = state.isLoading;
                if(isLoading == true){
                  appDiaLog.ShowDialogLoading(context);
                }
        
                final song = state.song;
                if(song != null){
                  appState.currentSong = state.song!;
                  appState.listSong = null;
                  appState.isShuffle = null;
                  appState.indexSong = null;
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                }
        
                final playList = state.playList;
                if(playList != null){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListScreen(playList: playList),));
                }
        
                final erro = state.erro;
                if(erro != null){
                  if(erro is NoIntenetException){
                    Navigator.pop(context);
                    appDiaLog.showDialogNotify(content: "Vui lòng kiểm tra kết nối mạng", context: context);
                  }
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen(),));
                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: appColor.darkGrey,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(left: 20),
                              child: const Text(
                                'Tìm kiếm bài hát, nghệ sĩ, playlist',
                                style: TextStyle(color: appColor.LightGray, fontSize: 14),
                              ),
                            ),
                            Container(
                              height: 40,
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Image.asset(appAsset.iconSeach, color: appColor.LightGray,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 200,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageControllerBanner,
                            itemCount: widget.homeData.banner!.items!.length,
                            onPageChanged: (index) {
                              _currenIndexIndicator = index;
                              streamCtlrIndicator.sink.add(_currenIndexIndicator);
                            },
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  if(widget.homeData.banner!.items![index].type == 1){
                                    _playMussicBloc.add(getInfoSong(encodeId: widget.homeData.banner!.items![index].encodeId!));
                                  }else{
                                    if(widget.homeData.banner!.items![index].type == 4){
                                      _playMussicBloc.add(getInfoPlayListEvent(encodeId: widget.homeData.banner!.items![index].encodeId!));
                                    }
                                  }
                                },
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(widget.homeData.banner!.items![index].banner!),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(10)),
                                )
                              );
                            },
                          ),
                          Center(
                            child: StreamBuilder<int>(
                              stream: streamCtlrIndicator.stream,
                              initialData: 0,
                              builder: (_, snapshot) {
                                return Container(
                                  height: 6,
                                  width: widget.homeData.banner!.items!.length * 20,
                                  margin: const EdgeInsets.only(top: 180),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.homeData.banner!.items!.length,
                                    itemBuilder: (context, index) {
                                      return Indicator(index == snapshot.data);
                                    },
                                  ),
                                );
                              }
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ContainerHomeWidget(
                            icon: appAsset.iconCharts,
                            title: 'BXH',
                            ontap: (){
                              _getChart.add(GetChartBXHEvent());
                            },
                          ),
                          ContainerHomeWidget(
                            icon: appAsset.iconTop100,
                            title: 'Top 100',
                            ontap: (){
                              _getChart.add(GetTop100Event());
                            },
                          ),
                          ContainerHomeWidget(
                            icon: appAsset.iconMussicNote,
                            title: 'Nhạc Mới',
                            ontap: (){
                              _getChart.add(GetNewReleaseChartEvent());
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewReleaseScreen(newRelease: widget.homeData.newRelease!),));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Row(
                          children:  [
                            Text("Nhạc Mới Phát Hành",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.navigate_next, color: Colors.white, size: 25)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    StreamBuilder<int>(
                      stream: streamCtlrTabnew.stream,
                      builder: (context, snapshot) {
                        return Container(
                          height: 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  indexTabNew = 0;
                                  _pageControllerTabViewNew.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                },
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  margin: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:  indexTabNew == 0 ? appColor.LinearGradient1 : appColor.darkGrey,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: const Text("ALL",
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                )
                              ),
                              GestureDetector(
                                onTap: (){
                                  indexTabNew = 1;
                                  _pageControllerTabViewNew.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                },
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  margin: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: indexTabNew == 1 ? appColor.LinearGradient1 : appColor.darkGrey,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: const Text("Việt Nam",
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                )
                              ),
                              GestureDetector(
                                onTap: (){
                                  indexTabNew = 2;
                                  _pageControllerTabViewNew.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                },
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  margin: const EdgeInsets.only(left: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: indexTabNew == 2 ? appColor.LinearGradient1 : appColor.darkGrey,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: const Text("Quốc Tế",
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                )
                              ),
                            ],
                          ),
                        );
                      }
                    ),
        
                    const SizedBox(height: 10,),
        
                    SizedBox(
                      height: 300,
                      width: size.width,
                      child: PageView(
                        controller: _pageControllerTabViewNew,
                        onPageChanged: (index) {
                          indexTabNew = index;
                          streamCtlrTabnew.sink.add(indexTabNew);
                        },
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ContainerListMussicNew(
                                      song: widget.homeData.newRelease!.itemNewRelease!.allSongs![index], 
                                      ontap: () async {
                                        appState.currentSong = widget.homeData.newRelease!.itemNewRelease!.allSongs![index];
                                        appState.listSong = null;
                                        appState.isShuffle = null;
                                        appState.indexSong = null;
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                                      }, 
                                    ),
                                    const SizedBox(height: 10,)
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ContainerListMussicNew(
                                      song:  widget.homeData.newRelease!.itemNewRelease!.vpop![index],
                                      ontap: (){
                                        appState.currentSong = widget.homeData.newRelease!.itemNewRelease!.vpop![index];
                                        appState.listSong = null;
                                        appState.isShuffle = null;
                                        appState.indexSong = null;
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                                      }, 
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ContainerListMussicNew(
                                      song:  widget.homeData.newRelease!.itemNewRelease!.other![index], 
                                      ontap: (){
                                        appState.currentSong = widget.homeData.newRelease!.itemNewRelease!.other![index];
                                        appState.listSong = null;
                                        appState.isShuffle = null;
                                        appState.indexSong = null;
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                                      }, 
                                    ),
                                    const SizedBox(height: 10,)
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ),
        
                    const SizedBox(height: 20,),
                    Container(
                      height: widget.homeData.chartSong!.listSongChart!.length * 80 + 10,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: appColor.darkGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          const Text("#ZingChart",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            height: widget.homeData.chartSong!.listSongChart!.length* 60,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.homeData.chartSong!.listSongChart!.length,
                              itemBuilder: (context, index) {
                                return ContainerTopMussic(
                                  ontap: (){
                                    appState.currentSong = widget.homeData.chartSong!.listSongChart![index];
                                    appState.listSong = null;
                                    appState.indexSong = null;
                                    appState.isShuffle = null;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen()));
                                  },
                                  song: widget.homeData.chartSong!.listSongChart![index],
                                  position: index+1,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),
                          GestureDetector(
                            onTap: (){
                              _getChart.add(GetChartBXHEvent());
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
                          )
                        ],
                      ),
                    ),
        
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: widget.homeData.playlists!.length * 200,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.homeData.playlists!.length,
                        itemBuilder: (context, indexPlayList) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(widget.homeData.playlists![indexPlayList].title!,
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.homeData.playlists![indexPlayList].listPlayList!.length,
                                  itemBuilder: (context, index) {
                                    return ContainerPlayListHot(
                                      playList: widget.homeData.playlists![indexPlayList].listPlayList![index], 
                                      axis: Axis.vertical, 
                                      ontap: (){
                                        print("add getPlaylist");
                                        _playMussicBloc.add(getInfoPlayListEvent(encodeId: widget.homeData.playlists![indexPlayList].listPlayList![index].encodeId!));
                                      }, 
                                      width: 120, 
                                      height: 120
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            )
        ),
      ),
    );
  }

}

Widget Indicator(bool isActive) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    height: 6,
    width: isActive ? 15 : 6,
    decoration: isActive
        ? BoxDecoration(
            color: appColor.blue, borderRadius: BorderRadius.circular(5))
        : BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3))
  );
}



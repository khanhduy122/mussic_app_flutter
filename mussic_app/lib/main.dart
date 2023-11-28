import 'dart:async';
import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/exceptions.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/homeItem/blocs/get_home_data_bloc.dart';
import 'package:mussic_app/screen/erro_screen.dart';
import 'package:mussic_app/screen/home_screen.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/screen/splash_screen.dart';
import 'package:mussic_app/screen/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: appColor.primaryColor,
        scaffoldBackgroundColor: appColor.primaryColor
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

  int indexScreen = 0;
  late AnimationController _animationController;
  final _homeDataBloc = getHomeDataBloc();


  Future<void> getSongPlayed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(appState.isGetSongPlayed == false ){
      if(prefs.getString(appKey.songPlayed) != null){
        appState.currentSong =  Song.fromJson(jsonDecode(prefs.getString(appKey.songPlayed)!));
      }
    }
  }

  @override
  void initState() {
    if(appState.user != null){
      FirebaseRepo.getCurrentUserProfile();
    }
    _homeDataBloc.add(getHomeDataEvent());
    getSongPlayed();
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    appState.streamCurrentSong.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => appDiaLog.showDialogComfirmAndroid(context: context, 
      tiltle: "Xác Nhận", 
      subTitle: "Bạn có chắc muốn thoát khỏi ứng dụng"
      ),
      child: BlocBuilder<getHomeDataBloc, getHomeDataState>(
        bloc: _homeDataBloc,
        builder: (context, state) {
          if(state.homedata != null){
            appState.currentSong ??= state.homedata!.chartSong!.listSongChart![0];
            return Scaffold(
              body: IndexedStack(
                index: indexScreen,
                children: [
                  HomeScreen(homeData: state.homedata!,),
                  playMussicScreen(),
                  const UserScreen()
                ],
              ),
                bottomNavigationBar: ConvexAppBar(
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.blue,
                initialActiveIndex: 0,
                style: TabStyle.fixed,
                onTap: (index){
                  setState(() {
                    indexScreen = index;
                  });
                },
                items: [
                  TabItem(
                    icon: indexScreen != 0 ? Image.asset(appAsset.iconHome, color: Colors.white, height: 60,) : Image.asset(appAsset.iconHome, height: 60),
                  ),
                  TabItem(
                    icon: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                      child: StreamBuilder(
                        stream: appState.streamCurrentSong.stream,
                        builder: (context, snapshot) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(
                                image: NetworkImage(appState.currentSong!.thumbnail!),
                                fit: BoxFit.cover
                              )
                            ),
                          );
                        }
                      ),
                    )
                  ),
                  TabItem(
                    icon: indexScreen != 2 ? Image.asset(appAsset.iconUser, color: Colors.white,) : Image.asset(appAsset.iconUser,),
                  ),
                ],
              ),
            );
          }
          if(state.erro != null){
            if(state.erro is NoIntenetException){
              return Scaffold(
                body: IndexedStack(
                  index: indexScreen,
                  children: [
                    ErroScreen(
                      onTapRefresh: () {
                        appDiaLog.ShowDialogLoading(context);
                        _homeDataBloc.add(refreshGetHomeDataEvent(context: context));
                      },
                    ),
                    ErroScreen(
                      onTapRefresh: () {
                        _homeDataBloc.add(refreshGetHomeDataEvent(context: context));
                      },
                    ),
                    const UserScreen()
                  ],
                ),
                  bottomNavigationBar: ConvexAppBar(
                  backgroundColor: Colors.black,
                  color: Colors.white,
                  activeColor: Colors.blue,
                  initialActiveIndex: 0,
                  style: TabStyle.fixed,
                  onTap: (index){
                    setState(() {
                      indexScreen = index;
                    });
                  },
                  items: [
                    TabItem(
                      icon: indexScreen != 0 ? Image.asset(appAsset.iconHome, color: Colors.white, height: 60,) : Image.asset(appAsset.iconHome, height: 60),
                    ),
                    TabItem(
                      icon: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: gradient.GradientButtonPlay
                        ),
                        child: Image.asset(appAsset.iconPlay, height: 20, fit: BoxFit.cover,)
                      )
                    ),
                    TabItem(
                      icon: indexScreen != 2 ? Image.asset(appAsset.iconUser, color: Colors.white,) : Image.asset(appAsset.iconUser,),
                    ),
                  ],
                ),
              );
            }
          }
    
          return const SplashScreen();
          
        }
      ),
    );
  }
}



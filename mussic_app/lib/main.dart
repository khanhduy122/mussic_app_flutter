import 'dart:async';
import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/homeItem/blocs/get_home_data_bloc.dart';
import 'package:mussic_app/screen/home_screen.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/screen/splash_screen.dart';
import 'package:mussic_app/screen/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        backgroundColor: appColor.primaryColor,
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
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(appState.isGetSongPlayed == false ){
      if(_prefs.getString(appKey.songPlayed) != null){
        appState.currentSong =  Song.fromJson(jsonDecode(_prefs.getString(appKey.songPlayed)!));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if(appState.user != null){
      FirebaseRepo.getCurrentUserProfile();
    }
    _homeDataBloc.add(getHomeDataEvet());
    getSongPlayed();
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 5))..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    appState.streamCurrentSong.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => appDiaLog.showDialogComfirmAndroid(context: context, tiltle: "Xác Nhận", subTitle: "Bạn có chắc muốn thoát khỏi ứng dụng"),
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
            return Center(child: Text(state.erro.toString()),);
          }
    
          return const SplashScreen();
          
        }
      ),
    );
  }
}



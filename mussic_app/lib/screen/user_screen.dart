import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/moduels/firebase/blocs/firebase_bloc.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/moduels/firebaseAuth/blocs/firebase_auth_bloc.dart';
import 'package:mussic_app/moduels/firebaseAuth/events/firebase_auth_event.dart';
import 'package:mussic_app/screen/dowload_screen.dart';
import 'package:mussic_app/screen/edit_name_screen.dart';
import 'package:mussic_app/screen/followers_screen.dart';
import 'package:mussic_app/screen/like_screen.dart';
import 'package:mussic_app/screen/login_screen.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/screen/recent_screen.dart';
import 'package:mussic_app/screen/user_play_list_screen.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_item_user_screen.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                        Color.fromARGB(255, 43, 23, 106),
                        appColor.primaryColor,
                        ]
                      )
                    ),
                    child: BlocBuilder<FirebaseAuthBloc, FirebaseAuthState>(
                      bloc: appState.authBloc,
                      builder: (context, state) {

                        return BlocBuilder<FirebaseBloc, FirebaseStata>(
                          bloc: appState.firebaseBloc,
                          builder: (context, state) {
                            if(appState.user != null){
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Stack(
                                        children: [
                                          appState.userProfile!.avatar == appAsset.iconUser ?
                                          Container(
                                          height: 100,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(appAsset.iconAvataUser),
                                                fit: BoxFit.cover
                                              )
                                            ),
                                          ) : CachedNetworkImage(
                                            imageUrl: appState.userProfile!.avatar!,
                                            fadeOutDuration: const Duration(seconds: 0),
                                            fadeInDuration: const Duration(seconds: 0),
                                            imageBuilder: (context, imageProvider) => Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                    fit: BoxFit.cover
                                                  )
                                                ),
                                              )
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                appState.firebaseBloc.add(updateAvatarUserEvent(context: context));
                                              },
                                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 25,)
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Text(
                                              appState.userProfile!.name!,
                                              style: const TextStyle(
                                                  color: appColor.LightGray,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditNameScreen()));
                                            },
                                            child: const Icon(Icons.edit, color: Colors.white, size: 25,)
                                          )
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    child: Image.asset(appAsset.iconAvataUser),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.symmetric(vertical: 20),
                                      child: const Text(
                                        'Bạn chưa đăng nhập',
                                        style: TextStyle(
                                            color: appColor.LightGray,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  ContainerButton(
                                    height: 50,
                                    width: 150,
                                    radius: 20,
                                    ontap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                                    },
                                    child: const Text('Đăng Nhập',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        );
                      }
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 24,
                    child: BlocBuilder<FirebaseAuthBloc, FirebaseAuthState>(
                      bloc: appState.authBloc,
                      builder: (context, state) {
                        if(appState.user != null){
                          return GestureDetector(
                            onTap: () async {
                              appState.authBloc.add(LogoutEvent(context: context));
                            },
                            child: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                          );
                        }
                        return Container();
                        
                      },
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ContainerItemUserScreen(
                        icon: appAsset.iconFollowers, tiltle: 'Theo Dõi',
                        ontap: () {
                          if(appState.user != null){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FollowersScreen(),));
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                          }
                        },
                    ),
                    ContainerItemUserScreen(
                        icon: appAsset.imgDowload, tiltle: 'Dowload',
                        ontap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DowloadScreen(),));
                        },
                    ),
                    ContainerItemUserScreen(
                        icon: appAsset.imgRecent, tiltle: 'Gần Đây',
                        ontap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RecentScreen(),));
                        },
                    ),
                    ContainerItemUserScreen(
                        icon: appAsset.iconUpload, tiltle: 'Tải Lên',
                        ontap: () {
                          if(appState.user != null){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const FollowersScreen(),));
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                          }
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: (){
                  if(appState.user != null){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LikeScreen(),));
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                  }
                },
                child: Container(
                  height: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: appColor.darkGrey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset(
                          appAsset.iconHeartPress,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Yêu Thích',
                          style: TextStyle(
                              color: appColor.LightGray,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Icon(
                          Icons.navigate_next,
                          color: appColor.LightGray,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              BlocBuilder(
                bloc: appState.authBloc,
                builder: (context, state) {
                  if(appState.user != null){
                    return StreamBuilder(
                      stream: FirebaseRepo.getAllUserPlayList(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          final data = snapshot.data!.docs;
                          final test = snapshot.data!.docs[0].get("listSong");
                          List<PlayList> userPlayLists = data.map((e) => PlayList.fromJsonFirebase(e.data())).toList();
                         
                          print("test ${test}");
                          return Container(
                            height: (userPlayLists.length * 80) + 80,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: appColor.darkGrey,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 10,),
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
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: userPlayLists.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          children: [
                                            ContainerPlayListHot(
                                              playList: userPlayLists[index], 
                                              axis: Axis.horizontal, 
                                              ontap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => UserPlayListScreen(playList: userPlayLists[index]),));
                                              }, 
                                              width: 70, 
                                              height: 70
                                            ),
                                            const SizedBox(height: 10,)
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                )
                              ],
                            ),
                          );
                        }else{
                          return Container(
                            height: 70,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: appColor.darkGrey,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if(appState.user != null){
                                  appDiaLog.showModuelBottonNewPlaylist(context);
                                }else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                                }
                                  
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
                          );
                        }
                      }
                    );
                  }else{
                    return Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: appColor.darkGrey,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if(appState.user != null){
                          appDiaLog.showModuelBottonNewPlaylist(context);
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen(),));
                          }
                            
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
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  
}

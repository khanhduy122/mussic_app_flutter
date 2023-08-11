import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/component/app_assets.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/moduels/firebase/blocs/firebase_bloc.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/firebaseAuth/blocs/firebase_auth_bloc.dart';
import 'package:mussic_app/moduels/firebaseAuth/events/firebase_auth_event.dart';
import 'package:mussic_app/screen/dowload_screen.dart';
import 'package:mussic_app/screen/edit_name_screen.dart';
import 'package:mussic_app/screen/followers_screen.dart';
import 'package:mussic_app/screen/like_screen.dart';
import 'package:mussic_app/screen/login_screen.dart';
import 'package:mussic_app/screen/recent_screen.dart';
import 'package:mussic_app/widget/container_button.dart';
import 'package:mussic_app/widget/container_item_user_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  final StreamController _controllerUser = StreamController<String>();

  @override
  void dispose() {
    _controllerUser.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            )
          ],
        ),
      ),
    );
  }
}

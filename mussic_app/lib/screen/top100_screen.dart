import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/app_color.dart';
import 'package:mussic_app/model/top100.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/widget/container_icon_arraw_back.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';

class Top100Screen extends StatelessWidget {
  const Top100Screen({super.key, required this.top100s});

  final List<Top100> top100s;

  @override
  Widget build(BuildContext context) {
    final PlayMussicBloc getInfoPlayList = PlayMussicBloc();
    return BlocListener<PlayMussicBloc, PlayMussicState>(
      bloc: getInfoPlayList,
      listener: (context, state) {
        if(state.isLoading == true){
          appDiaLog.ShowDialogLoading(context);
        }

        if(state.playList != null){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListScreen(playList: state.playList!),));
        }

        final erro = state.erro;
        if(erro != null){
          appDiaLog.ToastNotifi(title: "Lỗi");
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: appColor.primaryColor,
            centerTitle: true,
            title: const Text("Top100",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: containerBack(context),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: top100s.length * 130,
                  child: ListView.builder(
                    itemCount: top100s.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(top100s[index].title!,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 150 ,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: top100s[index].playLists!.length,
                              itemBuilder: (context, indexPlayList) {
                                return ContainerPlayListHot(
                                  playList: top100s[index].playLists![indexPlayList], 
                                  axis: Axis.vertical, 
                                  ontap: (){
                                    getInfoPlayList.add(getInfoPlayListEvent(encodeId: top100s[index].playLists![indexPlayList].encodeId! ));
                                  }, 
                                  width: 130, 
                                  height: 130
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
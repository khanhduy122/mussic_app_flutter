import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPlayListRecent extends StatefulWidget {
  const ListPlayListRecent({super.key});

  @override
  State<ListPlayListRecent> createState() => _ListPlayListRecentState();
}

class _ListPlayListRecentState extends State<ListPlayListRecent> {

  final List<PlayList> listPlayList = [];
  final PlayMussicBloc _getPlayList = PlayMussicBloc();

  @override
  void initState() {
    getplayListRecent();
    super.initState();
  }

  Future<void> getplayListRecent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listPlayListRecent = prefs.getStringList(appKey.listPlayListRecent) ?? [];
    for (var element in listPlayListRecent) {
      listPlayList.add(PlayList.fromJson(jsonDecode(element)));
    }
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayMussicBloc, PlayMussicState>(
      bloc: _getPlayList,
      listener: (context, state) {
        if(state.isLoading == true){
          appDiaLog.ShowDialogLoading(context);
        }
        if(state.playList != null){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayListScreen(playList: state.playList!),));
        }
      },
      child: SingleChildScrollView(
        child: Column(
            children: [
              const SizedBox(height: 20,),
              SizedBox(
                height: listPlayList.length * 90,
                child: ListView.builder(
                  itemCount: listPlayList.length,
                  itemBuilder: (context, index) {
                    return ContainerPlayListHot(
                      playList: listPlayList[index], 
                      axis: Axis.horizontal, 
                      ontap: ()  {
                        _getPlayList.add(getInfoPlayListEvent(encodeId: listPlayList[index].encodeId!));
                      }, 
                      width: 70, 
                      height: 70
                    );
                  },
                ),
              )
            ],
          ),
      )
    );
  }
}
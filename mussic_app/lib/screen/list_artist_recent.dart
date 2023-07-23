import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/widget/container_item_artist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListArtistRecent extends StatefulWidget {
  const ListArtistRecent({super.key});

  @override
  State<ListArtistRecent> createState() => _ListArtistRecentState();
}

class _ListArtistRecentState extends State<ListArtistRecent> {

  final List<Artist> listArtist = [];
  final PlayMussicBloc _getArtist = PlayMussicBloc();

  @override
  void initState() {
    // TODO: implement initState
    getListArtistRecent();
    super.initState();
  }

  Future<void> getListArtistRecent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listPlayListRecent = prefs.getStringList(appKey.listArtistRecent) ?? [];
    listPlayListRecent.forEach((element) {
      listArtist.add(Artist.fromJson(jsonDecode(element)));
    });
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        SizedBox(
          height: listArtist.length * 70,
          child: ListView.builder(
            itemCount: listArtist.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  containerItemArtist(
                    artist: listArtist[index], 
                    ontap: (){
                      _getArtist.add(getInfoArtistEvent(name: listArtist[index].alias!));
                    }, 
                    axis: Axis.horizontal
                  ),
                  const SizedBox(height: 10,)
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
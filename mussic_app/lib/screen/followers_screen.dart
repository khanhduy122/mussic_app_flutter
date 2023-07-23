import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/Artist_profille_screen.dart';
import 'package:mussic_app/widget/container_item_artist.dart';
import 'package:mussic_app/widget/dialo_erro.dart';

import '../widget/container_icon_arraw_back.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {

  final _artistBloc = PlayMussicBloc();
  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayMussicBloc, PlayMussicState>(
      bloc: _artistBloc,
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
      child: Scaffold(
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseRepo.getAllFollowArtist(),
                builder: (context, snapshot) {
                  if(snapshot.hasError == false){
                    if(snapshot.hasData){
                      final data = snapshot.data!.docs;
                      List<Artist> listArtistFollowed = data.map((e) => Artist.fromJson(e.data())).toList();
                      if(listArtistFollowed.isNotEmpty){
                        return Column(
                          children: [
                            const SizedBox(height: 24,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                containerBack(context),
                                const Icon(Icons.search, color: Colors.white,)
                              ],
                            ),
                            const SizedBox(height: 24,),
                            const Text('Nghệ Sĩ',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 24,),
                            Text('${listArtistFollowed.length} Nghệ Sĩ - Đã Quan tâm',
                              style: const TextStyle(color: Color.fromARGB(255, 129, 129, 129), fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 24,),
                            SizedBox(
                              height: listArtistFollowed.length * 70,
                              child: ListView.builder(
                                itemCount: listArtistFollowed.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      containerItemArtist(
                                        artist: listArtistFollowed[index], 
                                        ontap: (){
                                          _artistBloc.add(getInfoArtistEvent(name: listArtistFollowed[index].alias!));
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
                      }else{
                        return const Center(
                          child: Text("Trống",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        );
                      }
                    }else{
                      return const Center(
                        child: Text("Trống",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                    }
                  }else{
                    showDialogErro(context: context, erro: snapshot.error!);
                  }
                  return Container();
                }
              ),
            ),
          ),
    
        )
    );
  }
}
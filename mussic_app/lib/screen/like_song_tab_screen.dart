import 'package:flutter/material.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/screen/play_mussic_screen.dart';
import 'package:mussic_app/widget/container_list_mussic_new.dart';
import 'package:mussic_app/widget/dialo_erro.dart';

class LikeSongTabScreen extends StatelessWidget {
  const LikeSongTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        StreamBuilder(
          stream: FirebaseRepo.getAllLikeSong(),
          builder: (context, snapshot) {
            if(snapshot.hasError == false){
              if(snapshot.hasData){
                final data = snapshot.data?.docs;
                List<Song> listSongLike = data!.map((e) => Song.fromJson(e.data())).toList();
                if(listSongLike.isNotEmpty){
                  return SizedBox(
                    height: listSongLike.length * 70,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listSongLike.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ContainerListMussicNew(
                              song: listSongLike[index], 
                              onLongPress: () async {
                                 if(await appDiaLog.showModalComfirm(context: context, tiltle: "Xác Nhận", subTitle: "Bạn có chắc muốn xóa \"${listSongLike[index].title}\" ra khỏi danh sách yêu thích ?")){
                                  appState.firebaseBloc.add(LikeSongEvent(isHeart: true, song: listSongLike[index]));
                                }
                              },
                              ontap: (){
                                appState.currentSong = listSongLike[index];
                                appState.listSong = listSongLike.sublist(0);
                                appState.indexSong = index;
                                appState.isShuffle = null;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => playMussicScreen(),));
                              }
                            ),
                            const SizedBox(height: 10,),
                          ],
                        );
                      },
                    ),
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
          },
        )
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:mussic_app/moduels/homeItem/blocs/play_mussic_bloc.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/screen/play_list_screen.dart';
import 'package:mussic_app/widget/container_playlist_hot.dart';
import 'package:mussic_app/widget/dialo_erro.dart';

class LikePlayListTabScreen extends StatelessWidget {
  const LikePlayListTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayMussicBloc _getInfoPlayList = PlayMussicBloc();

    return BlocListener<PlayMussicBloc, PlayMussicState>(
      bloc: _getInfoPlayList,
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
      child: Column(
          children: [
            const SizedBox(height: 20,),
            StreamBuilder(
              stream: FirebaseRepo.getAllLikePlayList(),
              builder: (context, snapshot) {
                if(snapshot.hasError == false){
                  if(snapshot.hasData){
                    final data = snapshot.data?.docs;
                    List<PlayList> listLikePlayList = data!.map((e) => PlayList.fromJsonFirebase(e.data())).toList();
                    if(listLikePlayList.isNotEmpty){
                      return SizedBox(
                        height: listLikePlayList.length * 90,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listLikePlayList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () async {
                                if(await appDiaLog.showModalComfirm(context: context, tiltle: "Xác Nhận", subTitle: "Bạn có chắc muốn xóa \"${listLikePlayList[index].title}\" ra khỏi danh sách yêu thích ?")){
                                  appState.firebaseBloc.add(likePlaylistEvent(isHeart: true, playList: listLikePlayList[index]));
                                }
                              },
                              child: ContainerPlayListHot(
                                playList: listLikePlayList[index], 
                                axis: Axis.horizontal, 
                                ontap: ()  {
                                  _getInfoPlayList.add(getInfoPlayListEvent(encodeId: listLikePlayList[index].encodeId!));
                                }, 
                                width: 70, 
                                height: 70
                              ),
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
        )
    );
  }
}
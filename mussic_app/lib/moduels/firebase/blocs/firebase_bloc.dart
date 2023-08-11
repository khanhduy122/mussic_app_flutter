import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appDiaLog.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/moduels/firebase/events/firebase_event.dart';
import 'package:mussic_app/moduels/firebase/repos/firebase_repo.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseStata>{

  FirebaseBloc() : super(FirebaseStata()) {
    on((event, emit) async {
      if(event is createUserEvent){
        await FirebaseRepo.createUser(numberPhone: event.numberPhone, name: event.name, avatar: event.avatar, userID: event.userID, token: event.token);
      }

      if(event is getCurrentUserProfileEvent){
        await FirebaseRepo.getCurrentUserProfile();
      }

      if(event is updateAvatarUserEvent){
        File? fileAvatar;
        final List<AssetEntity>? result = await AssetPicker.pickAssets(
          event.context,
          pickerConfig: const AssetPickerConfig(
            maxAssets: 1,
            themeColor: Colors.blue
          ),
        );
        
        if (result != null && result.isNotEmpty) {
          fileAvatar = await result[0].file;
          appDiaLog.ShowDialogLoading(event.context);
          await FirebaseRepo.putFileAvatar(file: fileAvatar!).then((avatarUrl) async {
            await FirebaseRepo.upDateUserProfile(avatar: avatarUrl);
            emit(UserProfileState());
          });
          Navigator.pop(event.context);
        }
      }

      if(event is updateNameUserEvent){
        FirebaseRepo.upDateUserProfile(name: event.name);
        emit(UserProfileState());
        Navigator.pop(event.context);
      }

      if(event is getLikeSongEvent){
        if(appState.user != null){
          await FirebaseRepo.isLikeSong(encodeId: event.encodeId).then((isLikeSong) {
            emit(LikeSongState(isHeart: isLikeSong));
          });
        }
      }

      if(event is LikeSongEvent){
        if(event.isHeart){
          await FirebaseRepo.deleteLikeSongs(song: event.song);
          emit(LikeSongState(isHeart: false));
        }else{
          event.song.timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          await FirebaseRepo.likeSongs(song: event.song);
          emit(LikeSongState(isHeart: true));
        }
      }

      if(event is getLikePlayListEvent){
        if(appState.user != null){
          await FirebaseRepo.isLikePlayList(encodeId: event.encodeId).then((isLikePlayList) {
            emit(LikePlayListState(isHeart: isLikePlayList));
          });
        }
      }

      if(event is likePlaylistEvent){
        if(event.isHeart){
          await FirebaseRepo.deleteLikePlayList(playList: event.playList);
          emit(LikePlayListState(isHeart: false));
        }else{
          event.playList.timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          await FirebaseRepo.likePlayList(playList: event.playList);
          emit(LikePlayListState(isHeart: true));
        }
      }

      if(event is getLikeVideoEvent){
        if(appState.user != null){
          await FirebaseRepo.isLikeVideo(encodeId: event.encodeId).then((isLikeVideo) {
            emit(LikeVideoState(isHeart: isLikeVideo));
          });
        }
      }

      if(event is likeVideoEvent){
        if(event.isLike){
          await FirebaseRepo.deleteLikeVideo(encodeId: event.mv.encodeId!);
          emit(LikeVideoState(isHeart: false));
        }else{
          event.mv.timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          await FirebaseRepo.likeVideo(mv: event.mv);
          emit(LikeVideoState(isHeart: true));
        }
      }

      if(event is getFollowArtistEvent){
        if(appState.user != null){
          await FirebaseRepo.isFollowArtist(encodeId: event.id).then((isFollowArtist) {
            emit(FollowArtistState(isFollow: isFollowArtist));
          });
        }
      }

      if(event is FollowArtistEvent){
        if(event.isFollow){
          await FirebaseRepo.deleteFollowArtist(artist: event.artist);
          emit(FollowArtistState(isFollow: false));
        }else{
          event.artist.timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          await FirebaseRepo.FollowArtist(artist: event.artist);
          emit(FollowArtistState(isFollow: true));
        }
      }
      
    });
  }

  
}

class FirebaseStata {}

class LikeSongState extends FirebaseStata{
  bool isHeart;

  LikeSongState({required this.isHeart});
}

class LikePlayListState extends FirebaseStata{
  bool isHeart;

  LikePlayListState({required this.isHeart});
}

class LikeVideoState extends FirebaseStata{
  bool isHeart;

  LikeVideoState({required this.isHeart});
}

class FollowArtistState extends FirebaseStata{
  bool isFollow;

  FollowArtistState({required this.isFollow});
}

class UserProfileState extends FirebaseStata{}
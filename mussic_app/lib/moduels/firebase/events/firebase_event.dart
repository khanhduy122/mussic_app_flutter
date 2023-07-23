
import 'package:flutter/material.dart';
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/song.dart';

abstract class FirebaseEvent {}

class createUserEvent extends FirebaseEvent {
  String userID;
  String numberPhone;
  String name;
  String avatar;
  String token;

  createUserEvent({required this.userID ,required this.numberPhone, required this.name, required this.avatar, required this.token});
}

class getCurrentUserProfileEvent extends FirebaseEvent{}

class updateAvatarUserEvent extends FirebaseEvent{
  BuildContext context;

  updateAvatarUserEvent({required this.context});
}

class updateNameUserEvent extends FirebaseEvent{
  String name;
  BuildContext context;

  updateNameUserEvent({required this.name, required this.context});
}

class getLikeSongEvent extends FirebaseEvent{
  String encodeId;
  getLikeSongEvent({required this.encodeId});
}

class LikeSongEvent extends FirebaseEvent{
  bool isHeart;
  Song song;
  LikeSongEvent({required this.isHeart, required this.song});
}

class getAllLikeSong extends FirebaseEvent{}

class getLikePlayListEvent extends FirebaseEvent{
  String encodeId;
  getLikePlayListEvent({required this.encodeId});
}

class likePlaylistEvent extends FirebaseEvent{
  bool isHeart;
  PlayList playList;
  likePlaylistEvent({required this.isHeart, required this.playList});
}

class getAllLikePlayList extends FirebaseEvent{}

class getLikeVideoEvent extends FirebaseEvent{
  String encodeId;

  getLikeVideoEvent({required this.encodeId});
}

class likeVideoEvent extends FirebaseEvent{
  bool isLike;
  MV mv;

  likeVideoEvent({required this.isLike, required this.mv});
}

class getFollowArtistEvent extends FirebaseEvent{
  String id;
  getFollowArtistEvent({required this.id});
} 

class FollowArtistEvent extends FirebaseEvent{
  bool isFollow;
  Artist artist;
  FollowArtistEvent({required this.isFollow, required this.artist});
}

class getAllFollowArtist extends FirebaseEvent{}



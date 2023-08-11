
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/model/userProfile.dart';
import 'package:mussic_app/moduels/audioPlayer/bloc/audio_player_bloc.dart';
import 'package:mussic_app/moduels/dowload/blocs/dowload_bloc.dart';
import 'package:mussic_app/moduels/firebase/blocs/firebase_bloc.dart';
import 'package:mussic_app/moduels/firebaseAuth/blocs/firebase_auth_bloc.dart';

class appState{
  static Song? currentSong;
  static Song? songPlayed;
  static bool isGetSongPlayed = false;
  static StreamController streamCurrentSong = StreamController();
  static User? get user => FirebaseAuth.instance.currentUser;
  static UserProfile? userProfile;
  static AudioPlayerBloc audioBloc = AudioPlayerBloc();
  static FirebaseAuthBloc authBloc = FirebaseAuthBloc();
  static DownLoadBloc dowLoadBloc = DownLoadBloc();
  static FirebaseBloc firebaseBloc = FirebaseBloc();
  static List<Song>? listSong;
  static int? indexSong;
  static bool? isShuffle;
  static List<Song> listSongCompleted = [];
  static List<Song> listSongNext = [];
}
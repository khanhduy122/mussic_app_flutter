import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/component/appState.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/audioPlayer/events/audio_player_event.dart';
import 'package:mussic_app/moduels/audioPlayer/repos/audio_player_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerBloc extends Bloc<audioPlayerEvent, AudioPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription? _streamSubscriptionUpdatePosition;
  StreamSubscription? _streamSubscriptionOnCompleted;

  AudioPlayerBloc() : super(AudioPlayerState()){

    bool isLoaded = false;

    on((event, emit) async {

      if(event is audioPlayerSetMp3){
        Directory appDocdir = await getApplicationDocumentsDirectory();
        String path = '${appDocdir.path}/mp3/${event.song.encodeId}.mp3';
        File exits = File(path);
        if(await exits.exists()){
          add(audioPlayerLoadAsset(song: event.song, isGetSongPlayed: event.isGetSongPlayed));
        }else{
          add(audioPlayerEventLoadURL(isGetSongPlayed: event.isGetSongPlayed, song: event.song));
        }
      }
      
      if(event is audioPlayerEventLoadURL){
        appState.streamCurrentSong.sink.add("new Current Song");
        if(event.isGetSongPlayed == false){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> listSongRecent = prefs.getStringList(appKey.listSongRecent) ?? [];
          String song = jsonEncode(event.song);
          if(listSongRecent.contains(song)){
            listSongRecent.remove(song);
            if(listSongRecent.length == 50){
              listSongRecent.removeLast();
              listSongRecent.insert(0, song);
              prefs.setStringList(appKey.listSongRecent, listSongRecent);
            }else{
              listSongRecent.insert(0, song);
              prefs.setStringList(appKey.listSongRecent, listSongRecent);
            }
          }else{
            if(listSongRecent.length == 50){
              listSongRecent.removeLast();
              listSongRecent.insert(0, song);
              prefs.setStringList(appKey.listSongRecent, listSongRecent);
            }else{
              listSongRecent.insert(0, song);
              prefs.setStringList(appKey.listSongRecent, listSongRecent);
            }
          }
        }
        if(audioPlayer.duration != null){
          audioPlayer.stop();
          isLoaded = false;
        }
        emit(AudioPlayerState(isLoading: true));
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String saveInfoMussicLocal = jsonEncode(event.song.toJson());
          prefs.setString(appKey.songPlayed, saveInfoMussicLocal);
          final res = await audioPlayerRepo.fetchLinkSong(http.Client(), event.song.encodeId!);
          await audioPlayer.setUrl(res);
          isLoaded = true;
          if(event.isGetSongPlayed){
            audioPlayer.stop();
            emit(AudioPlayerState(isLoading: false, isPlaying: false, duration: audioPlayer.duration, currentPosition: audioPlayer.position));
          }else{
            audioPlayer.play();
            emit(AudioPlayerState(isLoading: false, isPlaying: true, duration: audioPlayer.duration, currentPosition: audioPlayer.position));
          }
          _streamSubscriptionUpdatePosition = audioPlayer.positionStream.listen((newPosition) {
            add(audioPlayerEventUploadPosition(currentPosition: newPosition));
          });

          
        } catch (e) {
        
           emit(AudioPlayerState(erro: e));
        }
      }

      if(event is audioPlayerLoadAsset){
        appState.streamCurrentSong.sink.add("new Current Song");
        if(event.isGetSongPlayed == false){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> listSongRecent = prefs.getStringList(appKey.listSongRecent) ?? [];
          String song = jsonEncode(event.song);
          if(listSongRecent.contains(song)){
            listSongRecent.remove(song);
            if(listSongRecent.length == 50){
              listSongRecent.removeLast();
              listSongRecent.insert(0, song);
              prefs.setStringList(appKey.listSongRecent, listSongRecent);
            }else{
              listSongRecent.insert(0, song);
              prefs.setStringList(appKey.listSongRecent, listSongRecent);
            }
          }else{
            if(listSongRecent.length == 50){
              listSongRecent.removeLast();
              listSongRecent.insert(0, song);
              prefs.setStringList(appKey.listSongRecent, listSongRecent);
            }else{
              listSongRecent.insert(0, song);
              prefs.setStringList(appKey.listSongRecent, listSongRecent);
            }
          }
          
        }
        if(audioPlayer.duration != null){
          audioPlayer.stop();
          isLoaded = false;
        }
        Directory appDocdir = await getApplicationDocumentsDirectory();
        await audioPlayer.setFilePath('${appDocdir.path}/mp3/${event.song.encodeId}.mp3');
        isLoaded = true;
        if(event.isGetSongPlayed){
            audioPlayer.stop();
            emit(AudioPlayerState(isLoading: false, isPlaying: false, duration: audioPlayer.duration, currentPosition: audioPlayer.position));
          }else{
            audioPlayer.play();
            emit(AudioPlayerState(isLoading: false, isPlaying: true, duration: audioPlayer.duration, currentPosition: audioPlayer.position));
          }
        emit(AudioPlayerState(isLoading: false, isPlaying: true, duration: audioPlayer.duration, currentPosition: audioPlayer.position));
        _streamSubscriptionUpdatePosition = audioPlayer.positionStream.listen((newPosition) {
          add(audioPlayerEventUploadPosition(currentPosition: newPosition));
        });
      }

      if(event is audioPlayerEventPlayPause){
        if(isLoaded){
          if(audioPlayer.playing){
            audioPlayer.pause();
             emit(AudioPlayerState(isLoading: false, isPlaying: false, currentPosition: audioPlayer.position, duration: audioPlayer.duration));
          }else{
            audioPlayer.play();
             emit(AudioPlayerState(isLoading: false, isPlaying: true, currentPosition: audioPlayer.position, duration: audioPlayer.duration));
          }
        }
      }

      if(event is audioPlayerEventSeekPosition){
        if(isLoaded){
          if(audioPlayer.playing) {
            audioPlayer.seek(event.duration);
            emit(AudioPlayerState(isLoading: false, isPlaying: true, currentPosition: audioPlayer.position, duration: audioPlayer.duration));
          }else{
            audioPlayer.seek(event.duration);
            emit(AudioPlayerState(isLoading: false, isPlaying: false, currentPosition: audioPlayer.position, duration: audioPlayer.duration));
          }
        }
      }

      if(event is audioPlayerEventUploadPosition){
        if(isLoaded){
          if (audioPlayer.playing) {
            emit(AudioPlayerState(isLoading: false, isPlaying: true, currentPosition: event.currentPosition, duration: audioPlayer.duration));
          }else {
            emit(AudioPlayerState(isLoading: false, isPlaying: false, currentPosition: event.currentPosition, duration: audioPlayer.duration));
          }
        }
      }

      if(event is audioPlayerEventRepeate){
        if(event.isRepeate){
          audioPlayer.setLoopMode(LoopMode.one);
        }else{
          audioPlayer.setLoopMode(LoopMode.off);
        }
        if(isLoaded){
          if(audioPlayer.playing){
            emit(AudioPlayerState(isLoading: false, isPlaying: true, currentPosition: audioPlayer.position, duration: audioPlayer.duration, isRepeate: event.isRepeate));
          }else{
            emit(AudioPlayerState(isLoading: false, isPlaying: false, currentPosition: audioPlayer.position, duration: audioPlayer.duration, isRepeate: event.isRepeate));
          }
        }
        else{
          emit(AudioPlayerState(isRepeate: event.isRepeate));
        }
      }

      if(event is audioPlayerEventShuffle){
        if(isLoaded){
          if(audioPlayer.playing){
            if(appState.listSong != null){
              appState.listSongCompleted.clear();
              appState.listSongCompleted.add(appState.currentSong!);
              appState.listSongNext.clear();
              List<Song> songShuffle = appState.listSong!.sublist(0); 
              songShuffle.shuffle();
              appState.listSongNext = songShuffle.sublist(0);
            }
            emit(AudioPlayerState(isLoading: false, isPlaying: true, currentPosition: audioPlayer.position, duration: audioPlayer.duration, isShuffle: event.isShuffle));
          }else{
            if(appState.listSong != null){
              appState.listSongCompleted.clear();
              appState.listSongCompleted.add(appState.currentSong!);
              appState.listSongNext.clear();
              List<Song> songShuffle = appState.listSong!.sublist(0); 
              songShuffle.shuffle();
              appState.listSongNext = songShuffle.sublist(0);
            }
            emit(AudioPlayerState(isLoading: false, isPlaying: false, currentPosition: audioPlayer.position, duration: audioPlayer.duration, isShuffle: event.isShuffle));
          }
        }
        else{
          emit(AudioPlayerState(isShuffle: event.isShuffle));
        }
      }

      if(event is audioPlayerEventHeart){
        if(audioPlayer.duration != null){
          if(audioPlayer.playing){
            emit(AudioPlayerState(isLoading: false, isPlaying: true, currentPosition: audioPlayer.position, duration: audioPlayer.duration, isHeart: event.isHeart));
          }else{
            emit(AudioPlayerState(isLoading: false, isPlaying: false, currentPosition: audioPlayer.position, duration: audioPlayer.duration, isHeart: event.isHeart));
          }
        }
        else{
          emit(AudioPlayerState(isHeart: event.isHeart));
        }
      }

      if(event is audioPlayerEventNextMussic){
        if(appState.listSong != null || appState.listSong!.isEmpty){
          if(appState.listSongNext.isEmpty){
            appState.listSongNext = appState.listSongCompleted.sublist(1);
            appState.listSongCompleted.removeRange(1,  appState.listSongCompleted.length);
            appState.currentSong = appState.listSongCompleted[0];
            add(audioPlayerSetMp3(isGetSongPlayed: false, song: appState.currentSong!));
          }else{
            appState.listSongCompleted.add(appState.listSongNext.first);
            appState.listSongNext.removeAt(0);
            appState.currentSong = appState.listSongCompleted.last;
            add(audioPlayerSetMp3(isGetSongPlayed: false, song: appState.currentSong!));
          }
          emit(NextMussic()); 
        }
      }

      if(event is audioPlayerEventBackMussic){
        if(appState.listSong != null || appState.listSong!.isEmpty){
          if(appState.listSongCompleted.length == 1){
            appState.listSongCompleted.insertAll(1, appState.listSongNext.sublist(0));
            appState.listSongNext.clear();
            appState.currentSong = appState.listSongCompleted.last;
            add(audioPlayerSetMp3(isGetSongPlayed: false, song: appState.currentSong!));
          }else{
            appState.listSongNext.insert(0,appState.listSongCompleted.last);
            appState.listSongCompleted.remove(appState.listSongCompleted.last);
            appState.currentSong = appState.listSongCompleted.last;
            add(audioPlayerSetMp3(isGetSongPlayed: false, song: appState.currentSong!));
          }
          emit(BackMussic());
        }
        
      }

      if(event is audioPlayerEventCompleted){
        audioPlayer.stop();
        if(event.isListMussic){
          add(audioPlayerEventNextMussic());
        }else{
          audioPlayer.stop();
          emit(AudioPlayerState(isLoading: false, isPlaying: false, currentPosition: audioPlayer.duration, duration: audioPlayer.duration, isCompleted: true));
        }
      }

    });
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    _streamSubscriptionOnCompleted!.cancel();
    _streamSubscriptionUpdatePosition!.cancel();
    return super.close();
  }
}

class AudioPlayerState{
  bool? isLoading ;
  bool? isPlaying = false;
  bool? isShuffle;
  bool? isRepeate;
  bool? isHeart;
  bool? isCompleted;
  Duration? currentPosition;
  Duration? duration;
  Object? erro;

  AudioPlayerState({this.currentPosition, this.duration, this.isHeart, this.isLoading, this.isRepeate, this.isShuffle, this.isPlaying, this.erro, this.isCompleted});
}

class NextMussic extends AudioPlayerState{}

class BackMussic extends AudioPlayerState{}









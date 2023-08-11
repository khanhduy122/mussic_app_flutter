import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/model/artist.dart';
import 'package:mussic_app/model/exceptions.dart';
import 'package:mussic_app/model/mv.dart';
import 'package:mussic_app/model/playlist.dart';
import 'package:mussic_app/model/search.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/homeItem/events/play_mussic_event.dart';
import 'package:mussic_app/moduels/homeItem/repos/play_mussic_repo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlayMussicBloc extends Bloc<playMussicEvent, PlayMussicState> {

  PlayMussicBloc() : super(PlayMussicState()) {
    on<playMussicEvent>((event, emit) async {
        if(event is getInfoSong){
          emit(PlayMussicState(isLoading: true));
          try {
            final res = await PlayMussicRepo.fetchSongInfo(http.Client(), event.encodeId);
            if(res != null){
              emit(PlayMussicState(song: res, isLoading: false, erro: null, playList: null));
            }
          } catch (e) {
            if(e is NoIntenetException){
              emit(PlayMussicState(erro: NoIntenetException()));
            }
          }
          
        }

        if(event is getInfoPlayListEvent){
          emit(PlayMussicState(isLoading: true));
          try {
            final res = await PlayMussicRepo.fetchInfoPlayList(http.Client(), event.encodeId);
            if(res != null){
              emit(PlayMussicState(playList: res, isLoading: false, song: null, erro: null));

              SharedPreferences prefs = await SharedPreferences.getInstance();
              List<String> listPlayListRecent = prefs.getStringList(appKey.listPlayListRecent) ?? [];
              String playList = jsonEncode(res);
              if(listPlayListRecent.contains(playList)){
                listPlayListRecent.remove(playList);
                if(listPlayListRecent.length == 50){
                  listPlayListRecent.removeLast();
                  listPlayListRecent.insert(0, playList);
                  prefs.setStringList(appKey.listPlayListRecent, listPlayListRecent);
                }else{
                  listPlayListRecent.insert(0, playList);
                  prefs.setStringList(appKey.listPlayListRecent, listPlayListRecent);
                }
              }else{
                if(listPlayListRecent.length == 50){
                  listPlayListRecent.removeLast();
                  listPlayListRecent.insert(0, playList);
                  prefs.setStringList(appKey.listPlayListRecent, listPlayListRecent);
                }else{
                  listPlayListRecent.insert(0, playList);
                  prefs.setStringList(appKey.listPlayListRecent, listPlayListRecent);
                }
              }
            }
          } catch (e) {
            if(e is NoIntenetException){
              emit(PlayMussicState(erro: NoIntenetException()));
            }
          }
          
        }

        if(event is getInfoVideoEvent){
          try {
            emit(PlayMussicState(isLoading: true));
            final res = await PlayMussicRepo.fetchInfoVideo(http.Client(), event.encodeId);
            if(res != null){
              emit(PlayMussicState(playList: null, isLoading: false, song: null, erro: null, mv: res));
            }
          } catch (e) {
            if(e is NoIntenetException){
              emit(PlayMussicState(erro: NoIntenetException));
            }
          }
          
        }

        if(event is getInfoArtistEvent){
          emit(PlayMussicState(isLoading: true));
          try {
            final res = await PlayMussicRepo.fetchArtist(http.Client(), event.name);
            if(res != null){
              emit(PlayMussicState(artist: res, isLoading: false, song: null, playList: null, mv:  null));
              SharedPreferences prefs = await SharedPreferences.getInstance();
              List<String> listArtistRecent = prefs.getStringList(appKey.listArtistRecent) ?? [];
              String artist = jsonEncode(res);
              if(listArtistRecent.contains(artist)){
                listArtistRecent.remove(artist);
                if(listArtistRecent.length == 50){
                  listArtistRecent.removeLast();
                  listArtistRecent.insert(0, artist);
                  prefs.setStringList(appKey.listArtistRecent, listArtistRecent);
                }else{
                  listArtistRecent.insert(0, artist);
                  prefs.setStringList(appKey.listArtistRecent, listArtistRecent);
                }
              }else{
                if(listArtistRecent.length == 50){
                  listArtistRecent.removeLast();
                  listArtistRecent.insert(0, artist);
                  prefs.setStringList(appKey.listArtistRecent, listArtistRecent);
                }else{
                  listArtistRecent.insert(0, artist);
                  prefs.setStringList(appKey.listArtistRecent, listArtistRecent);
                }
              }
            }
          } catch (e) {
            if(e is NoIntenetException){
              emit(PlayMussicState(erro: NoIntenetException));
            }
          }
        }

        if(event is getResultSearchEvent){
          emit(PlayMussicState(isLoading: true));
          try {
            final res = await PlayMussicRepo.fetchSearch(http.Client(), event.keySearch);
            if(res != null){
              emit(PlayMussicState(search: res));
            }
          } catch (e) {
            if(e is NoIntenetException){
              emit(PlayMussicState(erro: NoIntenetException));
            }
          }

        }
    });
  }
}

class PlayMussicState {
  Object? erro;
  bool? isLoading = false;
  Song? song;
  PlayList? playList;
  MV? mv;
  Search? search;
  Artist? artist;

  PlayMussicState({this.erro, this.song, this.isLoading, this.playList, this.mv, this.artist, this.search});
}
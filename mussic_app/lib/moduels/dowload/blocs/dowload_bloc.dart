
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/component/appKey.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/moduels/audioPlayer/repos/audio_player_repo.dart';
import 'package:mussic_app/moduels/dowload/events/dowload_event.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DownLoadBloc extends Bloc<DowloadEvent, DownLoadState>{

  final Dio _dio = Dio();

  DownLoadBloc() : super(DownLoadState()){
    on((event, emit) async {
      if(event is DowloadSongEvent){
        try {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String newFolderMp3 = '${appDocDir.path}/mp3';

          Directory(newFolderMp3).createSync(recursive: true);

          String filePath = '$newFolderMp3/${event.song.encodeId!}.mp3';

          String url = await audioPlayerRepo.fetchLinkSong(http.Client(), event.song.encodeId!);
          await _dio.download(
            url,
            filePath,
            onReceiveProgress: (count, total) {
              emit(DownloadingState(song: event.song, isDowloading: true, progress: (count * 1.0/total)));
            },
          );

          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> listSongDowloaded = prefs.getStringList(appKey.listSongDowloaded) ?? [];
         
          String saveInfoMussicLocal = jsonEncode(event.song.toJsonFirebase());
          listSongDowloaded.insert(0,saveInfoMussicLocal);
          await prefs.remove(appKey.listSongDowloaded);
          await prefs.setStringList(appKey.listSongDowloaded, listSongDowloaded);
          emit(DownloadSuccess(song: event.song));
        } catch (e) {
          
        }
        
      }

      if(event is DeleteSongDownloadEvent){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> listSongDowloaded = prefs.getStringList(appKey.listSongDowloaded) ?? [];

        String song = jsonEncode(event.song.toJsonFirebase());

        listSongDowloaded.remove(song);
        await prefs.remove(appKey.listSongDowloaded);
        await prefs.setStringList(appKey.listSongDowloaded, listSongDowloaded);

        Directory appDocdir = await getApplicationDocumentsDirectory();
        String path = '${appDocdir.path}/mp3/${event.song.encodeId}.mp3';
        File file = File(path);
        await file.delete();
      }

      if(event is getIsDownLoad){
        Directory appDocdir = await getApplicationDocumentsDirectory();
        String path = '${appDocdir.path}/mp3/${event.song.encodeId}.mp3';
        File exits = File(path);
        if(await exits.exists()){
          emit(DownLoadState(isDowload: true));
        }else{
          emit(DownLoadState(isDowload: false));
        }
      }
    });
  }
}


class DownLoadState{
  bool? isDowload;
  DownLoadState({this.isDowload});
}

class DownloadingState extends DownLoadState{
  bool? isDowloading;
  Song? song;
  List<Song>? listSong;
  double? progress;

  DownloadingState({this.isDowloading, this.listSong, this.progress, this.song});
}

class DownloadSuccess extends DownLoadState{
  Song song;
  DownloadSuccess({required this.song});
}


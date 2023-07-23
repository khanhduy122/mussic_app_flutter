import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/model/charts.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/model/top100.dart';
import 'package:mussic_app/moduels/homeItem/repos/get_chart_repo.dart';

class getChartBloc extends Bloc<getChartEvent, getChartState>{
  getChartBloc() : super(getChartState()){
    on((event, emit) async {
      if(event is getChartBXHEvent){
        try {
          emit(getChartState(isLoaded: true));
          final res = await getChartRepo.getChart(http.Client());
          if(res != null){
            emit(getChartState(chart: res, isLoaded: false));
          }
        } catch (e) {
          emit(getChartState(erro: e, isLoaded: false, ));
        }
      }

      if(event is getTop100Event){
        emit(getChartState(isLoaded: true));
        try {
          final res = await getChartRepo.getTop100(http.Client());
           print("get topp 100");
          if(res != null){
            emit(getChartState(isLoaded: false, top100: res, ));
          }
        } catch (e) {
          emit(getChartState(erro: e, isLoaded: false, top100: null, chart: null, newReleaseChart: null));
        }
      }

      if(event is getNewReleaseChartEvent){
        emit(getChartState(isLoaded: true));
        try {
          final res = await getChartRepo.getNewReleaseChart(http.Client());
          if(res != null){
            emit(getChartState(isLoaded: false, top100: null, chart: null, newReleaseChart: res));
          }
        } catch (e) {
          emit(getChartState(erro: e, isLoaded: false, top100: null, chart: null, newReleaseChart: null));
        }
      }
    });
  }
  
}

class getChartState{
  Object? erro;
  Chart? chart;
  List<Top100>? top100;
  List<Song>? newReleaseChart;
  bool? isLoaded;
  getChartState({this.chart, this.erro, this.isLoaded, this.newReleaseChart, this.top100});
}

abstract class getChartEvent {}

class getChartBXHEvent extends getChartEvent{}

class getTop100Event extends getChartEvent{}

class getNewReleaseChartEvent extends getChartEvent{}
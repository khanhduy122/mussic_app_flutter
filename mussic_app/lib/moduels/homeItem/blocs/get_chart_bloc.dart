import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mussic_app/model/charts.dart';
import 'package:mussic_app/model/song.dart';
import 'package:mussic_app/model/top100.dart';
import 'package:mussic_app/moduels/homeItem/repos/get_chart_repo.dart';

class GetChartBloc extends Bloc<GetChartEvent, GetChartState>{
  GetChartBloc() : super(GetChartState()){
    on((event, emit) async {
      if(event is GetChartBXHEvent){
        try {
          emit(GetChartState(isLoaded: true));
          final res = await getChartRepo.getChart(http.Client());
          if(res != null){
            emit(GetChartState(chart: res, isLoaded: false));
          }
        } catch (e) {
          emit(GetChartState(erro: e, isLoaded: false, ));
        }
      }

      if(event is GetTop100Event){
        emit(GetChartState(isLoaded: true));
        try {
          final res = await getChartRepo.getTop100(http.Client());
          if(res != null){
            emit(GetChartState(isLoaded: false, top100: res, ));
          }
        } catch (e) {
          emit(GetChartState(erro: e, isLoaded: false, top100: null, chart: null, newReleaseChart: null));
        }
      }

      if(event is GetNewReleaseChartEvent){
        emit(GetChartState(isLoaded: true));
        try {
          final res = await getChartRepo.getNewReleaseChart(http.Client());
          if(res != null){
            emit(GetChartState(isLoaded: false, top100: null, chart: null, newReleaseChart: res));
          }
        } catch (e) {
          emit(GetChartState(erro: e, isLoaded: false, top100: null, chart: null, newReleaseChart: null));
        }
      }
    });
  }
  
}

class GetChartState{
  Object? erro;
  Chart? chart;
  List<Top100>? top100;
  List<Song>? newReleaseChart;
  bool? isLoaded;
  GetChartState({this.chart, this.erro, this.isLoaded, this.newReleaseChart, this.top100});
}

abstract class GetChartEvent {}

class GetChartBXHEvent extends GetChartEvent{}

class GetTop100Event extends GetChartEvent{}

class GetNewReleaseChartEvent extends GetChartEvent{}
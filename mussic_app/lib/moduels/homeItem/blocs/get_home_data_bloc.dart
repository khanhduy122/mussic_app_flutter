import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mussic_app/model/HomeData.dart';
import 'package:mussic_app/model/exceptions.dart';
import 'package:mussic_app/moduels/homeItem/repos/get_home_data_repo.dart';
import 'package:http/http.dart' as http;

class getHomeDataBloc extends Bloc<getHomeDataEvent, getHomeDataState> {
  getHomeDataBloc() : super(getHomeDataState()){
    on((event, emit) async {

      if(event is getHomeDataEvent){
        try {
            final res = await getHomeDataRepo().fetchHomeItem(http.Client());
            emit(getHomeDataState(homedata: res));
          } catch (e) {
            if(e is NoIntenetException){
              emit(getHomeDataState(erro: NoIntenetException()));
            }
          }
      }
      
      if(event is refreshGetHomeDataEvent){
        try {
            final res = await getHomeDataRepo().fetchHomeItem(http.Client());
            emit(getHomeDataState(homedata: res));
            Navigator.pop(event.context);
          } catch (e) {
            if(e is NoIntenetException){
              emit(getHomeDataState(erro: NoIntenetException()));
              Navigator.pop(event.context);
            }
          }
      }

    });
  }

}

class getHomeDataState{
  Object? erro;
  HomeData? homedata;

  getHomeDataState({this.erro, this.homedata});
}

class getHomeDataEvent {}

class refreshGetHomeDataEvent extends getHomeDataEvent {
  BuildContext context;

  refreshGetHomeDataEvent({required this.context});
}
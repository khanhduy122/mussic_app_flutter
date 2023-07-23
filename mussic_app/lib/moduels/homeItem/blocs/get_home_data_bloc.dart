import 'package:bloc/bloc.dart';
import 'package:mussic_app/model/HomeData.dart';
import 'package:mussic_app/moduels/homeItem/repos/get_home_data_repo.dart';
import 'package:http/http.dart' as http;

class getHomeDataBloc extends Bloc<getHomeDataEvet, getHomeDataState> {
  getHomeDataBloc() : super(getHomeDataState()){
    on((event, emit) async {

      if(event is getHomeDataEvet){
        try {
            final res = await getHomeDataRepo().fetchHomeItem(http.Client());
            emit(getHomeDataState(homedata: res));
          } catch (e) {
            emit(getHomeDataState(erro: e));
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

class getHomeDataEvet {}
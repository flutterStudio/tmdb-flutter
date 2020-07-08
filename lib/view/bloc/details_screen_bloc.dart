import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/cast.dart';
import 'package:TMDB_Mobile/repository/main_repository.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

class DetailsScreenBloc extends Bloc {
  BehaviorSubject<dynamic> _detailsStreamController;
  BehaviorSubject<dynamic> _similarDataStreamController;
  BehaviorSubject<Data<List<Cast>>> _castStreamController;

  DetailsScreenBloc() {
    _detailsStreamController = BehaviorSubject<dynamic>();
    _similarDataStreamController = BehaviorSubject<dynamic>();
    _castStreamController = BehaviorSubject<Data<List<Cast>>>();
  }

  Stream<dynamic> get detailsStream => _detailsStreamController.stream;
  Stream<dynamic> get similarDataStream => _similarDataStreamController.stream;
  Stream<Data<List<Cast>>> get castStream => _castStreamController.stream;

  Future<void> getDetails(int id, bool movie) async {
    _detailsStreamController.sink.add(Data.loading());

    var details = movie
        ? await MainRepository().getMovieDetails(id)
        : await MainRepository().getTvShowDetails(id);
    _detailsStreamController.sink.add(details);
  }

  Future<void> getCast(int id, bool movie) async {
    _castStreamController.sink.add(Data.loading());

    var cast = await MainRepository()
        .getCast(id, movie ? TmdbEndPoint.movie : TmdbEndPoint.tv);
    _castStreamController.sink.add(cast);
  }

  Future<void> getSimilar(int id, bool movie) async {
    _similarDataStreamController.sink.add(Data.loading());

    var cast = movie
        ? await MainRepository().getSimilarMovies(id)
        : await MainRepository().getSimilarTvShows(id);

    _similarDataStreamController.sink.add(cast);
  }

  Future<void> getData(int id, bool movie) async {
    _similarDataStreamController.sink.add(Data.loading());

    getDetails(id, movie);
    getCast(id, movie);
    getSimilar(id, movie);
  }

  @override
  void dispose() {
    _detailsStreamController.close();
    _castStreamController.close();
    _similarDataStreamController.close();
  }
}

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/cast.dart';
import 'package:TMDB_Mobile/model/video.dart';
import 'package:TMDB_Mobile/repository/main_repository.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

class DetailsScreenBloc extends Bloc {
  BehaviorSubject<dynamic> _detailsStreamController;
  BehaviorSubject<dynamic> _similarDataStreamController;
  BehaviorSubject<Data<List<Cast>>> _castStreamController;
  BehaviorSubject<Data<List<Video>>> _videoStreamController;

  DetailsScreenBloc() {
    _detailsStreamController = BehaviorSubject<dynamic>();
    _similarDataStreamController = BehaviorSubject<dynamic>();
    _castStreamController = BehaviorSubject<Data<List<Cast>>>();
    _videoStreamController = BehaviorSubject<Data<List<Video>>>();
  }

  Stream<dynamic> get detailsStream => _detailsStreamController.stream;
  Stream<dynamic> get similarDataStream => _similarDataStreamController.stream;
  Stream<Data<List<Cast>>> get castStream => _castStreamController.stream;
  Stream<Data<List<Video>>> get videosStream => _videoStreamController.stream;

  Future<void> getDetails(int id, bool movie) async {
    var details = movie
        ? await MainRepository().getMovieDetails(id)
        : await MainRepository().getTvShowDetails(id);
    _detailsStreamController.sink.add(details);
  }

  Future<void> getCast(int id, bool movie) async {
    var cast = await MainRepository()
        .getCast(id, movie ? TmdbEndPoint.movie : TmdbEndPoint.tv);
    _castStreamController.sink.add(cast);
  }

  Future<void> getSimilar(int id, bool movie) async {
    var cast = movie
        ? await MainRepository().getSimilarMovies(id)
        : await MainRepository().getSimilarTvShows(id);

    _similarDataStreamController.sink.add(cast);
  }

  Future<void> getVideos(int id, bool movie) async {
    var videos = movie
        ? await MainRepository().getMovieVideos(id)
        : await MainRepository().getTvShowVideos(id);

    _videoStreamController.sink.add(videos);
  }

  Future<void> getData(int id, bool movie) async {
    _detailsStreamController.sink.add(Data.loading());
    _castStreamController.sink.add(Data.loading());
    _similarDataStreamController.sink.add(Data.loading());

    await getDetails(id, movie);
    await getCast(id, movie);
    await getSimilar(id, movie);
    await getVideos(id, movie);
  }

  @override
  void dispose() {
    _detailsStreamController.close();
    _castStreamController.close();
    _similarDataStreamController.close();
    _videoStreamController.close();
  }
}

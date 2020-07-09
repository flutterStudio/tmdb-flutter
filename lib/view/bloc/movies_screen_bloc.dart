import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/repository/main_repository.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

class MoviesScreenBloc extends Bloc {
  Data<List<Movie>> _trending;
  Data<List<Movie>> _popular;
  Data<List<Movie>> _latest;
  Data<List<Movie>> _nowPlaying;
  Data<List<Movie>> _upcoming;

  BehaviorSubject<Data<List<Movie>>> _trendingStreamController;
  BehaviorSubject<Data<List<Movie>>> _popularStreamController;
  BehaviorSubject<Data<List<Movie>>> _latestStreamController;
  BehaviorSubject<Data<List<Movie>>> _upcomingController;
  BehaviorSubject<Data<List<Movie>>> _nowPlayingController;

  Data<List<Movie>> get trending => _trending;
  Data<List<Movie>> get popular => _popular;
  Data<List<Movie>> get latest => _latest;
  Data<List<Movie>> get nowPlaying => _nowPlaying;
  Data<List<Movie>> get upcoming => _upcoming;

  MoviesScreenBloc() {
    _trending = Data.loading();
    _popular = Data.loading();
    _latest = Data.loading();
    _nowPlaying = Data.loading();
    _upcoming = Data.loading();
    _trendingStreamController = BehaviorSubject<Data<List<Movie>>>();
    _popularStreamController = BehaviorSubject<Data<List<Movie>>>();
    _latestStreamController = BehaviorSubject<Data<List<Movie>>>();
    _upcomingController = BehaviorSubject<Data<List<Movie>>>();
    _nowPlayingController = BehaviorSubject<Data<List<Movie>>>();
  }

  Stream<Data<List<Movie>>> get trendingMoviesStream =>
      _trendingStreamController.stream;
  Stream<Data<List<Movie>>> get popularMoviesStream =>
      _popularStreamController.stream;
  Stream<Data<List<Movie>>> get latestMoviesStream =>
      _latestStreamController.stream;
  Stream<Data<List<Movie>>> get upcomingMoviesStream =>
      _upcomingController.stream;
  Stream<Data<List<Movie>>> get nowPlayingMoviesStream =>
      _nowPlayingController.stream;

  /// Get Trending Movies during last week.
  Future<void> getTrending() async {
    Data<List<Movie>> data = Data.loading();
    _trendingStreamController.sink.add(data);
    try {
      data = await MainRepository()
          .getMovies(TmdbEndPoint.trendingMovieWeek, trending: true);
      if (data.hasData && data.data.length > 0) {
        _trending = data;
      } else {
        data.data = _trending;
      }
    } catch (e) {
      data = Data.faild(message: e.toString());
    }
    _trendingStreamController.add(data);
  }

  /// Get Popular Movies.
  Future<void> getPopular() async {
    Data<List<Movie>> data = Data.loading();
    _popularStreamController.sink.add(data);
    try {
      data = await MainRepository().getMovies(TmdbEndPoint.moviePopular);
      if (data.hasData && data.data.length > 0) {
        _popular = data;
      } else {
        data.data = _popular;
      }
    } catch (e) {
      data = Data.faild(message: e.toString());
    }
    _popularStreamController.add(data);
  }

  /// Get upcoming Movies.
  Future<void> getUpcoming() async {
    Data<List<Movie>> data = Data.loading();
    _upcomingController.sink.add(data);
    try {
      data = await MainRepository().getMovies(TmdbEndPoint.movieUpcoming);
      if (data.hasData && data.data.length > 0) {
        _upcoming = data;
      } else {
        data.data = _upcoming;
      }
    } catch (e) {
      data = Data.faild(message: e.toString());
    }
    _upcomingController.add(data);
  }

  /// Get latest Movies.
  Future<void> getLatest() async {
    Data<List<Movie>> data = Data.loading();
    _latestStreamController.sink.add(data);
    try {
      data = await MainRepository().getMovies(TmdbEndPoint.movieLatest);
      if (data.hasData && data.data.length > 0) {
        _latest = data;
      } else {
        data.data = _latest;
      }
    } catch (e) {
      data = Data.faild(message: e.toString());
    }
    _latestStreamController.add(data);
  }

  /// Get now playing Movies.
  Future<void> getNowPlaying() async {
    Data<List<Movie>> data = Data.loading();
    _nowPlayingController.sink.add(data);
    try {
      data = await MainRepository().getMovies(TmdbEndPoint.movieNowPlaying);
      if (data.hasData && data.data.length > 0) {
        _nowPlaying = data;
      } else {
        data.data = _nowPlaying;
      }
    } catch (e) {
      data = Data.faild(message: e.toString());
    }
    _nowPlayingController.add(data);
  }

  @override
  void dispose() {
    _trendingStreamController.close();
    _popularStreamController.close();
    _latestStreamController.close();
    _nowPlayingController.close();
    _upcomingController.close();
  }
}

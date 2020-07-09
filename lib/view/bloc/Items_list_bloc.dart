import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/repository/main_repository.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/bloc.dart';
import 'package:rxdart/subjects.dart';

class ItemsListScreenBloc extends Bloc {
  BehaviorSubject<dynamic> _itemsStreamController;
  Data<dynamic> _items;
  TmdbEndPoint _endPoint;
  int _page;
  int get page => _page;
  Stream<dynamic> get dataStream => _itemsStreamController.stream;

  ItemsListScreenBloc({Data<dynamic> initialData, TmdbEndPoint endPoint}) {
    _items = initialData;
    _endPoint = endPoint;
    _itemsStreamController = BehaviorSubject<dynamic>();
    _page = 1;
    if (_items.data.length > 0) {
      _itemsStreamController.sink.add(Data.loading());

      _itemsStreamController.sink.add(_items);
    }
  }

  Future<void> getData(RequestType requestType, {bool isMovie}) async {
    if (requestType == RequestType.fetch) {
      _itemsStreamController.sink.add(Data.loading());

      var data =
          await MainRepository().getMovies(_endPoint, requestType: requestType);
      _page = data.page;
      _items = data;
      _itemsStreamController.sink.add(_items);
    } else {
      _page += 1;
      var data = await MainRepository().getMovies(_endPoint,
          requestType: requestType, options: {"page": _page});
      data.page = _page;
      _items = data;

      _items.copyProperties(data);
      _itemsStreamController.sink.add(_items);
    }
  }

  @override
  void dispose() {
    _itemsStreamController.close();
  }
}

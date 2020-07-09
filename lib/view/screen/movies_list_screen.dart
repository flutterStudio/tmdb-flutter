import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/Items_list_bloc.dart';
import 'package:TMDB_Mobile/view/widget/item_stacked_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MoviesListScreen extends StatefulWidget {
  final Data<dynamic> _data;
  final TmdbEndPoint _endPoint;
  final String _title;

  MoviesListScreen(Data<dynamic> data, TmdbEndPoint endPoint, String title)
      : _data = data,
        _title = title,
        _endPoint = endPoint;

  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  ItemsListScreenBloc _bloc;
  RefreshController _refreshController;

  @override
  void initState() {
    _bloc = ItemsListScreenBloc(
        initialData: widget._data, endPoint: widget._endPoint);

    _refreshController = RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: _headerSliverBuilder,
          body: _sliverBuilderBody(context)));

  List<Widget> _headerSliverBuilder(
      BuildContext context, bool innerBoxScrolled) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return [
      SliverAppBar(
        floating: true,
        snap: true,
        backgroundColor: Settings.COLOR_DARK_SECONDARY,
        centerTitle: true,
        title: Text(
          widget._title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Settings.COLOR_DARK_TEXT,
              fontWeight: FontWeight.w300,
              fontSize: screenWidth * Settings.FONT_SIZE_LARGE),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[],
      )
    ];
  }

  Widget _sliverBuilderBody(BuildContext context) {
    return Container(
      color: Settings.COLOR_DARK_PRIMARY,
      child: StreamBuilder<dynamic>(
          stream: _bloc.dataStream, builder: _streamBuilder),
    );
  }

  Widget _streamBuilder(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    Widget customWidget = Center(child: Text("Search in TMDB api"));

    if (snapshot.hasData) {
      switch (snapshot.data.status) {
        case DataStatus.faild:
          {
            customWidget = Center(
                child: Text("Error Fetching Data, Check Your Connection"));
            break;
          }

        case DataStatus.loading:
          {
            customWidget = Center(
              child: SpinKitFadingCube(
                color: Settings.COLOR_DARK_HIGHLIGHT,
              ),
            );
            break;
          }
        case DataStatus.complete:
          {
            customWidget = Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SmartRefresher(
                  enablePullDown: true,
                  onRefresh: () {
                    // _refreshController.requestRefresh();
                    // _bloc.search(RequestType.fetch)
                    //   ..whenComplete(
                    //       () => _refreshController.refreshCompleted());
                  },
                  enablePullUp: true,
                  onLoading: () {
                    if (snapshot.data.hasNext) {
                      _refreshController.requestLoading();
                      _bloc.getData(
                        RequestType.fetchMore,
                      )..whenComplete(() =>
                          snapshot.data.status == DataStatus.complete
                              ? snapshot.data.hasData
                                  ? _refreshController.loadComplete()
                                  : _refreshController.loadNoData()
                              : snapshot.data.status == DataStatus.faild
                                  ? _refreshController.loadFailed()
                                  : _refreshController.requestLoading());
                    } else {
                      _refreshController.loadNoData();
                    }
                  },
                  controller: _refreshController,
                  child: GridView.builder(
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.all(0),
                      itemCount: snapshot.data.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.7),
                      itemBuilder: (context, index) => snapshot.data
                              is Data<List<Movie>>
                          ? ItemStackedView.movie(
                              offline: false,
                              heroTag:
                                  "${Settings.HERO_IMAGE_TAG}_MOVIE_LIST_${widget._endPoint.toString()}_${snapshot.data.data[index].id}",
                              movie: snapshot.data.data[index],
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.35,
                              highlight: index % 2 == 0
                                  ? Settings.COLOR_DARK_PRIMARY
                                  : Settings.COLOR_DARK_HIGHLIGHT,
                            )
                          : ItemStackedView.tv(
                              offline: false,
                              heroTag:
                                  "${Settings.HERO_IMAGE_TAG}_TV_LIST_${widget._endPoint.toString()}_${snapshot.data.data[index].id}",
                              tvShow: snapshot.data.data[index],
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.35,
                              highlight: index % 2 == 0
                                  ? Settings.COLOR_DARK_PRIMARY
                                  : Settings.COLOR_DARK_HIGHLIGHT,
                            ))),
            );
            break;
          }
      }
    }
    return customWidget;
  }
}

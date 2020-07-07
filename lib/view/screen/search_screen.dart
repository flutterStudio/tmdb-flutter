import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/movie.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:TMDB_Mobile/view/bloc/search_bloc.dart';
import 'package:TMDB_Mobile/view/widget/dialog_search_filter.dart';
import 'package:TMDB_Mobile/view/widget/item_stacked_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RefreshController _refreshController;
  TextEditingController _searchFieldController;
  SearchBloc _bloc;
  @override
  void initState() {
    _refreshController = RefreshController();
    _searchFieldController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<SearchBloc>(context);
    _searchFieldController.text = _bloc.query;
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: _headerSliverBuilder,
          body: _sliverBuilderBody(context)),
    );
  }

  List<Widget> _headerSliverBuilder(
      BuildContext context, bool innerBoxScrolled) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return [
      SliverAppBar(
        floating: true,
        snap: true,
        primary: true,
        leading: Container(),
        backgroundColor: Settings.COLOR_DARK_SHADOW,
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: EdgeInsets.all(0),
            title: Container(
                padding: EdgeInsets.only(top: screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Settings.COLOR_DARK_SHADOW,
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: Navigator.of(context).pop,
                      ),
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                  controller: _searchFieldController,
                                  onChanged: (String text) {
                                    _bloc.updateQuery(text);
                                  },
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(
                                      color: Settings.COLOR_DARK_TEXT,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1,
                                      fontSize: screenWidth *
                                          Settings.FONT_SIZE_SMALL),
                                  decoration: InputDecoration(
                                    fillColor: Settings.COLOR_DARK_SHADOW,
                                    hoverColor: Color(0XFFA8A8A8),
                                    filled: true,
                                    disabledBorder: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                        ),
                                        borderSide: BorderSide(
                                            width: 2,
                                            style: BorderStyle.none,
                                            color: Colors.black)),
                                    focusColor: Color(0XFFB809DF),
                                    enabledBorder: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                        ),
                                        borderSide: BorderSide(
                                            style: BorderStyle.none,
                                            width: 2,
                                            color: Colors.black)),
                                    focusedBorder: new OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                        ),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.transparent)),
                                    hintText:
                                        "Search for movie, tv show, artists ..",
                                    hintStyle: TextStyle(
                                        color: Color(0xFFAAAAAA),
                                        fontSize: screenWidth *
                                            Settings.FONT_SIZE_SMALL),
                                  )))),
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        onPressed: () => showDialog(
                          builder: (context) => Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 5),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Settings.GENERAL_BORDER_RADIUS),
                                  child: SearchFilter())),
                          context: context,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () => _bloc.search(RequestType.fetch),
                      ),
                    ]))),
      )
    ];
  }

  Widget _sliverBuilderBody(BuildContext context) {
    return Container(
        color: Settings.COLOR_DARK_PRIMARY,
        child: StreamBuilder<dynamic>(
            stream: _bloc.searchStreams, builder: _streamBuilder));
  }

  Widget _streamBuilder(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    Widget widget = Center(child: Text("Search in TMDB api"));

    if (snapshot.hasData) {
      switch (snapshot.data.status) {
        case DataStatus.faild:
          {
            widget = Center(
                child: Text("Error Fetching Data, Check Your Connection"));
            break;
          }

        case DataStatus.loading:
          {
            widget = Center(
              child: SpinKitFadingCube(
                color: Settings.COLOR_DARK_HIGHLIGHT,
              ),
            );
            break;
          }
        case DataStatus.complete:
          {
            widget = Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: SmartRefresher(
                  enablePullDown: true,
                  onRefresh: () {
                    _refreshController.requestRefresh();
                    _bloc.search(RequestType.fetch)
                      ..whenComplete(
                          () => _refreshController.refreshCompleted());
                  },
                  enablePullUp: true,
                  onLoading: () {
                    if (snapshot.data.hasNext) {
                      _refreshController.requestLoading();
                      _bloc.search(
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
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.6),
                      itemBuilder: (context, index) => snapshot.data
                              is Data<List<Movie>>
                          ? ItemStackedView.movie(
                              offline: false,
                              heroTag:
                                  "${Settings.HERO_IMAGE_TAG}_MOVIE_SEARCH_${snapshot.data.data[index].id}",
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
                                  "${Settings.HERO_IMAGE_TAG}_TV_SEARCH_${snapshot.data.data[index].id}",
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
    return widget;
  }
}

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/widget/item_movie_stacked_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MoviesListScreen extends StatefulWidget {
  @override
  _MoviesListScreenState createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  @override
  Widget build(BuildContext context) => NestedScrollView(
      headerSliverBuilder: _headerSliverBuilder,
      body: _sliverBuilderBody(context));

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
          "Movies List",
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
      child: GridView.builder(
          addAutomaticKeepAlives: true,
          padding: EdgeInsets.all(0),
          itemCount: 20,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.8),
          itemBuilder: (context, index) => MovieStackedView(
                image: "assets/placeholders/poster.jpg",
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.35,
                highlight: index % 2 == 0
                    ? Settings.COLOR_DARK_PRIMARY
                    : Settings.COLOR_DARK_HIGHLIGHT,
                name: "Dark",
              )),
    );
  }
}

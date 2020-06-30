import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/widget/item_movie_stacked_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: _headerSliverBuilder,
            body: _sliverBuilderBody(context)),
      );

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
                                  onSubmitted: null,
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
                        onPressed: null,
                      ),
                    ]))),
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
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.7),
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

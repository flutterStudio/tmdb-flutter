import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/genre.dart';
import 'package:TMDB_Mobile/utils/utils.dart';
import 'package:TMDB_Mobile/view/bloc/search_bloc.dart';
import 'package:TMDB_Mobile/view/widget/genre_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SearchFilter extends StatefulWidget {
  @override
  SearchFilterState createState() => SearchFilterState();
}

typedef OnfieldSubmit = void Function(dynamic value);
typedef OnButtonCLick = void Function();

class SearchFilterState extends State<SearchFilter>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _tabController.addListener(() {
        _tabController.index == 0
            ? context.read<SearchBloc>().updateEndPoint(TmdbEndPoint.discoverTv)
            : _tabController.index == 1
                ? context
                    .read<SearchBloc>()
                    .updateEndPoint(TmdbEndPoint.discoverMovies)
                : context.read<SearchBloc>().updateEndPoint(TmdbEndPoint.all);
      });

      _tabController.animateTo(
          context.read<SearchBloc>().tmdbEndPoint == TmdbEndPoint.discoverTv
              ? 0
              : context.read<SearchBloc>().tmdbEndPoint ==
                      TmdbEndPoint.discoverMovies
                  ? 1
                  : 2);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchBloc searchBloc = Provider.of<SearchBloc>(context);
    final double tabBarHeight = MediaQuery.of(context).size.height * 0.07;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth *
                        Settings.HORIZONTAL_SCREEN_SECTIONS_PADDING),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS),
                    color: Settings.COLOR_DARK_PRIMARY),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                          alignment: Alignment.center,
                          child: Text(
                            "Filters",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Settings.COLOR_DARK_TEXT,
                                fontSize:
                                    screenWidth * Settings.FONT_SIZE_LARGE),
                          )),
                      // Tabbar
                      Container(
                          height: tabBarHeight,
                          decoration: BoxDecoration(
                              color: Settings.COLOR_DARK_SECONDARY,
                              borderRadius:
                                  BorderRadius.circular(tabBarHeight)),
                          child: TabBar(
                            unselectedLabelStyle:
                                TextStyle(fontWeight: FontWeight.w300),
                            controller: _tabController,
                            indicator: BoxDecoration(
                                color: Settings.COLOR_DARK_SHADOW,
                                borderRadius:
                                    BorderRadius.circular(tabBarHeight)),
                            tabs: [
                              Tab(
                                child: Text("TV"),
                              ),
                              Tab(
                                child: Text("Movies"),
                              ),
                              Tab(
                                child: Text("All"),
                              ),
                            ],
                          )),
                      // Sort by.
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _optionText("Sort By",
                                  screenWidth * Settings.FONT_SIZE_MEDIUM),
                              Expanded(
                                flex: 10,
                                child: Container(),
                              ),
                              Consumer<SearchBloc>(
                                  builder: (context, bloc, __) =>
                                      DropdownButton(
                                        items: Settings
                                            .TMDB_SORT_OPTIONS["sort_by"]
                                            .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: _dropDownButon(
                                                    text: e,
                                                    color: Settings
                                                        .COLOR_DARK_TEXT,
                                                    background: Settings
                                                        .COLOR_DARK_SECONDARY,
                                                    border: Settings
                                                        .COLOR_DARK_HIGHLIGHT)))
                                            .toList(),
                                        autofocus: false,
                                        value: bloc.sortBy.isEmpty
                                            ? Settings
                                                .TMDB_SORT_OPTIONS["sort_by"]
                                                .elementAt(0)
                                            : bloc.sortBy,
                                        onChanged: bloc.tmdbEndPoint ==
                                                TmdbEndPoint.all
                                            ? null
                                            : (value) {
                                                bloc.changeSortBy(value);
                                              },
                                        iconDisabledColor:
                                            Settings.COLOR_DARK_SECONDARY,
                                        icon: Container(),
                                        hint: _dropDownButon(
                                            text: "Select an option",
                                            color: Settings.COLOR_DARK_TEXT
                                                .withOpacity(0.5),
                                            background:
                                                Settings.COLOR_DARK_SECONDARY,
                                            border: Settings.COLOR_DARK_SHADOW),
                                        dropdownColor:
                                            Settings.COLOR_DARK_SECONDARY,
                                        disabledHint: _dropDownButon(
                                            text: "Select an option",
                                            color: Settings.COLOR_DARK_TEXT
                                                .withOpacity(0.5),
                                            background:
                                                Settings.COLOR_DARK_SECONDARY,
                                            border: Settings.COLOR_DARK_SHADOW),
                                        underline: Container(),
                                        style: TextStyle(
                                            color: Settings.COLOR_DARK_TEXT,
                                            fontWeight: FontWeight.w600),
                                        onTap: () {},
                                      )),
                            ],
                          )),
                      // Rating Slider
                      _filterSection(
                          context,
                          "Rating",
                          Consumer<SearchBloc>(
                              builder: (context, bloc, __) => Row(children: [
                                    Expanded(
                                        flex: 2,
                                        child: _optionText(
                                            " ${bloc.ratingLow.toStringAsFixed(1)}",
                                            screenWidth *
                                                Settings.FONT_SIZE_SMALL)),
                                    Expanded(
                                        flex: 14,
                                        child: RangeSlider(
                                          values: RangeValues(
                                              bloc.ratingLow, bloc.ratinghigh),
                                          onChanged: bloc.tmdbEndPoint ==
                                                  TmdbEndPoint.all
                                              ? null
                                              : (RangeValues values) {
                                                  context
                                                      .read<SearchBloc>()
                                                      .updateRating(
                                                          values.start,
                                                          values.end);
                                                },
                                          activeColor:
                                              Settings.COLOR_DARK_HIGHLIGHT,
                                          inactiveColor:
                                              Settings.COLOR_DARK_SHADOW,
                                          labels: RangeLabels(
                                              context
                                                  .select((SearchBloc bloc) =>
                                                      bloc.ratingLow)
                                                  .toStringAsFixed(1),
                                              context
                                                  .select((SearchBloc bloc) =>
                                                      bloc.ratinghigh)
                                                  .toStringAsFixed(1)),
                                          // divisions: 100,
                                          min: 0.0,
                                          max: 10,
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: _optionText(
                                            " ${bloc.ratinghigh.toStringAsFixed(1)}",
                                            screenWidth *
                                                Settings.FONT_SIZE_SMALL)),
                                  ]))),
                      // Runtime Slider
                      _filterSection(
                          context,
                          "Runtime (hours)",
                          Consumer<SearchBloc>(
                              builder: (context, bloc, __) => Row(children: [
                                    Expanded(
                                        flex: 2,
                                        child: _optionText(
                                            " ${bloc.runtimeLow.toStringAsFixed(0)}",
                                            screenWidth *
                                                Settings.FONT_SIZE_SMALL)),
                                    Expanded(
                                        flex: 14,
                                        child: RangeSlider(
                                          values: RangeValues(bloc.runtimeLow,
                                              bloc.runtimeHigh),
                                          onChanged: bloc.tmdbEndPoint ==
                                                  TmdbEndPoint.all
                                              ? null
                                              : (RangeValues values) {
                                                  bloc.updateRunTime(
                                                      values.start, values.end);
                                                },
                                          activeColor:
                                              Settings.COLOR_DARK_HIGHLIGHT,
                                          inactiveColor:
                                              Settings.COLOR_DARK_SHADOW,
                                          labels: RangeLabels(
                                              bloc.runtimeLow
                                                  .toStringAsFixed(0),
                                              bloc.runtimeHigh
                                                  .toStringAsFixed(0)),
                                          min: Settings.MIN_MOVIE_RUNTIME,
                                          max: Settings.MAX_MOVIE_RUNTIME,
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: _optionText(
                                            " ${bloc.runtimeHigh.toStringAsFixed(0)}",
                                            screenWidth *
                                                Settings.FONT_SIZE_SMALL)),
                                  ]))),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _optionText("Release Year",
                                  screenWidth * Settings.FONT_SIZE_MEDIUM),
                              Expanded(
                                child: Container(),
                              ),
                              _field(context, "2000", (value) {},
                                  enabled: searchBloc.tmdbEndPoint ==
                                          TmdbEndPoint.all
                                      ? false
                                      : true),
                              SizedBox(
                                width: screenWidth * 0.05,
                              )
                            ],
                          )),
                      _filterSection(
                          context,
                          "With Genres",
                          Container(
                            padding: EdgeInsets.all(5),
                            width: screenWidth * 0.8,
                            constraints: BoxConstraints(
                                minHeight: screenHeight * 0.05,
                                maxHeight: screenHeight * 0.15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Settings.GENERAL_BORDER_RADIUS),
                                color: Settings.COLOR_DARK_SECONDARY),
                            child: StreamBuilder<Map<Genre, bool>>(
                                stream: searchBloc.genresStream,
                                builder: (context,
                                        AsyncSnapshot<Map<Genre, bool>> data) =>
                                    data.hasData && data.data.length > 0
                                        ? Wrap(
                                            alignment: WrapAlignment.start,
                                            runSpacing: 0,
                                            spacing: 0,
                                            children:
                                                _extractGenriesList(data.data))
                                        : Container()),
                          ),
                          action: searchBloc.tmdbEndPoint == TmdbEndPoint.all
                              ? IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Settings.COLOR_DARK_SECONDARY,
                                    size: screenWidth * 0.1,
                                  ),
                                  onPressed: null,
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Settings.COLOR_DARK_HIGHLIGHT,
                                    size: screenWidth * 0.1,
                                  ),
                                  onPressed: () {
                                    searchBloc.getGenres();
                                    Utils.showCustomDialog(
                                        context,
                                        Settings.COLOR_DARK_PRIMARY,
                                        Settings.GENERAL_BORDER_RADIUS,
                                        StreamBuilder<Map<Genre, bool>>(
                                            stream: context
                                                .read<SearchBloc>()
                                                .genresStream,
                                            builder: (context,
                                                    AsyncSnapshot<Map<Genre, bool>>
                                                        data) =>
                                                data.hasError || !data.hasData
                                                    ? Container()
                                                    : Container(
                                                        color: Settings
                                                            .COLOR_DARK_PRIMARY,
                                                        width:
                                                            screenWidth * 0.4,
                                                        height:
                                                            screenHeight * 0.5,
                                                        child: Scaffold(
                                                            body: data.hasData &&
                                                                    data.data.length > 0
                                                                ? ListView.builder(
                                                                    itemCount: data.data.length,
                                                                    itemBuilder: (context, index) => Container(
                                                                        color: Settings.COLOR_DARK_PRIMARY,
                                                                        child: CheckboxListTile(
                                                                          title:
                                                                              Text(
                                                                            data.data.keys.elementAt(index).name,
                                                                            style:
                                                                                TextStyle(color: Settings.COLOR_DARK_TEXT),
                                                                          ),
                                                                          activeColor:
                                                                              Settings.COLOR_DARK_SECONDARY,
                                                                          selected: data
                                                                              .data
                                                                              .values
                                                                              .elementAt(index),
                                                                          checkColor:
                                                                              Settings.COLOR_DARK_HIGHLIGHT,
                                                                          value: data
                                                                              .data
                                                                              .values
                                                                              .elementAt(index),
                                                                          onChanged:
                                                                              (bool value) {
                                                                            int checkedGenresCount =
                                                                                data.data.values.where((element) => element == true).length;
                                                                            if (value &&
                                                                                checkedGenresCount >= 4) {
                                                                              Scaffold.of(context).showSnackBar(SnackBar(backgroundColor: Settings.COLOR_DARK_SECONDARY, content: Text("You can not add mmore than 4 genres")));
                                                                            } else {
                                                                              data.data[data.data.keys.elementAt(index)] = value;
                                                                              searchBloc.updateGenre(data.data.keys.elementAt(index), value);
                                                                            }
                                                                          },
                                                                        )))
                                                                : Text("Loading Genres...")))));
                                  })),

                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _button(
                                  "Reset",
                                  context,
                                  Icons.refresh,
                                  Colors.white,
                                  Settings.COLOR_DARK_SECONDARY, () {
                                searchBloc.reset();
                              }),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              _button(
                                  "Confirm",
                                  context,
                                  Icons.check_circle,
                                  Colors.white,
                                  Settings.COLOR_DARK_HIGHLIGHT, () {
                                searchBloc.applyFilter();
                                Navigator.pop(context);
                              })
                            ],
                          )),
                      SizedBox(
                        height: screenHeight * 0.02,
                      )
                    ],
                  ),
                ))));
  }

  Widget _optionText(String text, double size) => Text(
        text,
        style: TextStyle(
            fontSize: size,
            color: Settings.COLOR_DARK_TEXT,
            fontWeight: FontWeight.w300),
      );

  Widget _filterSection(BuildContext context, String text, Widget child,
      {Widget action}) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.015),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _optionText(
                  text,
                  MediaQuery.of(context).size.width *
                      Settings.FONT_SIZE_MEDIUM),
              action == null ? Container() : action
            ]),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02),
                child: child)
          ],
        ));
  }

  Widget _field(BuildContext context, String hint, OnfieldSubmit onSubmit,
          {FocusNode focusNode, bool enabled = true}) =>
      Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.05,
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Settings.COLOR_DARK_SECONDARY,
                  borderRadius:
                      BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS)),
            ),
            Positioned(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  maxLines: 1,
                  enabled: enabled,
                  autofocus: false,
                  onEditingComplete: enabled ? () {} : null,
                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: enabled ? onSubmit : null,
                  onChanged: enabled ? (value) {} : null,
                  enableInteractiveSelection: false,
                  style: TextStyle(color: Settings.COLOR_DARK_TEXT),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  focusNode: focusNode ?? null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.01,
                          horizontal: MediaQuery.of(context).size.width * 0.02),
                      hintStyle: TextStyle(
                          color: Settings.COLOR_DARK_TEXT.withOpacity(0.8)),
                      hintText: hint,
                      counter: SizedBox.fromSize(
                        size: Size(0, 0),
                      ),
                      filled: true),
                )),
          ]));

  Widget _dropDownButon(
          {String text, Color border, Color background, Color color}) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w400),
        ),
        decoration: BoxDecoration(
            color: background,
            border: Border.all(color: border),
            borderRadius:
                BorderRadius.circular(Settings.GENERAL_BORDER_RADIUS)),
      );

  Widget _button(String text, BuildContext context, IconData icon,
          Color iconColor, Color backgraound, OnButtonCLick onClick) =>
      GestureDetector(
          onTap: onClick,
          child: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.5),
                color: backgraound),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Text(
                    text,
                    style: TextStyle(color: Settings.COLOR_DARK_TEXT),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                ]),
          ));

  List<Widget> _extractGenriesList(Map<Genre, bool> genres) {
    List<Widget> result = [];
    genres.forEach((key, value) {
      value
          ? result.add(GenreWidget(key,
              leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 15,
                  ),
                  onPressed: () =>
                      context.read<SearchBloc>().updateGenre(key, false))))
          : Container();
    });
    return result;
  }
}

import 'package:TMDB_Mobile/common/settings.dart';
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
            : _tabController.index == 0
                ? context
                    .read<SearchBloc>()
                    .updateEndPoint(TmdbEndPoint.discoverMovies)
                : context.read<SearchBloc>().updateEndPoint(TmdbEndPoint.all);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              DropdownButton(
                                items: Settings.TMDB_SORT_OPTIONS["sort_by"]
                                    .map((e) => DropdownMenuItem(
                                        child: _dropDownButon(
                                            text: e,
                                            color: Settings.COLOR_DARK_TEXT,
                                            background:
                                                Settings.COLOR_DARK_SECONDARY,
                                            border:
                                                Settings.COLOR_DARK_HIGHLIGHT)))
                                    .toList(),
                                autofocus: false,
                                onChanged: (value) {
                                  FocusScope.of(context).unfocus(
                                      disposition: UnfocusDisposition
                                          .previouslyFocusedChild);
                                },
                                // itemHeight: screenHeight * 0.08,
                                iconDisabledColor:
                                    Settings.COLOR_DARK_SECONDARY,
                                icon: Container(),
                                hint: _dropDownButon(
                                    text: "Popularity",
                                    color: Settings.COLOR_DARK_TEXT
                                        .withOpacity(0.5),
                                    background: Settings.COLOR_DARK_SECONDARY,
                                    border: Settings.COLOR_DARK_SHADOW),
                                dropdownColor: Settings.COLOR_DARK_SECONDARY,
                                disabledHint: _dropDownButon(
                                    text: "Popularity",
                                    color: Settings.COLOR_DARK_TEXT
                                        .withOpacity(0.5),
                                    background: Settings.COLOR_DARK_SECONDARY,
                                    border: Settings.COLOR_DARK_SHADOW),
                                underline: Container(),
                                style: TextStyle(
                                    color: Settings.COLOR_DARK_TEXT,
                                    fontWeight: FontWeight.w600),
                                onTap: () {},
                              ),
                            ],
                          )),
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
                                          onChanged: (RangeValues values) {
                                            context
                                                .read<SearchBloc>()
                                                .updateRating(
                                                    values.start, values.end);
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
                                          divisions: 100,
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
                            child: Consumer<SearchBloc>(
                                builder: (context, bloc, _) => Wrap(
                                      alignment: WrapAlignment.start,
                                      runSpacing: 0,
                                      spacing: 0,
                                      children: bloc.genres
                                          .map((e) => GenreWidget(
                                                e,
                                                leading: IconButton(
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                    onPressed: () =>
                                                        bloc.removeGenre(e.id)),
                                              ))
                                          .toList(),
                                    )),
                          ),
                          action: PopupMenuButton<int>(
                            color: Settings.COLOR_DARK_PRIMARY,
                            icon: Icon(
                              Icons.add_circle,
                              color: Settings.COLOR_DARK_HIGHLIGHT,
                              size: screenWidth * 0.1,
                            ),
                            onSelected: (int item) {
                              context.read<SearchBloc>().genres.length >
                                      Settings.MAX_GENRES_PER_FILTER
                                  ? Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Sending Message"),
                                    ))
                                  : context.read<SearchBloc>().addGenre(item);
                            },
                            itemBuilder: (context) => context
                                .read<SearchBloc>()
                                .genres
                                .map((e) => CheckedPopupMenuItem<int>(
                                      child: Text(
                                        e.name,
                                        style: TextStyle(
                                            color: Settings.COLOR_DARK_TEXT,
                                            fontSize: screenWidth *
                                                Settings.FONT_SIZE_SMALL),
                                      ),
                                      value: e.id,
                                    ))
                                .toList(),
                          )),
                      _filterSection(
                          context,
                          "Runtime (hours)",
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              _field(context, "1.5", (value) {}),
                              _optionText(
                                  ">", screenWidth * Settings.FONT_SIZE_MEDIUM),
                              _field(context, "3", (value) {}),
                            ],
                          )),

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
                              _field(context, "2000", (value) {}),
                              SizedBox(
                                width: screenWidth * 0.05,
                              )
                            ],
                          )),
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
                                  Settings.COLOR_DARK_SECONDARY,
                                  () {}),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              _button(
                                  "Confirm",
                                  context,
                                  Icons.check_circle,
                                  Colors.white,
                                  Settings.COLOR_DARK_HIGHLIGHT, () {
                                context.read<SearchBloc>().applyFilter();
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
          {FocusNode focusNode}) =>
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
                  autofocus: false,
                  onEditingComplete: () {
                    if (focusNode != null) {
                      focusNode.unfocus();
                    }
                  },
                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: onSubmit,
                  onChanged: (value) {
                    print(value);
                  },
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
}

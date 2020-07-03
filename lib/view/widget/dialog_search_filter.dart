import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/widget/genre_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SearchFilter extends StatefulWidget {
  @override
  SearchFilterState createState() => SearchFilterState();
}

typedef OnfieldSubmit = void Function(dynamic value);
typedef OnfieldEditFinished = void Function(dynamic value);

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
                            tabs: [Text("TV"), Text("Movies"), Text("All")],
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
                                items: [
                                  DropdownMenuItem(
                                      child: _dropDownButon(
                                          text: "Popularity",
                                          color: Settings.COLOR_DARK_TEXT,
                                          background:
                                              Settings.COLOR_DARK_SECONDARY,
                                          border:
                                              Settings.COLOR_DARK_HIGHLIGHT)),
                                  DropdownMenuItem(
                                      child: _dropDownButon(
                                          text: "Popularity",
                                          color: Settings.COLOR_DARK_TEXT,
                                          background:
                                              Settings.COLOR_DARK_SECONDARY,
                                          border:
                                              Settings.COLOR_DARK_HIGHLIGHT)),
                                ],
                                autofocus: false,
                                onChanged: (value) {
                                  FocusScope.of(context).unfocus(
                                      disposition: UnfocusDisposition
                                          .previouslyFocusedChild);
                                },
                                itemHeight: screenHeight * 0.08,
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
                          Row(children: [
                            _optionText(
                                "2.0", screenWidth * Settings.FONT_SIZE_SMALL),
                            Expanded(
                                child: RangeSlider(
                              values: RangeValues(2.0, 8.0),
                              onChanged: (RangeValues values) {},
                              activeColor: Settings.COLOR_DARK_HIGHLIGHT,
                              inactiveColor: Settings.COLOR_DARK_SHADOW,
                              labels: RangeLabels("0.2", "8.0"),
                              divisions: 10,
                              min: 0.0,
                              max: 10,
                            )),
                            _optionText(
                                "8.0", screenWidth * Settings.FONT_SIZE_SMALL),
                          ])),
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
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              runSpacing: 0,
                              spacing: 0,
                              children: _genres,
                            ),
                          ),
                          action: IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Settings.COLOR_DARK_HIGHLIGHT,
                                size: screenWidth * 0.1,
                              ),
                              onPressed: null)),
                      _filterSection(
                          context,
                          "Runtime (hours)",
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              _field(context, "1.5", (value) {}),
                              _optionText("to",
                                  screenWidth * Settings.FONT_SIZE_MEDIUM),
                              _field(context, "3", (value) {}),
                            ],
                          )),
                      _filterSection(
                          context,
                          "Year",
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              _field(context, "2000", (value) {}),
                              _optionText("to",
                                  screenWidth * Settings.FONT_SIZE_MEDIUM),
                              _field(context, "2018", (value) {}),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.5),
                                    color: Settings.COLOR_DARK_SECONDARY),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                      Text(
                                        "Reset",
                                        style: TextStyle(
                                            color: Settings.COLOR_DARK_TEXT),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.5),
                                    color: Settings.COLOR_DARK_HIGHLIGHT),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                      Text(
                                        "Confirm",
                                        style: TextStyle(
                                            color: Settings.COLOR_DARK_TEXT),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.02,
                                      ),
                                    ]),
                              )
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
        style: TextStyle(fontSize: size, color: Settings.COLOR_DARK_TEXT),
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

  final List<Widget> _genres = [
    GenreWidget(
      "Science Fiction",
      leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 15,
          ),
          onPressed: null),
    ),
  ];

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
}

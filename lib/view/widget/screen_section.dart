import 'package:TMDB_Mobile/common/settings.dart';
import 'package:flutter/cupertino.dart';

typedef OnViewMore = void Function();

class ScreenSection extends StatelessWidget {
  final String title;
  final Widget body;
  final OnViewMore onViewMore;
  final double horizontalPadding;
  final Color background;
  ScreenSection(
      {this.body,
      this.title,
      this.onViewMore,
      this.horizontalPadding = 0,
      this.background = Settings.COLOR_DARK_PRIMARY});
  @override
  Widget build(BuildContext context) => Container(
        color: background,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height *
              Settings.VERTICAL_SCREEN_SECTIONS_PADDING,
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                horizontalPadding == 0
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      )
                    : Container(),
                Text(
                  title,
                  style: TextStyle(
                      color: Settings.COLOR_DARK_TEXT,
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.width *
                          Settings.FONT_SIZE_LARGE),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  child: Text(
                    "See More",
                    style: TextStyle(
                        color: Settings.COLOR_DARK_TEXT,
                        fontWeight: FontWeight.w300,
                        fontSize: MediaQuery.of(context).size.width *
                            Settings.FONT_SIZE_SMALL),
                  ),
                  onTap: onViewMore,
                ),
                horizontalPadding == 0
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      )
                    : Container()
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  Settings.VERTICAL_SCREEN_SECTIONS_PADDING,
            ),
            body
          ],
        ),
      );
}

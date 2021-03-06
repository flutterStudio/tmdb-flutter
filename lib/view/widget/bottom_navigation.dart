import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/view/bloc/main_bloc.dart';
import 'package:TMDB_Mobile/view/widget/item_bottom_navigation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  final double _height;
  final Color _background;
  final List<BottomNavigationItem> _items;
  BottomNavigation(
      {@required double height,
      Color background = Settings.COLOR_DARK_PRIMARY,
      Color activeColor = Settings.COLOR_DARK_HIGHLIGHT,
      List<BottomNavigationItem> items,
      List<Widget> pages,
      Color defaultColor = Settings.COLOR_DARK_PRIMARY})
      : _height = height,
        _background = background,
        _items = items;
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => Consumer<MainBloc>(
      builder: (context, mainBloc, staticWidget) => AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: mainBloc.isBottomNavigationUp ? widget._height : 0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: widget._background, boxShadow: [
              BoxShadow(
                  color: Settings.COLOR_DARK_SHADOW,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                  spreadRadius: 2)
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget._items,
            ),
          ));
}

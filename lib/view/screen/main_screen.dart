import 'package:TMDB_Mobile/view/screen/movie_details_screen.dart';
import 'package:TMDB_Mobile/view/screen/movies_list_screen.dart';
import 'package:TMDB_Mobile/view/screen/movies_screen.dart';
import 'package:TMDB_Mobile/view/widget/bottom_navigation.dart';
import 'package:TMDB_Mobile/view/widget/item_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            MoviesScreen(),
            MoviesListScreen(),
            MovieDetailsScreen()
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          height: MediaQuery.of(context).size.height * 0.1,
          items: <BottomNavigationItem>[
            BottomNavigationItem(
              icon: Icons.dashboard,
              size: MediaQuery.of(context).size.height * 0.05,
              onPressed: () {},
            ),
            BottomNavigationItem(
              icon: Icons.favorite,
              size: MediaQuery.of(context).size.height * 0.05,
              onPressed: () {},
            ),
            BottomNavigationItem(
              icon: Icons.search,
              size: MediaQuery.of(context).size.height * 0.05,
              onPressed: () {},
            ),
            BottomNavigationItem(
              icon: Icons.turned_in,
              size: MediaQuery.of(context).size.height * 0.05,
              onPressed: () {},
            )
          ],
        ),
      );
}

import 'package:TMDB_Mobile/view/bloc/main_bloc.dart';
import 'package:TMDB_Mobile/view/screen/movies_list_screen.dart';
import 'package:TMDB_Mobile/view/screen/movies_screen.dart';
import 'package:TMDB_Mobile/view/screen/search_screen.dart';
import 'package:TMDB_Mobile/view/widget/bottom_navigation.dart';
import 'package:TMDB_Mobile/view/widget/item_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Consumer<MainBloc>(
            builder: (context, mainBloc, staticContent) => IndexedStack(
                  index: mainBloc.currentPage,
                  children: <Widget>[
                    MoviesScreen(),
                    MoviesListScreen(),
                  ],
                )),
        bottomNavigationBar: BottomNavigation(
          height: MediaQuery.of(context).size.height * 0.08,
          items: <BottomNavigationItem>[
            BottomNavigationItem(
              index: 0,
              icon: Icons.dashboard,
              size: MediaQuery.of(context).size.height * 0.04,
              onPressed: () {
                context.read<MainBloc>().changeCurrentPage(0);
              },
            ),
            BottomNavigationItem(
              index: 1,
              icon: Icons.favorite,
              size: MediaQuery.of(context).size.height * 0.04,
              onPressed: () {
                context.read<MainBloc>().changeCurrentPage(1);
              },
            ),
            BottomNavigationItem(
              index: 4,
              icon: Icons.search,
              size: MediaQuery.of(context).size.height * 0.04,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
            ),
            BottomNavigationItem(
              index: 2,
              icon: Icons.turned_in,
              size: MediaQuery.of(context).size.height * 0.04,
              onPressed: () {
                context.read<MainBloc>().changeCurrentPage(2);
              },
            )
          ],
        ),
      );
}

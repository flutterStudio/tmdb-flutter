import 'package:TMDB_Mobile/repository/main_repository.dart';
import 'package:TMDB_Mobile/view/bloc/main_bloc.dart';
import 'package:TMDB_Mobile/view/bloc/search_bloc.dart';
import 'package:TMDB_Mobile/view/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  MainRepository().initData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          title: 'TMDB Mobile',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(body: MainScreen()),
        ),
        providers: [
          ChangeNotifierProvider<MainBloc>(
            create: (context) => MainBloc(),
          ),
          ChangeNotifierProvider<SearchBloc>(
            create: (context) => SearchBloc(),
          ),
        ]);
  }
}

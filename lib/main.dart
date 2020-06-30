import 'package:TMDB_Mobile/view/bloc/main_bloc.dart';
import 'package:TMDB_Mobile/view/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TMDB Mobile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ChangeNotifierProvider<MainBloc>(
          create: (context) => MainBloc(),
          child: Scaffold(
            body: MainScreen(),
          ),
        ));
  }
}

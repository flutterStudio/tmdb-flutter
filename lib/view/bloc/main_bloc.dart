import 'package:TMDB_Mobile/view/bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class MainBloc extends Bloc with ChangeNotifier {
  bool _isBottomNavigationUp;
  int _currentPage;

  bool get isBottomNavigationUp => _isBottomNavigationUp;

  int get currentPage => _currentPage;

  void hideBottomNavigation() {
    if (_isBottomNavigationUp) {
      _isBottomNavigationUp = false;
      notifyListeners();
    }
  }

  void showBottomNavigation() {
    if (!_isBottomNavigationUp) {
      _isBottomNavigationUp = true;
      notifyListeners();
    }
  }

  void changeCurrentPage(int index) {
    if (_currentPage != index) {
      _currentPage = index;
      notifyListeners();
    }
  }

  MainBloc() {
    _isBottomNavigationUp = true;
    _currentPage = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

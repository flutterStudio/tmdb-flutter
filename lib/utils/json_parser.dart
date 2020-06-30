import 'dart:convert';

import 'package:TMDB_Mobile/model/model.dart';
import 'package:TMDB_Mobile/model/movie.dart';

class JsonParser {
  /// Parses the given [json] string into the [result] out parameter of type [T].
  static parse<T extends Model>(String json, T result) async {
    var jsonObject = jsonDecode(json);
    if (result is Movie) {
      result = Movie.fromJson(jsonObject) as T;
    }
  }
}

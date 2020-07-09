import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/model/model.dart';
import 'dart:convert';

import 'package:TMDB_Mobile/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Utils {
  static String generateTmdbRerquestUrl(
      TmdbEndPoint endPoint, Map<String, dynamic> options,
      {String spacialOption = ""}) {
    String url = Settings.TMDB_API_BASE_URL +
        Settings.TMDB_ENDPOINTS[endPoint] +
        "${spacialOption != null ? spacialOption : ""}" +
        "?api_key=${Settings.TMDB_API_KEY}" +
        "${spacialOption != null ? "" : _generateOptionsString(options)}";

    return url;
  }

  /// Search options string generating.
  static String _generateOptionsString(Map<String, dynamic> options) {
    String optionsString = "";

    if (options != null) {
      for (int i = 0; i < options.length; i++) {
        String value = "";
        if (options.values.elementAt(i) is List) {
          value = _listToString(options.values.elementAt(i));
        } else {
          value = options.values.elementAt(i).toString();
        }
        if (value.isNotEmpty) {
          optionsString += "&" + options.keys.elementAt(i) + "=" + value;
        }
      }
    }
    return optionsString;
  }

  /// Convvert list to string.
  static String _listToString(List<dynamic> list) {
    String listString = "";
    if (list.length > 0) {
      for (dynamic item in list) {
        listString += ",${item.toString()}";
      }
      listString = listString.substring(1, listString.length);
    }
    return listString;
  }

  /// Parses the given [json] string into the [result] out parameter of type [T].
  static void parseObject<T extends Model>(String json, T result) async {
    var jsonObject = jsonDecode(json);
    T type;
    if (type is Movie) {
      result = Movie.fromJson(jsonObject) as T;
    }
  }

  /// Show Dialog.
  static void showCustomDialog(BuildContext context, Color background,
          double radius, Widget child) =>
      showDialog(
        builder: (context) => Container(
            padding: EdgeInsets.symmetric(vertical: 70, horizontal: 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radius), child: child)),
        context: context,
        // ,
      );

  /// Convert an enum value to string.
  static String enumToString(dynamic value) {
    String result = value
        .toString()
        .substring(value.toString().indexOf('.') + 1, value.toString().length);
    return result;
  }

  static String youtubeThumnail(String id) {
    return "http://img.youtube.com/vi/$id/0.jpg";
  }
}

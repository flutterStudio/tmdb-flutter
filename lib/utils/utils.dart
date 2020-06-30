import 'package:TMDB_Mobile/common/settings.dart';

class Utils {
  static String generateTmdbRerquestUrl(
      TmdbEndPoint endPoint, Map<String, dynamic> options) {
    String url = Settings.TMDB_API_BASE_URL +
        Settings.TMDB_ENDPOINTS[endPoint] +
        "?api_key=${Settings.TMDB_API_KEY}" +
        _generateOptionsString(options);

    return url;
  }

  static String _generateOptionsString(Map<String, dynamic> options) {
    String optionsString = "";

    if (options.length > 0) {
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

  static String _listToString(List<dynamic> list) {
    String listString = "";
    if (list.length > 0) {
      for (dynamic item in list) {
        listString += ",${item.toString()}";
      }
      listString.substring(1, listString.length - 1);
    }
    return listString;
  }
}

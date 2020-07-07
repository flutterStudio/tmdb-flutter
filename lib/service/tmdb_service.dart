import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/utils/exception.dart';
import 'package:TMDB_Mobile/utils/utils.dart';

class TmdbService {
  // Static private instance;
  static TmdbService _instance;

  /// Provides the class's singleton instance for use.
  factory TmdbService() =>
      _instance = _instance == null ? TmdbService._internal() : _instance;

  // Private contructor to initial setup;
  TmdbService._internal();

  HttpClientRequest _httpClientRequest;

  /// Close Http connection.
  void close() {
    if (_httpClientRequest != null) {
      _httpClientRequest.close();
    }
  }

  /// Perform an Http Request to a specific [endPoint] with a map of [options],
  /// You can also specify the [timeout] when the service cancels the request ,
  /// to use the [trending] endpoint make sure to make [trending = true].
  /// Returns a string Response.
  Future<String> get(TmdbEndPoint endPoint, Map<String, dynamic> options,
      {Duration timeout, bool trending = false}) async {
    String requestUrl =
        Utils.generateTmdbRerquestUrl(endPoint, trending ? {} : options);
    HttpClientResponse httpClientResponse;

    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      if (timeout != null) {
        client.connectionTimeout = timeout;
      }

      _httpClientRequest = await client.getUrl(
        Uri.parse(requestUrl),
      );

      httpClientResponse = await _httpClientRequest.close();
    } on SocketException {
      throw DataFetchException(message: "Connection Error");
    } on TimeoutException {
      throw DataFetchException(message: "Request Timeout");
    }
    return _processResponse(httpClientResponse);
  }

  Future<String> _processResponse(HttpClientResponse response) async {
    switch (response.statusCode) {
      case 200:
        {
          String responseString =
              await response.transform(Utf8Decoder()).join();
          return responseString;
        }
      case 400:
        {
          throw DataFetchException(
              message: Settings.HTTP_REQUEST_STATE_CODE[401]);
        }
      case 401:
        {
          throw DataFetchException(
              message: Settings.HTTP_REQUEST_STATE_CODE[401]);
        }
      case 403:
        {
          throw DataFetchException(
              message: Settings.HTTP_REQUEST_STATE_CODE[403]);
        }
      case 404:
        {
          throw DataFetchException(
              message: Settings.HTTP_REQUEST_STATE_CODE[404]);
        }
      case 408:
        {
          throw DataFetchException(
              message: Settings.HTTP_REQUEST_STATE_CODE[408]);
        }
      default:
        {
          throw DataFetchException(message: "Unhandled Exception");
        }
    }
  }
}

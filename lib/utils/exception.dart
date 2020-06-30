import 'package:flutter/foundation.dart';

class DataFetchException implements Exception {
  final String _message;
  DataFetchException({@required String message})
      : _message = message,
        assert(message != null && message.isNotEmpty);

  String get info => "Network Exception, $_message";
}

class DataBaseException implements Exception {
  final String _message;
  DataBaseException({@required String message})
      : _message = message,
        assert(message != null && message.isNotEmpty);

  String get info => "Database Exception, $_message";
}

class JsonExeption implements Exception {
  final String _message;
  JsonExeption({@required String message})
      : _message = message,
        assert(message != null && message.isNotEmpty);

  String get info => "Json Parse Exception, $_message";
}

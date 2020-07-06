import 'dart:async';
import 'dart:typed_data';

import 'package:TMDB_Mobile/common/settings.dart';
import 'package:TMDB_Mobile/utils/data.dart';
import 'package:flutter/widgets.dart';

class AdvancedNetworkImage extends StatelessWidget {
  final String url;
  final Widget placeHolder;
  final Widget loader;

  // Can not be used yetsudo
  AdvancedNetworkImage(this.url, this.placeHolder, this.loader);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Data<Uint8List>>(
        future: getNetworkImage(url),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? snapshot.data.status == DataStatus.complete
                  ? Image.memory(snapshot.data.data)
                  : placeHolder
              : loader;
        });
  }

  /// Gets the Downloaded image file by [NetworkImage] widget.
  ///
  /// Listens to the [ImageStream] of the [NetworkImage].
  ///
  /// Returns a Future of [ImageInfo] for the downloaded `image`
  Future<Data<Uint8List>> getNetworkImage(String image) async {
    Completer completer = Completer<ImageInfo>();
    NetworkImage networkImage = NetworkImage(image);
    var imageStreaam = networkImage.resolve(ImageConfiguration());
    imageStreaam.addListener(ImageStreamListener((ImageInfo info, bool _) {
      info.image.toByteData().then((byteData) {
        Uint8List uintList = byteData.buffer.asUint8List();
        completer.complete(Data.complete(data: uintList));
      });
    }, onError: (dynamic value, StackTrace stacktrace) {
      completer.complete(Data.faild(message: value.toString()));
    }));
    return completer.future;
  }
}

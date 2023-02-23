import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class CustomizeMarkerICon {
  late String assetPath;
  late int assetWidth;
  late Uint8List markerIcon;

  CustomizeMarkerICon(this.assetPath, this.assetWidth) {
    setICon();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setICon() async {
    markerIcon = await getBytesFromAsset(assetPath, assetWidth);
  }

  Uint8List getMarkerIConAsBytes() {
    return markerIcon;
  }
}

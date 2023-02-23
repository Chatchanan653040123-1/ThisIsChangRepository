// ignore: file_names
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<dynamic> listMoto = [
  [16.472119, 102.825444, "EN04"],
  [16.472361, 102.824580, "PHO"],
  [16.474032, 102.823235, "N50"]
];

List<dynamic> listCar = [
  [16.471208, 102.824758, "Car zone A"],
  [16.471218, 102.824117, "Car zone C"],
  [16.471457, 102.822973, "Car zone E"]
];

Future<void> addMakerListToSetMoto(Set setIn) async {
  var listSize = listMoto.length;
  for (var i = 0; i < listSize; i++) {
    setIn.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(listMoto[i][2]),
      position: LatLng(listMoto[i][0], listMoto[i][1]),
      // ignore: prefer_const_constructors
      infoWindow: InfoWindow(
        title: listMoto[i][2], //title message on mark @ChangNoi
        snippet:
            "This marker park of ${listMoto[i][2]}", //snippet message on mark @ChangNoi
      ),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(1, 1)),
          "assets/images/motoPinGreen2.png"),
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      visible: true, // if GPS ON it's visible
    ));
  }
}

Future<void> addMakerListToSetCar(Set setIn) async {
  var listSize = listCar.length;
  for (var i = 0; i < listSize; i++) {
    setIn.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(listCar[i][2]),
      position: LatLng(listCar[i][0], listCar[i][1]),
      // ignore: prefer_const_constructors
      infoWindow: InfoWindow(
        title: listCar[i][2], //title message on mark @ChangNoi
        snippet:
            "This marker park of ${listCar[i][2]}", //snippet message on mark @ChangNoi
      ),
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(1,1)),
          "assets/images/carPinRed2.png"),
      visible: true, // if GPS ON it's visible
    ));
  }
}

import 'dart:async';
import 'dart:math';
import 'package:app01/navbar/Item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app01/Atom/CustomizeMarkerICon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:app01/navbar/NavbarController.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/services.dart';
import 'package:app01/Atom/Marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:custom_info_window/custom_info_window.dart';

const List<Widget> vehicle = <Widget>[
  ImageIcon(AssetImage("assets/images/car.png")),
  ImageIcon(AssetImage("assets/images/moto.png"))
];

class SimpleMaps extends StatefulWidget {
  const SimpleMaps({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static GlobalKey test() {
    return _MyAppState._globalKey;
  }

  void openDrawerCus() {
    _MyAppState().openDrawerCus();
  }
}

class _MyAppState extends State<SimpleMaps> {
  //String googleApikey = "AIzaSyCMBfP4py6zjtDQEUby3HeXWl4jpfv5wTM";// use in android.xml
  String googleApikey =
      "AIzaSyCMBfP4py6zjtDQEUby3HeXWl4jpfv5wTM"; // use in android.xml
  Completer<GoogleMapController> _controller = Completer();
  static bool gpsON = false;
  bool isExtended = false;
  Set<Marker> _markers = {};
  static double btnSize = 36;
  AssetImage arrow_sign = AssetImage("assets/images/arrow_sign.png");
  final List<bool> _selectedVehicle = <bool>[false, false];

  final List<bool> isSelected = <bool>[false, true, false];
  static GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  static double currentLocationLatitude = 16.472955;
  static double currentLocationlongitude = 102.823042;
  static double radiusMark = 0.0031;
  static bool polylinesVisible = false;
  static late Uint8List userProfile;
  static LatLng _center = LatLng(16.472955, 102.823042);
  bool motoIconPress = false;
  bool carIconPress = false;
  LatLng _pinPosition = _center;
  PolylinePoints polylinePoints = PolylinePoints();
  static CustomizeMarkerICon currentLocationICon =
      CustomizeMarkerICon('assets/images/noiPic.png', 150);
  Map<PolylineId, Polyline> polylines = {}; // polylines to show direction
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  static void getProFileImage() async {
    final auth = FirebaseAuth.instance;
    try {
      userProfile =
          (await NetworkAssetBundle(Uri.parse(auth.currentUser!.photoURL!))
                  .load(auth.currentUser!.photoURL!))
              .buffer
              .asUint8List();

      //print(auth.currentUser!.photoURL!);
    } catch (e) {
      userProfile = currentLocationICon.getMarkerIConAsBytes();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _customInfoWindowController.googleMapController = controller;
  }

  // camera on move
  LatLng _lastMapPosition = _center;
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    _customInfoWindowController.onCameraMove!();
  }

  MapType _currentMapType = MapType.hybrid;
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  Future<void> addMakerCarMoto(bool vehicle) async {
    Map<String, dynamic> place = {};
    late BitmapDescriptor iconOfVehicle;
    //String path;
    if (vehicle) {
      iconOfVehicle = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(1, 1)), "assets/images/carPinRed2.png");
    } else {
      iconOfVehicle = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(1, 1)),
          "assets/images/motoPinGreen2.png");
    }
    place = await GetDataMarker.getPlace(vehicle);
    // // Fetch content from the json file
    // final String response = await rootBundle.loadString(path);
    // final data = await json.decode(response);
    List<dynamic> _parkList = [];
    try {
      _parkList = place["placeParking"];
    } catch (e) {
      _parkList = [];
    }

    var listSize = _parkList.length;
    for (var i = 0; i < listSize; i++) {
      double latitude = _parkList[i]["Latitude"] as double;
      double longitude = _parkList[i]["Longitude"] as double;

      // radius to add
      if (sqrt((pow((_pinPosition.latitude - latitude), 2)) +
              pow((_pinPosition.longitude - longitude), 2)) >
          radiusMark) {
        continue;
      }
      //debugPrint("Marker add");
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_parkList[i]["placeID"] as String),
        position: LatLng(latitude, longitude),
        //infoWindow: InfoWindow(title: "test", snippet: "testt"),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                        width: 300,
                        height: 100,
                        child: Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Name :",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(_parkList[i]["placeID"]),
                                const Text("Status :",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const Text("<No data>")
                              ]),
                        )),
                  ),
                  Container(
                      width: 100,
                      height: 40,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(),
                        color: Colors.transparent,
                      ),
                      child: Row(
                        children: <Widget>[
                          FloatingActionButton(
                            onPressed: () async {
                              _markers.clear();
                              // set new pin
                              _pinPosition = LatLng(latitude, longitude);
                              _onAddMarkerpin();
                            },
                            backgroundColor: Colors.green,
                            child: Icon(Icons.add_location, size: 36.0),
                          ),
                          // FloatingActionButton(
                          //   onPressed: () async {
                          //     null;
                          //   },
                          //   child: Icon(Icons.gps_fixed, size: 40),
                          // ),
                        ],
                      ))
                ],
              ),
              LatLng(latitude, longitude)); // args 2
          setState(() {});
        },
        icon: iconOfVehicle,
        visible: true,
      ));
    }
  }

  void _onAddMarkerpin() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: const MarkerId("Your Pin Location"),
        position: _pinPosition, //Position on mark @ChangNoi
        infoWindow: const InfoWindow(
          title: "Your Pin Location", //title message on mark @ChangNoi
          snippet: 'message', //snippet message on mark @ChangNoi
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  //------------------------------currentLocation part
  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }
  //---------------------------------

  Future<LocationData?> _currentLocation2() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = new Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }

  // set maker //pin
  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition, //Position on mark @ChangNoi
        infoWindow: InfoWindow(
          title: _lastMapPosition.toString(), //title message on mark @ChangNoi
          snippet: 'message', //snippet message on mark @ChangNoi
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _AddMarkerCurrentLocation() async {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("CurrentLocation"),
        position: LatLng(currentLocationLatitude, currentLocationlongitude),
        // ignore: prefer_const_constructors
        infoWindow: InfoWindow(
          title: "Your current location", //title message on mark @ChangNoi
          snippet:
              "This marker shows your current location.", //snippet message on mark @ChangNoi
        ),
        icon: BitmapDescriptor.fromBytes(userProfile), //! change the picture
        visible: false, // if GPS ON it's viisble
      ));
    });
  }

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
      gpsON = true;
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      debugPrint("ERROR $error");
      gpsON = false;
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> syncLocation() async {
    getUserCurrentLocation().then((value) async {
      // ignore: avoid_print
      debugPrint("${value.latitude} ${value.longitude}");
      currentLocationLatitude = value.latitude;
      currentLocationlongitude = value.longitude;

      // specified current users location
      // ignore: unnecessary_new
      CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 16,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<void> animateCameraCurrentLocation() async {
    debugPrint("$currentLocationLatitude $currentLocationlongitude");
    // specified current users location
    // ignore: unnecessary_new
    CameraPosition cameraPosition = new CameraPosition(
      target: LatLng(currentLocationLatitude, currentLocationlongitude),
      zoom: 16,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  void realTimeLocationTask() async {
    getUserCurrentLocation().then((value) async {
      // ignore: avoid_print
      debugPrint("${value.latitude} ${value.longitude}");
      getProFileImage();
      _AddMarkerCurrentLocation();
      currentLocationLatitude = value.latitude;
      currentLocationlongitude = value.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    //realTimeLocationTask();
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      drawer: item(),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              GoogleMap(
                onTap: (position) {
                  _customInfoWindowController.hideInfoWindow!();
                  isDialOpen.value = false;
                  setState(() {});
                },
                onMapCreated: _onMapCreated,
                zoomGesturesEnabled: true, //zoom in out
                mapType: _currentMapType,
                onCameraMove: _onCameraMove,
                compassEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                myLocationEnabled: true, // current locate button
                markers: _markers,
                mapToolbarEnabled: false,
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 200,
                width: 150,
                offset: 30,
              ),
              Center(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    //! Pinpoint
                    // Container(
                    //   width: 150,
                    //   height: 150,
                    //   child: Image.asset("assets/images/pinpoint.png" , scale: 5),
                    // ),
                    Positioned(child: Text("Some text"), bottom: -25),
                  ],
                ),
              ),
              Column(
                children: [
                  NavbarController(), //! navbar
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 16, 16),
                      child: SpeedDial(
                        renderOverlay: false,
                        direction: SpeedDialDirection.right,
                        childPadding: EdgeInsets.all(5),
                        childrenButtonSize: Size(75, 50),
                        backgroundColor: Color(0xFF1C82AD),
                        // openCloseDial: isDialOpen,
                        // onOpen: () {
                        //   isDialOpen.value = false;
                        // },
                        child: Icon(
                          Icons.radar,
                          size: 36,
                        ),
                        children: [
                          SpeedDialChild(
                            child: FloatingActionButton.extended(
                              onPressed: () {},
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(0xFF1C82AD),
                              label: Text("500m"),
                            ),
                          ),
                          SpeedDialChild(
                            child: FloatingActionButton.extended(
                              onPressed: () {},
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(0xFF1C82AD),
                              label: Text("1km"),
                            ),
                          ),
                          SpeedDialChild(
                            child: FloatingActionButton.extended(
                              onPressed: () {},
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(0xFF1C82AD),
                              label: Text("All"),
                            ),
                          ),
                          SpeedDialChild(
                            child: FloatingActionButton.extended(
                              label: Text("Range",
                                  style: TextStyle(color: Colors.black)),
                              onPressed: null,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //!Focus to Pin
               Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 7, 1),
                // padding: EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.small(
                        backgroundColor: Color(0xFF0e2f44),
                        onPressed: () async {
                          animateCameraCurrentLocation();
                        },
                        // child: Icon(Icons.location_on, size: 36),
                        child: ImageIcon(
                            AssetImage("assets/images/location.png"),
                            size: 20),
                      ),
                      //!CurrentLocation
                      // SizedBox(height: 70),
                      SizedBox(height: 1),

                      Container(
                        padding: EdgeInsets.zero,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          // border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: ToggleButtons(
                          direction: axisDirectionToAxis(AxisDirection.up),

                          // direction: vertical ? Axis.vertical : Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              // if (index == 0) {
                              //   _markers.clear();
                              //   addMakerCarMoto(false); //Car
                              // } else {
                              //   _markers.clear();
                              //   addMakerCarMoto(true); //Motorcycle
                              // }
                              // List<bool> count = [true,false];
                              if (index == 0 && carIconPress == false) {
                                carIconPress = true;
                                motoIconPress = false;
                                addMakerCarMoto(true); //Car
                              } else if (index == 1 && motoIconPress == false) {
                                motoIconPress = true;
                                carIconPress = false;
                                addMakerCarMoto(false); // Motorcycle
                              } else {
                                motoIconPress = false;
                                carIconPress = false;
                              }

                              for (int i = 0;
                                  i < _selectedVehicle.length;
                                  i++) {
                                if (i == index) {
                                  _selectedVehicle[i] = !_selectedVehicle[i];
                                } else {
                                  _selectedVehicle[i] = false;
                                }
                                // _selectedVehicle[i] = i == index;
                              }
                              _markers.clear();
                            });
                          },

                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          selectedBorderColor: Colors.white,
                          fillColor: Colors.white,
                          selectedColor: Colors.green[800],
                          color: Colors.grey[850],
                          isSelected: _selectedVehicle,

                          children: vehicle,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              Padding(
                // padding: EdgeInsets.only(bottom: 16, top: 16, right: 16, left: 5),
                padding: EdgeInsets.fromLTRB(10, 16, 16, 16),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: FloatingActionButton.small(
                        backgroundColor: Color(0xFF0e2f44),
                        // mini: true,
                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        child: Icon(Icons.layers, size: 25.0),
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SpeedDial(
                        renderOverlay: false,
                        direction: SpeedDialDirection.right,
                        label: Text("Pin the location"),
                        backgroundColor: Color(0xFF02A8A8),
                        child: ImageIcon(arrow_sign, size: 20),
                        activeLabel: Text('Back'),
                        activeChild: ImageIcon(arrow_sign, size: 20),
                        animationAngle: 0, // rotate the icon
                        buttonSize: Size(45, 45),
                        childrenButtonSize: Size(50, 50),
                        openCloseDial: isDialOpen,
                        children: [
                          SpeedDialChild(
                            child: FloatingActionButton(
                              onPressed: () async {
                                gpsON = false;
                                _markers.clear();
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(0xFFFF8B13),
                              child: Icon(Icons.lock),
                            ),
                          ),
                          SpeedDialChild(
                            child: FloatingActionButton(
                              onPressed: _onAddMarkerButtonPressed,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(0xFF03C988),
                              child: Icon(Icons.add_location, size: 36.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void openDrawerCus() {
    _globalKey.currentState?.openDrawer();
  }
}

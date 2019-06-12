import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:instrument/src/screens/generate_wom/bloc.dart';
import 'package:instrument/src/screens/request_confirm/request_confirm.dart';
import 'package:location/location.dart';

class PositionSelectionPage extends StatefulWidget {
  @override
  _PositionSelectionPageState createState() => _PositionSelectionPageState();
}

class _PositionSelectionPageState extends State<PositionSelectionPage> {
  GenerateWomBloc bloc;

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 11.0,
  );

  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;

  Marker requestMarker = Marker(markerId: MarkerId("Temp"));
  Set<Marker> markers = Set();

  LocationData _startLocation;
  LocationData _currentLocation;

//  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = new Location();
  bool _permission = false;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _currentCameraPosition;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
//          location = await _locationService.getLocation();
//
//          _locationSubscription = _locationService
//              .onLocationChanged()
//              .listen((LocationData result) async {
//            _currentCameraPosition = CameraPosition(
//                target: LatLng(result.latitude, result.longitude), zoom: 16);
//
//            final GoogleMapController controller = await _controller.future;
//            controller.animateCamera(
//                CameraUpdate.newCameraPosition(_currentCameraPosition));
//
//            if (mounted) {
//              setState(() {
//                _currentLocation = result;
//              });
//            }
//          });
          _updateMyLocation();
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        print(e.message);
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        print(e.message);
      }
      print("location = null");
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  _onMapCreated(GoogleMapController mapController) {
    _controller.complete(mapController);
  }

  void _updateCameraPosition(CameraPosition position) {

  }

  _updateMyLocation() async {
    print("_updateMyLocation");
    LocationData location;
    try {
      print("getLocation()");
      location = await _locationService.getLocation();
      print(location.latitude.toString());
      print(location.longitude.toString());
      final target = LatLng(location.latitude, location.longitude);
      _currentCameraPosition = CameraPosition(target: target, zoom: 16);

      final GoogleMapController controller = await _controller.future;

      if (mounted) {
        print("updateCurrentLocation()");
        _updateCurrentLocation(target);
        controller.animateCamera(
            CameraUpdate.newCameraPosition(_currentCameraPosition));
//        setState(() {
//          _currentLocation = location;
//        });
      }
    } on PlatformException catch (e) {
      print(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      location = null;
    }
  }

  //Add pin to tapped position
  _onTapMap(LatLng location) {
    _updateCurrentLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<GenerateWomBloc>(context);
    final isValid = bloc.isValidPosition;

    Marker marker = Marker(
      markerId: MarkerId("my_position"),
      position: bloc.currentPosition ?? bloc.lastPosition,
      infoWindow: InfoWindow(title: 'Request Location', snippet: '*'),
    );

    final GoogleMap googleMap = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: bloc.lastPosition ?? LatLng(0, 0),
        zoom: 11.0,
      ),
      minMaxZoomPreference: _minMaxZoomPreference,
      myLocationEnabled: true,
      onCameraMove: _updateCameraPosition,
      markers: {marker},
      onTap: _onTapMap,
//      compassEnabled: _compassEnabled,
//      cameraTargetBounds: _cameraTargetBounds,
//      mapType: _mapType,
//      rotateGesturesEnabled: _rotateGesturesEnabled,
//      scrollGesturesEnabled: _scrollGesturesEnabled,
//      tiltGesturesEnabled: _tiltGesturesEnabled,
//      zoomGesturesEnabled: _zoomGesturesEnabled,
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Column(
          children: <Widget>[
            Container(
              height: 180.0,
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text(
                "Seleziona un punto sulla mappa",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  googleMap,
                  Positioned(
                    left: 5.0,
                    top: 5.0,
                    child: Card(
                      child: Container(
                        height: 37.0,
                        width: 37.0,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(
                            Icons.update,
                            size: 21.0,
                          ),
                          onPressed: _updateMyLocation,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 20.0,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              height: 50.0,
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => bloc.goToPreviousPage(),
                child: Text(
                  "Back",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: isValid
            ? FloatingActionButton(
                onPressed: () {
                  bloc.saveCurrentPosition();
                  goToRequestScreen();
                },
              )
            : null,
      ),
    );
  }

  goToRequestScreen() async {
    final womRequest = await bloc.createModelForCreationRequest();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => RequestConfirmScreen(
          womRequest: womRequest,
        ),
      ),
    );
  }

  void _updateCurrentLocation(LatLng target) {
    bloc.currentPosition = target;
//    final MarkerId markerId = MarkerId('Request Position');
//
//    Marker marker = Marker(
//      markerId: markerId,
//      position: target,
//      infoWindow: InfoWindow(title: 'Request Location', snippet: '*'),
//    );

    setState(() {
//      markers.clear();
//      markers.add(marker);
    });
  }

  @override
  void dispose() {
    print("dispose map page");
    super.dispose();
  }
}

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum StatusLocation { on, off }

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }
  LocationService._internal();

  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  Stream<Position>? _positionStream;
  late StreamSubscription<Position> _posStream;

  Stream<Position>? get positionStream => _positionStream;
  StreamSubscription<Position> get posStream => _posStream;

  // void startListening() async {
  //   bool isOnLocation = await checkPermission();
  //   print('Is on permisson: ${isOnLocation}');
  //   if (isOnLocation) {
  //     print('Get Location');
  //     _positionStream = _geolocator.getPositionStream(
  //       locationSettings: const LocationSettings(
  //         accuracy: LocationAccuracy.best,
  //         distanceFilter: 2,
  //       ),
  //     );
  //     _posStream = _positionStream!.listen((event) {
  //       print('Stream: ${event.latitude} - ${event.longitude}');
  //     });
  //   } else {
  //     Position? lastPosition = await _geolocator.getLastKnownPosition();
  //     _positionStream = Stream.value(lastPosition!);
  //   }
  // }

  void startListening() async {
    print('Get Location');
    _positionStream = _geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2,
      ),
    );
    _posStream = _positionStream!.listen((event) {
      print('Stream: ${event.latitude} - ${event.longitude}');
    });
  }

  Future<StatusLocation> onError() async {
    bool isOnLocation = await checkPermission();
    return isOnLocation ? StatusLocation.on : StatusLocation.off;
  }

  Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return false;
      // permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied) {
      //   return false;
      // }
    }
    return true;
    // bool isOnLocation = await Permission.location.serviceStatus.isEnabled;
    // LocationPermission permission = await Geolocator.checkPermission();
    // if (isOnLocation) {
    //   var status = await Permission.location.status;
    //   if (status.isGranted) {
    //     return true;
    //   } else{
    //     var test = await Permission.locationAlways.request();
    //     permission = await Geolocator.requestPermission();
    //     return test.isGranted;
    //   }
    // }
    // return false;
  }
}

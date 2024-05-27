import 'package:geolocator/geolocator.dart';
class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  factory LocationManager() => _instance;

  LocationManager._internal();

  final Geolocator _geolocator = Geolocator();
  Position? _currentPosition;

  Future<void> updateLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  double? get latitude => _currentPosition?.latitude;
  double? get longitude => _currentPosition?.longitude;
}
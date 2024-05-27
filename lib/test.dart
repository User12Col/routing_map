import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/service.dart';

void main() async {
  List<LatLng> locations = [
    const LatLng(10.855108769921356, 106.78539025876572),
    const LatLng(10.868912145143323, 106.71334729544051),
    const LatLng(10.793523435766183, 106.70047263674702),
    const LatLng(10.795316740047932, 106.72183410976515),
    const LatLng(10.827739408061202, 106.70005288092932),
    const LatLng(10.760106812985049, 106.68224756558291)
  ];
  List<int>? results = await ApiService().getListWayPointIndex(locations);

  print(results![0]);
}

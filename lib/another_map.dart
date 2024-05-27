import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_tracking/marker_infor.dart';
import 'package:location_tracking/service.dart';

class AnotherMapPage extends StatefulWidget {
  const AnotherMapPage({Key? key}) : super(key: key);

  @override
  State<AnotherMapPage> createState() => _AnotherMapPageState();
}

class _AnotherMapPageState extends State<AnotherMapPage> {
  final LatLng srcLocation = LatLng(10.759284, 106.585716);
  final LatLng desLocation = LatLng(10.759284, 106.635716);
  List<LatLng> locations = [
    const LatLng(10.855108769921356, 106.78539025876572),
    const LatLng(10.868912145143323, 106.71334729544051),
    const LatLng(10.793523435766183, 106.70047263674702),
    const LatLng(10.795316740047932, 106.72183410976515),
    const LatLng(10.827739408061202, 106.70005288092932),
    const LatLng(10.760106812985049, 106.68224756558291)
  ];
  LocationData? currLocation;

  Set<Polyline> polylines = {};

  @override
  void initState() {
    getCurrLocation();
    super.initState();
    getPolyline1(locations);
  }

  void getCurrLocation() {
    Location location = Location();
    location.getLocation().then((value) {
      currLocation = value;
    });
  }

  void getPolyline1(List<LatLng> locations) async {
    List<int>? results = await ApiService().getListWayPointIndex(locations);
    List<LatLng> newLocations = sortedLocations(locations, results!);
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> allPoints = [];

    for (int i = 0; i < newLocations.length - 1; i++) {
      print('Draw: $i and ${i + 1}');
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyA1MgLuZuyqR_OGY3ob3M52N46TDBRI_9k',
        PointLatLng(newLocations[i].latitude, newLocations[i].longitude),
        PointLatLng(
            newLocations[i + 1].latitude, newLocations[i + 1].longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach(
          (PointLatLng pointLatLng) {
            allPoints.add(
              LatLng(pointLatLng.latitude, pointLatLng.longitude),
            );
          },
        );
      }
    }
    setState(() {
      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          points: allPoints,
          width: 4,
        ),
      );
    });
  }

  List<LatLng> sortedLocations(List<LatLng> locations, List<int> positions) {
    List<LatLng> sortedCoordinates = List<LatLng>.from(locations);
    List<MapEntry<int, LatLng>> zipped = List.generate(locations.length,
        (index) => MapEntry(positions[index], locations[index]));

    zipped.sort((a, b) => a.key.compareTo(b.key));

    for (int i = 0; i < zipped.length; i++) {
      sortedCoordinates[i] = zipped[i].value;
    }

    return sortedCoordinates;
  }

  Set<Marker> createMakers(List<LatLng> locations) {
    Set<Marker> makers = {};
    locations.forEach((element) {
      makers.add(Marker(
        markerId: MarkerId('2'),
        position: element,
        onTap: () {
          showMarkerInformation();
        },
      ));
    });
    return makers;
  }

  void showMarkerInformation() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MarkerInfor();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Roads screen: ${polylines.length}');
    return Scaffold(
      body: SafeArea(
        child: currLocation == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height - 50,
                // width: MediaQuery.of(context).size.width - 20,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          currLocation!.latitude!, currLocation!.longitude!),
                      zoom: 14.5),
                  markers: createMakers(locations),
                  // polylines: polylines,
                  polylines: polylines,
                ),
              ),
      ),
    );
  }
}

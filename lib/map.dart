import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng srcLocation = LatLng(10.759284, 106.585716);
  final LatLng desLocation = LatLng(10.759284, 106.635716);

  List<LatLng> latLngs = [];
  List<LatLng> locations = [
    LatLng(10.868912145143323, 106.71334729544051),
    LatLng(10.793523435766183, 106.70047263674702),
    LatLng(10.795316740047932, 106.72183410976515),
    LatLng(10.827739408061202, 106.70005288092932),
    LatLng(10.855108769921356, 106.78539025876572),
    LatLng(10.760106812985049, 106.68224756558291)
  ];
  LocationData? currLocation;

  Set<Polyline> polylines = {};

  Set<Marker> makers = {
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(10.868912145143323, 106.71334729544051)),
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(10.793523435766183, 106.70047263674702)),
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(10.795316740047932, 106.72183410976515)),
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(10.827739408061202, 106.70005288092932)),
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(10.855108769921356, 106.78539025876572)),
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(10.760106812985049, 106.68224756558291)),
  };

  void getCurrLocation() {
    Location location = Location();
    location.getLocation().then((value) {
      currLocation = value;
    });
  }

  void getLine() async {
    PolylinePoints polylinePoints = PolylinePoints();
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //   'AIzaSyAqf9xoO0PcoqLL4gDGB9IWU1A8lwJlfMI',
    //   PointLatLng(srcLocation.latitude, srcLocation.longitude),
    //   PointLatLng(desLocation.latitude, desLocation.longitude),
    // );

    PolylineRequest polylineRequest = PolylineRequest(
      apiKey: 'AIzaSyA-7j-MqqDwYh80uVKoXkSOD1CpKynJlYE',
      origin: const PointLatLng(10.868912145143323, 106.71334729544051),
      destination: const PointLatLng(10.760106812985049, 106.68224756558291),
      mode: TravelMode.driving,
      wayPoints: [
        PolylineWayPoint(location: '10.827739408061202%2C106.70005288092932')
      ],
      avoidHighways: true,
      avoidTolls: false,
      avoidFerries: true,
      optimizeWaypoints: true,
      alternatives: true,
    );

    List<PolylineResult> results =
        await polylinePoints.getRouteWithAlternatives(request: polylineRequest);

    // if (result.points.isNotEmpty) {
    //   result.points.forEach(
    //     (PointLatLng pointLatLng) => latLngs.add(
    //       LatLng(pointLatLng.latitude, pointLatLng.longitude),
    //     ),
    //   );
    //   setState(() {});
    // }

    results.forEach((element) {
      if (element.points.isNotEmpty) {
        element.points.forEach(
          (PointLatLng pointLatLng) => latLngs.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude),
          ),
        );
      }
    });
  }

  void getPolyline(List<LatLng> locations) async {
    PolylinePoints polylinePoints = PolylinePoints();
    locations.forEach((element) async {
      print('Element ${locations[0].latitude} and Element ${element.latitude}');
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyAqf9xoO0PcoqLL4gDGB9IWU1A8lwJlfMI',
        PointLatLng(locations[0].latitude, locations[0].longitude),
        PointLatLng(element.latitude, element.longitude),
        travelMode: TravelMode.driving,
      );

      // List<LatLng> roadLatlngs = [];

      if (result.points.isNotEmpty) {
        result.points.forEach(
          (PointLatLng pointLatLng) => latLngs.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude),
          ),
        );
        print('Add');
        polylines.add(
          Polyline(
            polylineId: PolylineId('10'),
            color: Colors.blue,
            points: latLngs,
            width: 4,
          ),
        );
        print('Roads: ${polylines.length}');
        // latLngs.clear();
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    getCurrLocation();
    super.initState();
    // getLine();
    getPolyline(locations);
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
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height - 50,
                // width: MediaQuery.of(context).size.width - 20,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          currLocation!.latitude!, currLocation!.longitude!),
                      zoom: 14.5),
                  markers: makers,
                  // polylines: polylines,
                  polylines: polylines,
                ),
              ),
      ),
    );
  }
}

                    // Marker(markerId: MarkerId('desID'), position: srcLocation),
                    // Marker(
                    //   markerId: MarkerId('id'),
                    //   position: LatLng(
                    //       currLocation!.latitude!, currLocation!.longitude!),
                    // ),
                    // Marker(markerId: MarkerId('desID'), position: desLocation),


                  //   {
                  //   Polyline(
                  //     polylineId: PolylineId('lineID'),
                  //     points: latLngs,
                  //     color: Colors.blue,
                  //     width: 4,
                  //   )
                  // }

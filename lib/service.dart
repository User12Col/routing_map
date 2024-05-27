import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<int>?> getListWayPointIndex(List<LatLng> latlngs) async {
    try {
      int size = latlngs.length;
      List<LatLng> sublist = latlngs.sublist(1, size - 1);
      String wayPointString = sublist
          .map((latLng) => '${latLng.latitude},${latLng.longitude}')
          .join(';');
      final response = await http.Client().get(
        Uri.https(
          'rsapi.goong.io',
          '/trip',
          {
            'origin': '${latlngs[0].latitude},${latlngs[0].longitude}',
            'waypoints': wayPointString,
            'destination':
                '${latlngs[size - 1].latitude},${latlngs[size - 1].longitude}',
            'api_key': 'bZHqTteyO4o1IzRpaaIj797VaVrubtVDQDXjz2h1',
            'vehicle': 'car',
          },
        ),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        final result = mapResponse['waypoints'] as List<dynamic>;
        List<int> wayPointIndexs = [];
        result.forEach((element) {
          final wayPointIndex = element['waypoint_index'];
          wayPointIndexs.add(wayPointIndex);
        });
        return wayPointIndexs;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

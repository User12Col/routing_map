  class LocationState {
    final double lat;
    final double lng;

    LocationState({this.lat = 0.0, this.lng = 0.0});

    LocationState copyWith({double? lat, double? lng}){
      return LocationState(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );
    }
  }
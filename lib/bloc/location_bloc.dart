import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking/bloc/location_event.dart';
import 'package:location_tracking/bloc/location_state.dart';
import 'package:location_tracking/location_service.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService;
  late StreamSubscription<Position>? _positionSubscription;
  LocationBloc({required LocationService locationService})
      : _locationService = locationService,
        super(LocationState()) {
    on<EventLoadLocation>(loadingLocation);
  }

  Future<void> loadingLocation(
      EventLoadLocation event, Emitter<LocationState> emit)async {
    try {
      _locationService.startListening();
      _positionSubscription = _locationService.positionStream?.listen((Position position) {
        emit(state.copyWith(lat: position.latitude, lng: position.longitude));
      });
      await _positionSubscription!.asFuture();
    } catch (e) {
      emit(state.copyWith());
    }
  }
}

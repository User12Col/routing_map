import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/another_map.dart';
import 'package:location_tracking/bloc/location_bloc.dart';
import 'package:location_tracking/location_service.dart';
import 'package:location_tracking/map.dart';
import 'package:location_tracking/result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
            create: (context) =>
                LocationBloc(locationService: LocationService())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: AnotherMapPage(),
      ),
    );
  }
}

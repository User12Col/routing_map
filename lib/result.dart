import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking/location_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with WidgetsBindingObserver {
  late LocationService _locationService;
  @override
  void initState() {
    super.initState();
    print('Init state');
    WidgetsBinding.instance.addObserver(this);
    _locationService = LocationService();
    // _locationService.startListening();
    _changePermission();
  }

  void _changePermission() async {
    final result = await _locationService.checkPermission();
    print(result);
    if (result){
      _locationService.startListening();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print("Inactive");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        _changePermission();
        break;
      case AppLifecycleState.resumed:
        print("Resumed");
        _changePermission();
        break;
      case AppLifecycleState.hidden:
        print("Suspending");
        break;
      case AppLifecycleState.detached:
        print("Suspending");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _locationService.positionStream,
          builder: (context, snapshot) {
            print('Buid UI');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              print('${snapshot.data!.latitude} - ${snapshot.data!.longitude}');
              return Center(
                child: Text(
                  '${snapshot.data!.latitude} - ${snapshot.data!.longitude}',
                ),
              );
            } else if(!snapshot.hasData){
              return const Center(child: Text('No data'),);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

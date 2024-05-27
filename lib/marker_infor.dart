import 'package:flutter/material.dart';

class MarkerInfor extends StatelessWidget {
  const MarkerInfor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: Text('Loc'),
      ),
    );
  }
}

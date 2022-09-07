import 'package:flutter/material.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';

class navigation extends StatefulWidget {
  @override
  _SpincircleState createState() => _SpincircleState();
}

class _SpincircleState extends State<Spincircle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SpinCircleBottomBarHolder(
      bottomNavigationBar: SCBottomBarDetails(items: [
        SCBottomBarItem(icon: Icons.add, onPressed: () {}),
        SCBottomBarItem(icon: Icons.notifications, onPressed: () {}),
        SCBottomBarItem(icon: Icons.gps_not_fixed, onPressed: () {}),
        SCBottomBarItem(icon: Icons.gps_not_fixed, onPressed: () {}),
      ], circleItems: [
        SCItem(icon: Icon(Icons.add), onPressed: () {}),
        SCItem(icon: Icon(Icons.add), onPressed: () {})
      ], circleColors: [
        Colors.blue,
        Colors.blue
      ]),
      child: Container(),
    ));
  }
}

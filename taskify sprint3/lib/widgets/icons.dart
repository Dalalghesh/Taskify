import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const purple = Color(0xFF756BFC);
const pink = Color(0xFFF1A39A);
const deepPink = Color(0xFFFA63C6);
const green = Color(0xFF41CF9F);
const yellow = Color(0xFFEEC38E);
const lightBlue = Color(0xFF42A5F5);
const blue = Color(0xFF2860E6);

const personIcon = 0xe491;
const workIcon = 0xe11c;
const movieIcon = 0xe40f;
const sportIcon = 0xe4dc;
const travelIcon = 0xe071;
const shopIcon = 0xe59c;

List<Icon> getIcons() {
  return const [
    Icon(
      IconData(personIcon, fontFamily: 'MaterialIcons'),
      color: purple,
    ),
    Icon(
      IconData(workIcon, fontFamily: 'MaterialIcons'),
      color: pink,
    ),
    Icon(
      IconData(movieIcon, fontFamily: 'MaterialIcons'),
      color: green,
    ),
    Icon(
      IconData(sportIcon, fontFamily: 'MaterialIcons'),
      color: yellow,
    ),
    Icon(
      IconData(travelIcon, fontFamily: 'MaterialIcons'),
      color: deepPink,
    ),
    Icon(
      IconData(shopIcon, fontFamily: 'MaterialIcons'),
      color: lightBlue,
    )
  ];
}

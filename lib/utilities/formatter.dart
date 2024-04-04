import 'package:flutter/material.dart';

Widget genderWidget(String? gender) {
  switch (gender) {
    case "m":
      {
        return const Row(children: <Widget>[
          Icon(
            Icons.male,
            color: Colors.amberAccent,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'male',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          )
        ]);
      }
    case "f":
      {
        return const Row(children: <Widget>[
          Icon(
            Icons.female,
            color: Colors.amberAccent,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'female',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          )
        ]);
      }
  }
  return const Row(children: <Widget>[
    Icon(
      Icons.male,
      color: Colors.amberAccent,
    ),
    SizedBox(
      width: 10,
    ),
    Text(
      'prefer not to say',
      style: TextStyle(color: Colors.grey, fontSize: 16),
    )
  ]);
}




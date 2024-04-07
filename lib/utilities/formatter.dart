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

Widget genderImageWidget(String? gender, {double? radius}) {
  switch (gender) {
    case "m":
      {
        return  CircleAvatar(
          backgroundImage: const AssetImage(
            "assets/images/profile-default-male.jpg",
          ),
          radius: radius,
        );
      }
    case "f":
      {
        return  CircleAvatar(
          backgroundImage: const AssetImage(
            "assets/images/profile-default-female.jpg",
          ),
          radius: radius,
        );
      }
  }
  return  CircleAvatar(
    backgroundImage: const AssetImage(
      "assets/images/profile-default-female.jpg",
    ),
    radius: radius,
  );
}

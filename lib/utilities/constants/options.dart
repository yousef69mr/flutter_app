import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/utilities/constants/types.dart';

List<RadioOption> genders = [
  RadioOption(key: "Male", value: 'm'),
  RadioOption(key: "Female", value: 'f'),
  // RadioOption(key: "Other", value: 'null'),
];

List<SelectOption<int>> levels = [
  SelectOption(key: const Text('1'), value: 1),
  SelectOption(key: const Text('2'), value: 2),
  SelectOption(key: const Text('3'), value: 3),
  SelectOption(key: const Text('4'), value: 4),
  // RadioOption(key: "Other", value: 'null'),
];

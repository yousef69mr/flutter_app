
import 'package:flutter/cupertino.dart';

class RadioOption {
  final String key;
  final String value;

  RadioOption({required this.key, required this.value});
}


class SelectOption<T> {
  final Widget key;
  final T value;

  SelectOption({required this.key, required this.value});
}
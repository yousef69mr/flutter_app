import 'package:flutter/material.dart';

Widget textField({
  required TextEditingController fieldController,
  required Function(String?) fieldValidate,
  required IconData icon,
  required String label,
  required String placeholder,
  bool? enabled = true,
}) {
  return TextFormField(
    controller: fieldController,
    validator: (value) => fieldValidate(value),
    enabled: enabled,
    style: const TextStyle(color: Colors.amberAccent),
    decoration: InputDecoration(
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.amberAccent,
          width: 2,
        ),
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.amberAccent,
      ),
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      hintText: placeholder,
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );
}

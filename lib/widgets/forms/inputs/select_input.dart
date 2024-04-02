import 'package:flutter/material.dart';

import 'package:flutter_application_1/utilities/constants/types.dart';

class SelectField<T> extends StatefulWidget {
  final TextEditingController selectController;
  final List<SelectOption<T>> selectOptions;
  final T? defaultValue;
  final String label;
  final String placeholder;
  final Function(String? d)? validator;
  final bool enabled;

  const SelectField({
    super.key,
    this.validator,
    required this.label,
    required this.placeholder,
    required this.selectController,
    required this.selectOptions,
    this.defaultValue,
    required this.enabled,
  });

  @override
  State<SelectField<T>> createState() => _SelectFieldState<T>();
}

class _SelectFieldState<T> extends State<SelectField<T>> {
  @override
  void initState() {
    super.initState();
    // Set the default value
    if (widget.defaultValue != null) {
      widget.selectController.text = widget.defaultValue!.toString();
    }
    // widget.selectController = (widget.defaultValue ?? "");
  }

  String _convertValueToString(T value) {
    // Convert the value to string representation
    return value.toString();
  }

  T _convertStringToValue(String value) {
    if (T == int) {
      return int.parse(value) as T;
    } else if (T == double) {
      return double.parse(value) as T;
    }

    // For custom types, you need to provide your own conversion logic
    // Example:
    // else if (T == YourCustomType) {
    //   return YourCustomType.fromString(value) as T;
    // }
    throw UnimplementedError(
        'Conversion from String to $T is not implemented.');
  }

  @override
  Widget build(BuildContext context) {
    String? message;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
          ),
          DropdownButton<T>(
            isExpanded: true,
            value: widget.selectController.text.isNotEmpty
                ? _convertStringToValue(widget.selectController.text)
                : widget.defaultValue,
            hint: Text(
              widget.placeholder,
              style: const TextStyle(color: Colors.grey),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            // iconSize: 24,
            style: TextStyle(
                color: widget.selectController.text.isEmpty
                    ? Colors.black
                    : Colors.amberAccent),
            underline: Container(
              height: 2,
              color: Colors.amberAccent,
            ),
            items: widget.selectOptions
                .map<DropdownMenuItem<T>>((SelectOption option) {
              return DropdownMenuItem<T>(
                value: option.value,
                child: option.key,
              );
            }).toList(),
            onChanged: widget.enabled
                ? (T? newValue) {
                    setState(() {
                      message = widget.validator!(newValue.toString());
                      widget.selectController.text =
                          _convertValueToString(newValue as T);
                    });
                  }
                : null,
          ),
          if (message != null)
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
        ]);
  }
}

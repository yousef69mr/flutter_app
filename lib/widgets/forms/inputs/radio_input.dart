import 'package:flutter/material.dart';

import 'package:flutter_application_1/utilities/constants/types.dart';

class RadioField extends StatefulWidget {
  final TextEditingController radioController;
  final List<RadioOption> radioOptions;
  final String? defaultValue;
  final String label;

  const RadioField(
      {super.key,
      required this.label,
      required this.radioController,
      required this.radioOptions,
      this.defaultValue});

  @override
  State<RadioField> createState() => _RadioFieldState();
}

class _RadioFieldState extends State<RadioField> {
  @override
  void initState() {
    super.initState();
    // Set the default value
    widget.radioController.text = (widget.defaultValue ?? "");
  }

  @override
  Widget build(BuildContext context) {
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
        Row(
          children: widget.radioOptions.map((option) {
            return Row(
              children: [
                Radio<String>(
                  value: option.value,
                  groupValue: widget.radioController.text,
                  onChanged: (value) {
                    setState(() {
                      widget.radioController.text = value!;
                    });
                  },
                  activeColor: Colors.amberAccent,
                ),
                Text(
                  option.key,
                  style: TextStyle(
                      color: widget.radioController.text == option.value
                          ? Colors.amberAccent
                          : Colors.grey),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

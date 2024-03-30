import 'package:flutter/material.dart';

class StandardLoading extends StatefulWidget {
  const StandardLoading({super.key});

  @override
  State<StandardLoading> createState() => _StandardLoadingState();
}

class _StandardLoadingState extends State<StandardLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(30),child: const Icon(Icons.bubble_chart_rounded),);
  }
}

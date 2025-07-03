import 'package:flutter/material.dart';
import '/models/store.dart';
import '/widgets/helpers/osm_map.dart';

class StoresMapScreen extends StatefulWidget {
  final List<Store> stores;

  const StoresMapScreen({super.key, required this.stores});

  @override
  State<StoresMapScreen> createState() => _StoresMapScreenState();
}

class _StoresMapScreenState extends State<StoresMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.amberAccent,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.grey),
        title: const Text(
          'Stores location',
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: OSMStoreMap(
          stores: widget.stores,
        ),
      ),
    );
  }
}

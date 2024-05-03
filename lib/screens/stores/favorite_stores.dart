import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/services/auth.dart';
import 'package:provider/provider.dart';

import '../../models/store.dart';
import '../../utilities/services/stores.dart';
import '../../widgets/cards/store-card.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

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
          'Favorite Stores',
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: FutureBuilder<List<Store>>(
            future: storeProvider.getStoresFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final stores = snapshot.data ?? [];
                // print(stores);
                if (stores.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Stores found !',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return StoreCard(store: store);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

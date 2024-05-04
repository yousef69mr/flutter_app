import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/favorite_store.dart';
import 'package:flutter_application_1/utilities/helpers/location.dart';
import 'package:flutter_application_1/utilities/services/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '/utilities/services/stores.dart';
import '/models/store.dart';

class StoreCard extends StatefulWidget {
  final Store store;

  const StoreCard({super.key, required this.store});

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    Future<Position?> userLocation = getCurrentLocation();
    bool isFavorite = storeProvider.isFavoriteStore(widget.store);

    return Card(
      color: Colors.grey[850],
      child: ListTile(
        title: Text(widget.store.name,
            style: const TextStyle(
              color: Colors.amberAccent,
            )),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.store.longitude.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.store.latitude.toString(),
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            FutureBuilder<Position?>(
              future: userLocation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userLatitude = snapshot.data!.latitude;
                  final userLongitude = snapshot.data!.longitude;

                  // print(userLongitude);
                  // print(userLatitude);
                  final distance = widget.store
                      .calculateDistance(userLatitude, userLongitude);
                  return Text(
                    '${distance.toInt()} m',
                    style: TextStyle(color: Colors.grey.shade600),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error getting location');
                }
                return const SizedBox(
                  height: 10,
                  width: 80,
                  child: LinearProgressIndicator(
                    color: Colors.amberAccent,
                    backgroundColor: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite,
            color: isFavorite ? Colors.amberAccent : null,
          ),
          onPressed: () async {
            Map<String, String> data = {
              "storeId": widget.store.id,
              "userId": auth.user!.id,
            };

            // ApiConfig.setToken(auth.authToken!);
            if (!isFavorite) {
              await storeProvider.addToFavorites(data);
            } else {
              FavoriteStore? favoriteStore =
                  await storeProvider.getFavoriteStoreForStore(
                      storeId: widget.store.id, userId: auth.user!.id);

              await storeProvider.removeFromFavorites(
                  favoriteStoreId: favoriteStore!.id);
            }

            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
      ),
    );
  }
}

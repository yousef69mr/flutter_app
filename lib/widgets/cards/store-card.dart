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
    Position? userLocation;
    bool isFavorite = storeProvider.isFavoriteStore(widget.store);

    return Card(
      color: Colors.grey[850],
      child: ListTile(
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey[850],
                title: const Text(
                  "Calculating distance...",
                  style: TextStyle(color: Colors.grey),
                ),
                content: const CircularProgressIndicator(
                  color: Colors.amberAccent,
                ), // Loading indicator
              );
            },
          );

          userLocation = await getCurrentLocation();

          if (userLocation != null) {
            final userLatitude = userLocation?.latitude;
            final userLongitude = userLocation?.longitude;

            final distance =
                widget.store.calculateDistance(userLatitude!, userLongitude!);
            if (mounted) {
              Navigator.pop(context);

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.grey[850],
                      title: const Text(
                        "Distance from store",
                        style: TextStyle(color: Colors.grey),
                      ),
                      content: Text(
                        "${distance.toInt()} m",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "OK",
                            style: TextStyle(color: Colors.amberAccent),
                          ),
                        ),
                      ],
                    );
                  });
            }
          } else {
            if (mounted) {
              Navigator.pop(context);
            }
          }
        },
        title: Text(
          widget.store.name,
          style: const TextStyle(
            color: Colors.amberAccent,
          ),
        ),
        subtitle: Row(
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
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(
                Icons.location_searching_rounded,
                color: Colors.amberAccent,
              ),
              onPressed: () async {},
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

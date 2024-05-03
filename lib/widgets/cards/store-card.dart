import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/favorite_store.dart';
import 'package:flutter_application_1/utilities/services/auth.dart';
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

    bool isFavorite = storeProvider.isFavoriteStore(widget.store);
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        // leading: Text(widget.store.calculateDistance(userLatitude, userLongitude).toString()),
        title: Text(widget.store.name,
            style: const TextStyle(
              color: Colors.amberAccent,
            )),
        subtitle: Row(
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

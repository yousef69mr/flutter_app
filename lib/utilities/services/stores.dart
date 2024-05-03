import "package:flutter/material.dart";
import "package:flutter_application_1/models/favorite_store.dart";

import "package:flutter_application_1/utilities/sql_database.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:geolocator/geolocator.dart";

import "package:sqflite/sqflite.dart";
import "../helpers/location.dart";
import "/models/store.dart";
import "api_config.dart";
import "auth.dart";

// Function to convert a list of dynamic objects (from API response) to a list of Store objects
List<Store> convertApiStoresToList(dynamic data) {
  List<Store> stores = [];

  if (data is List) {
    stores = data.map((storeJson) => Store.fromJson(storeJson)).toList();
  } else if (data is Map<String, dynamic>) {
    // If data is a single object, convert it to a list with one item
    stores.add(Store.fromJson(data));
  }

  return stores;
}

List<FavoriteStore> convertApiFavoriteStoresToList(dynamic data) {
  List<FavoriteStore> stores = [];

  if (data is List) {
    stores =
        data.map((storeJson) => FavoriteStore.fromJson(storeJson)).toList();
  } else if (data is Map<String, dynamic>) {
    // If data is a single object, convert it to a list with one item
    stores.add(FavoriteStore.fromJson(data));
  }

  return stores;
}

class StoreProvider extends ChangeNotifier {
  final Auth auth;

  StoreProvider(this.auth);

  List<Store> stores = [];
  List<Store> favoriteStores = [];

  List<Store> get storesData => stores;

  List<Store> get favoriteStoresData => favoriteStores;

  final SqlDatabase _sqlDatabase = SqlDatabase();

  Future<void> fetchFavoriteStoresFromApi() async {
    final responseData = await ApiConfig.get('/favorite_stores');

    List<FavoriteStore> apiFavoriteStores = convertApiFavoriteStoresToList(
        responseData); // Fetch stores from API, e.g., using http package

    // Store fetched stores in SQLite database
    await _sqlDatabase.executeTransaction((txn) async {
      final batch = txn.batch();
      for (var store in apiFavoriteStores) {
        batch.insert(
          "favorite_stores",
          store.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    });

    notifyListeners();
  }

  Future<void> fetchAndStoreStoresFromAPI() async {
    // Fetch stores from API
    final responseData = await ApiConfig.get('/stores');

    List<Store> apiStores = convertApiStoresToList(
        responseData); // Fetch stores from API, e.g., using http package
    // print(responseData);
    // Store fetched stores in SQLite database
    await _sqlDatabase.executeTransaction((txn) async {
      final batch = txn.batch();
      for (var store in apiStores) {
        batch.insert(
          "stores",
          store.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    });

    notifyListeners();
  }

  Future<List<Store>> getStoresFromDatabase() async {
    try {
      ApiConfig.setToken(auth.authToken!);
      await fetchAndStoreStoresFromAPI();
      await fetchFavoriteStoresFromApi();
    } catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    try {
      final List<Map<String, dynamic>> storesQuery =
          await _sqlDatabase.readData('''
    SELECT * FROM "stores"
    ''');

      // print(favoriteStores);
      final List<Map<String, dynamic>> favoriteStoresQuery =
          await _sqlDatabase.readData('''
    SELECT s.* FROM "stores" AS s
    LEFT JOIN "favorite_stores" 
    ON s.id = favorite_stores.storeId 
    WHERE favorite_stores.userId='${auth.user!.id}'
    ''');
      // print(favoriteStoresQuery);

      stores = convertApiStoresToList(storesQuery);
      favoriteStores = convertApiStoresToList(favoriteStoresQuery);


      // Position userLocation = await getCurrentLocation();
      // stores.sort((a, b) => a.calculateDistance(userLocation.latitude, userLocation.longitude).compareTo(b.calculateDistance(userLocation.latitude, userLocation.longitude)));
      return stores;
    } catch (e) {
      // print(e);
      return [];
    } finally {
      notifyListeners();
    }
  }

  Future<void> addToFavorites(Map<String, String> data) async {
    // print(data);
    try {
      Map<String, dynamic> response =
          await ApiConfig.post('/favorite_stores', data);

      FavoriteStore favoriteStore = FavoriteStore.fromJson(response);

      await _sqlDatabase.insertData('''
  INSERT INTO favorite_stores(id, storeId, userId, createdAt) VALUES('${favoriteStore.id}', '${favoriteStore.storeId}', '${favoriteStore.userId}', '${favoriteStore.createdAt}')
''');

      final List<Map<String, dynamic>> favoriteStoresQuery =
          await _sqlDatabase.readData('''
    SELECT s.* FROM "stores" AS s
    LEFT JOIN "favorite_stores" 
    ON s.id = favorite_stores.storeId 
    WHERE favorite_stores.userId='${auth.user!.id}'
    ''');
      favoriteStores = convertApiStoresToList(favoriteStoresQuery);

      Fluttertoast.showToast(
        msg: 'added to favorites',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // print('error');
    } finally {
      notifyListeners();
    }
  }

  Future<FavoriteStore?> getFavoriteStoreForStore(
      {required String storeId, required String userId}) async {
    final List<Map<String, dynamic>> favoriteStoreQuery =
        await _sqlDatabase.readData('''
    SELECT * FROM "favorite_stores" WHERE storeId='$storeId' and userId='$userId'
    ''');

    return FavoriteStore.fromJson(favoriteStoreQuery[0]);
  }

  Future<void> removeFromFavorites({required String favoriteStoreId}) async {
    try {
      await ApiConfig.delete('/favorite_stores/$favoriteStoreId');

      await _sqlDatabase.deleteData('''
          DELETE FROM "favorite_stores" WHERE id='$favoriteStoreId'
          ''');

      final List<Map<String, dynamic>> favoriteStoresQuery =
          await _sqlDatabase.readData('''
    SELECT s.* FROM "stores" AS s
    LEFT JOIN "favorite_stores" 
    ON s.id = favorite_stores.storeId 
    WHERE favorite_stores.userId='${auth.user!.id}'
    ''');
      favoriteStores = convertApiStoresToList(favoriteStoresQuery);

      Fluttertoast.showToast(
        msg: 'store removed from favorites',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      // print('error');
    } finally {
      notifyListeners();
    }
  }

  bool isFavoriteStore(Store store) {
    Store? response =
        favoriteStores.where((temp) => temp.id == store.id).firstOrNull;

    return response != null;
  }
}

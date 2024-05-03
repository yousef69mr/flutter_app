import 'dart:math';

class Store {
  String id;
  String name;

  // String location;
  double longitude;
  double latitude;
  DateTime? createdAt;

  Store({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.createdAt,
  });

  Store.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        latitude = json["latitude"],
        longitude = json["longitude"],
        createdAt = json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude':latitude,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Store{id: $id, name: $name, longitude: $longitude, latitude: $latitude, createdAt: $createdAt}';
  }

  double calculateDistance(double userLatitude, double userLongitude) {
    const double earthRadius = 6371e3; // Earth radius in meters

    var lat1 = radians(latitude);
    var lat2 = radians(userLatitude);

    var dLat = radians(userLatitude - latitude);
    var dLon = radians(userLongitude - longitude);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

// Helper function to convert degrees to radians
  double radians(double degrees) {
    return degrees * pi / 180;
  }
}

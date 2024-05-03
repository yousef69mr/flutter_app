class FavoriteStore {
  String id;
  String storeId;
  String userId;
  DateTime? createdAt;

  FavoriteStore({
    required this.id,
    required this.storeId,
    required this.userId,
    this.createdAt,
  });

  FavoriteStore.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        userId = json["userId"],
        storeId = json["storeId"],
        createdAt = json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'storeId': storeId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'FavoriteStore{id: $id, userId: $userId, storeId: $storeId, createdAt: $createdAt}';
  }

}

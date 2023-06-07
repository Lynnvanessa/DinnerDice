class _PlaceGeometry {
  final _PlaceLocation location;

  _PlaceGeometry(this.location);

  factory _PlaceGeometry.fromJson(Map<String, dynamic> json) {
    return _PlaceGeometry(_PlaceLocation.fromJson(json));
  }
}

class _PlaceLocation {
  final double? lat;
  final double? lng;

  _PlaceLocation(this.lat, this.lng);

  factory _PlaceLocation.fromJson(Map<String, dynamic> json) {
    return _PlaceLocation(
      double.tryParse("${json["location"]["lat"]}"),
      double.tryParse("${json["location"]["lng"]}"),
    );
  }
}

class NearbyPlace {
  final String? name;
  final String? vicinity;
  final _PlaceGeometry geometry;
  final String placeId;
  final double? rating;
  final int? userRatingTotal;
  final String? icon;

  NearbyPlace({
    required this.name,
    required this.vicinity,
    required this.geometry,
    required this.placeId,
    required this.rating,
    required this.userRatingTotal,
    required this.icon,
  });

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    return NearbyPlace(
      name: json["name"],
      vicinity: json["vicinity"],
      geometry: _PlaceGeometry.fromJson(json["geometry"]),
      placeId: json["place_id"],
      rating: double.tryParse("${json["rating"]}"),
      userRatingTotal: json["user_ratings_total"] ?? 0,
      icon: json["icon"],
    );
  }
}

class LocationCarResponse {
  final List<LocationCar> locations;

  LocationCarResponse({required this.locations});

  factory LocationCarResponse.fromJson(Map<String, dynamic> json) {
    return LocationCarResponse(
      locations: (json['data']['locations'] as List)
          .map((e) => LocationCar.fromJson(e))
          .toList(),
    );
  }
}

class LocationCar {
  final int id;
  final String name;
  final String? image;
  final String mapLat;
  final String mapLng;
  final String carsCount;

  LocationCar({
    required this.id,
    required this.name,
    this.image,
    required this.mapLat,
    required this.mapLng,
    required this.carsCount,
  });

  factory LocationCar.fromJson(Map<String, dynamic> json) {
    return LocationCar(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      mapLat: json['map_lat'],
      mapLng: json['map_lng'],
      carsCount: json['cars_count'],
    );
  }
}

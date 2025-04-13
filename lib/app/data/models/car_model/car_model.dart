class CarResponse {
  final List<CarModel> cars;
  final int total;
  final int totalPages;
  final int currentPage;
  final int perPage;

  CarResponse({
    required this.cars,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.perPage,
  });

  factory CarResponse.fromJson(Map<String, dynamic> json) {
    return CarResponse(
      cars: (json['data']['cars'] as List)
          .map((e) => CarModel.fromJson(e))
          .toList(),
      total: json['data']['total'] ?? 0,
      totalPages: json['data']['total_pages'] ?? 1,
      currentPage: json['data']['current_page'] ?? 1,
      perPage: json['data']['per_page'] ?? 10,
    );
  }
}

class CarModel {
  final int id;
  final String title;
  final String slug;
  final String content;
  final int number;
  final int isInstant;
  final int imageId;
  final int locationId;
  final String address;
  final String gallery;
  final int price;
  final int salePrice;
  final String? discountPercent;
  final String image;
  final String reviewScore;
  final String fuelCapacity;
  final String rentalDuration;
  final String driverType;
  final int passenger;
  final String status;
  final double? distance;
  final LocationModel? location;
  final dynamic translation;
  final WishListModel? hasWishList;
  final String brand;
  final String model;
  final String transmissionType;
  final String fuelType;
  final int isFeatured;
  final String carType;
  final int enableExtraPrice;
  bool isFavorite;

  CarModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.number,
    required this.isInstant,
    required this.imageId,
    required this.locationId,
    required this.address,
    required this.gallery,
    required this.price,
    required this.salePrice,
    this.discountPercent,
    required this.image,
    required this.reviewScore,
    required this.fuelCapacity,
    required this.rentalDuration,
    required this.driverType,
    required this.passenger,
    required this.status,
    this.distance,
    this.location,
    this.translation,
    this.hasWishList,
    required this.brand,
    required this.model,
    required this.transmissionType,
    required this.fuelType,
    required this.isFeatured,
    required this.carType,
    required this.enableExtraPrice,
    required this.isFavorite,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      number: json['number'] ?? 0,
      isInstant: json['is_instant'] ?? 0,
      imageId: json['image_id'] ?? 0,
      locationId: json['location_id'] ?? 0,
      address: json['address'] ?? '',
      gallery: json['gallery'] ?? '',
      price: json['price'] ?? 0,
      salePrice: json['sale_price'] ?? 0,
      discountPercent: json['discount_percent'],
      image: json['image'] ?? '',
      reviewScore: json['review_score'] ?? '0',
      fuelCapacity: json['fuel_capacity'] ?? '',
      rentalDuration: json['rental_duration'] ?? '',
      driverType: json['driver_type'] ?? '',
      passenger: json['passenger'] ?? 0,
      status: json['status'] ?? '',
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null,
      location: json['location'] != null ? LocationModel.fromJson(json['location']) : null,
      translation: json['translation'] ?? '',
      hasWishList: json['has_wish_list'] != null ? WishListModel.fromJson(json['has_wish_list']) : null,
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      transmissionType: json['transmission_type'] ?? '',
      fuelType: json['fuel_type'] ?? '',
      isFeatured: json['is_featured'] ?? 0,
      carType: json['car_type'] ?? '',
      enableExtraPrice: json['enable_extra_price'] ?? 0,
      isFavorite: json['wishlist_status'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Car{id: $id, title: $title, slug: $slug, content: $content, number: $number, isInstant: $isInstant, imageId: $imageId, locationId: $locationId, address: $address, gallery: $gallery, price: $price, salePrice: $salePrice, discountPercent: $discountPercent, image: $image, reviewScore: $reviewScore, fuelCapacity: $fuelCapacity, rentalDuration: $rentalDuration, driverType: $driverType, passenger: $passenger, status: $status, distance: $distance, location: $location, translation: $translation, hasWishList: $hasWishList, brand: $brand, model: $model, transmissionType: $transmissionType, fuelType: $fuelType, isFeatured: $isFeatured, carType: $carType, enableExtraPrice: $enableExtraPrice}';
  }
}

class LocationModel {
  final int id;
  final String name;
  final String mapLat;
  final String mapLng;

  LocationModel({
    required this.id,
    required this.name,
    required this.mapLat,
    required this.mapLng,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      mapLat: json['map_lat'].toString(),
      mapLng: json['map_lng'].toString(),
    );
  }
}

class WishListModel {
  final int id;
  final int objectId;
  final String objectModel;
  final int userId;
  final int createUser;
  final int? updateUser;
  final DateTime createdAt;
  final DateTime updatedAt;

  WishListModel({
    required this.id,
    required this.objectId,
    required this.objectModel,
    required this.userId,
    required this.createUser,
    this.updateUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WishListModel.fromJson(Map<String, dynamic> json) {
    return WishListModel(
      id: json['id'],
      objectId: json['object_id'],
      objectModel: json['object_model'],
      userId: json['user_id'],
      createUser: json['create_user'],
      updateUser: json['update_user'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

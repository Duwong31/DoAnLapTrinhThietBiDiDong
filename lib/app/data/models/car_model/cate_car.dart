class CateCarResponse {
  final List<Brand> brands;

  CateCarResponse({required this.brands});

  factory CateCarResponse.fromJson(Map<String, dynamic> json) {
    return CateCarResponse(
      brands: (json['data']['brands'] as List)
          .map((e) => Brand.fromJson(e))
          .toList(),
    );
  }
}

class Brand {
  final int id;
  final String name;
  final String slug;
  final String? logo;
  final int count;
  final List<CarForCate> cars;

  Brand({
    required this.id,
    required this.name,
    required this.logo,
    required this.slug,
    required this.count,
    required this.cars,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      logo: json['logo'],
      count: json['count'],
      cars: (json['cars'] as List)
          .map((e) => CarForCate.fromJson(e))
          .toList(),
    );
  }
}

class CarForCate {
  final int id;
  final String title;
  final String model;
  final String image;
  final String price;
  // final String salePrice;
  final String? transmissionType;
  final String fuelType;
  final int passenger;
  final String status;

  CarForCate({
    required this.id,
    required this.title,
    required this.model,
    required this.image,
    required this.price,
    // required this.salePrice,
    required this.transmissionType,
    required this.fuelType,
    required this.passenger,
    required this.status,
  });

  factory CarForCate.fromJson(Map<String, dynamic> json) {
    return CarForCate(
      id: json['id'],
      title: json['title'],
      model: json['model'],
      image: json['image'],
      price: json['price'],
      // salePrice: json['sale_price'],
      transmissionType: json['transmission_type'],
      fuelType: json['fuel_type'],
      passenger: json['passenger'],
      status: json['status'],
    );
  }
}

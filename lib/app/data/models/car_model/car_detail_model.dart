import 'dart:math';

import 'package:intl/intl.dart';

import '../../../core/styles/style.dart';

class CarDetailModel {
  final int id;
  final String objectModel;
  final String title;
  final String bannerImage;
  final List<String> gallery;
  final String? video;
  final LocationModel location;
  final String address;
  final String mapLat;
  final String mapLng;
  final int mapZoom;
  final PriceModel price;
  final String? discountPercent;
  final ReviewListsModel reviewLists;
  final List<CouponModel> availableCoupons;
  final Map<String, TermModel> terms;
  final String content;
  final InsuranceInfoModel insuranceInfo;
  final List<AdditionalFeeModel> additionalFees;
  final String fuelCapacity;
  final String fuelType;
  final String transmissionType;
  final int passenger;
  final RentalInfoModel? rentalInfo;
  bool isFavorite;
  bool carAuth;
  int bookComplete;
  String deliveryFees;

  CarDetailModel({
    required this.id,
    required this.objectModel,
    required this.title,
    required this.bannerImage,
    required this.gallery,
    this.video,
    required this.location,
    required this.address,
    required this.mapLat,
    required this.mapLng,
    required this.mapZoom,
    required this.price,
    this.discountPercent,
    required this.reviewLists,
    required this.availableCoupons,
    required this.terms,
    required this.content,
    required this.insuranceInfo,
    required this.additionalFees,
    required this.fuelCapacity,
    required this.fuelType,
    required this.transmissionType,
    required this.passenger,
    required this.isFavorite,
    required this.rentalInfo,
    required this.carAuth,
    required this.bookComplete,
    required this.deliveryFees,
  });

  factory CarDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint("Đang parse CarDetail từ JSON");

      // Xử lý gallery để tránh null
      List<String> galleryList = [];
      if (json['gallery'] != null) {
        galleryList = List<String>.from(
            (json['gallery'] as List).map((e) => e?.toString() ?? ''));
      }

      // Xử lý terms để tránh null
      Map<String, TermModel> termsMap = {};
      if (json['terms'] != null && json['terms'] is Map) {
        termsMap = (json['terms'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, TermModel.fromJson(value ?? {})),
        );
      }

      // Xử lý available_coupons để tránh null
      List<CouponModel> coupons = [];
      if (json['available_coupons'] != null) {
        coupons = (json['available_coupons'] as List)
            .map((e) => CouponModel.fromJson(e ?? {}))
            .toList();
      }

      // Xử lý additional_fees để tránh null
      List<AdditionalFeeModel> fees = [];
      if (json['additional_fees'] != null) {
        fees = (json['additional_fees'] as List)
            .map((e) => AdditionalFeeModel.fromJson(e ?? {}))
            .toList();
      }

      // Xử lý map_zoom có thể là String
      int mapZoom = 12;
      if (json['map_zoom'] != null) {
        if (json['map_zoom'] is int) {
          mapZoom = json['map_zoom'];
        } else if (json['map_zoom'] is String) {
          // Thử chuyển đổi String thành int, nếu không được thì dùng giá trị mặc định
          mapZoom = int.tryParse(json['map_zoom']) ?? 12;
        }
      }

      int passenger = 5;
      if (json['passenger'] != null) {
        if (json['passenger'] is int) {
          passenger = json['passenger'];
        } else if (json['passenger'] is String) {
          passenger = int.tryParse(json['passenger']) ?? 5;
        }
      }

      return CarDetailModel(
          id: json['id'] ?? 0,
          objectModel: json['object_model']?.toString() ?? '',
          title: json['title']?.toString() ?? '',
          bannerImage: json['banner_image']?.toString() ?? '',
          gallery: galleryList,
          video: json['video']?.toString(),
          location: LocationModel.fromJson(json['location'] ?? {}),
          address: json['address']?.toString() ?? '',
          mapLat: json['map_lat']?.toString() ?? '0',
          mapLng: json['map_lng']?.toString() ?? '0',
          mapZoom: mapZoom,
          price: PriceModel.fromJson(json['price'] ?? {}),
          discountPercent: json['discount_percent']?.toString(),
          reviewLists: ReviewListsModel.fromJson(
              json['review_lists'] ?? {'total': 0, 'data': []}),
          availableCoupons: coupons,
          terms: termsMap,
          content: json['content']?.toString() ?? '',
          insuranceInfo:
              InsuranceInfoModel.fromJson(json['insurance_info'] ?? {}),
          additionalFees: fees,
          fuelCapacity: json['fuel_capacity']?.toString() ?? '0',
          fuelType: json['fuel_type']?.toString() ?? 'xăng',
          transmissionType:
              json['transmission_type']?.toString() ?? 'Số tự động',
          passenger: passenger,
          isFavorite: json['wishlist_status'] ?? false,
          carAuth: json['car_auth'] ?? false,
          bookComplete: json['book_complete'] ?? 0,
          deliveryFees: json['delivery_fees']??"0",
          rentalInfo: json['rental_info'] != null && json['rental_info'] is Map
              ? RentalInfoModel.fromJson(
                  json['rental_info'],
                )
              : null);
    } catch (e) {
      debugPrint("Lỗi khi parse CarDetail: $e");
      debugPrint(
          "JSON gây lỗi: ${json.toString().substring(0, min(json.toString().length, 500))}");
      rethrow;
    }
  }
}

class PriceModel {
  final PriceOptionModel price24h;
  final PriceOptionModel price10h;

  PriceModel({required this.price24h, required this.price10h});

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      price24h: PriceOptionModel.fromJson(json['24h'] ?? {}),
      price10h: PriceOptionModel.fromJson(json['10h'] ?? {}),
    );
  }
}

class PriceOptionModel {
  final double price;
  final double salePrice;

  PriceOptionModel({required this.price, required this.salePrice});

  factory PriceOptionModel.fromJson(Map<String, dynamic> json) {
    double price = 0.0;
    double salePrice = 0.0;

    if (json['price'] != null) {
      if (json['price'] is num) {
        price = (json['price'] as num).toDouble();
      } else if (json['price'] is String) {
        price = double.tryParse(json['price']) ?? 0.0;
      }
    }

    if (json['sale_price'] != null) {
      if (json['sale_price'] is num) {
        salePrice = (json['sale_price'] as num).toDouble();
      } else if (json['sale_price'] is String) {
        salePrice = double.tryParse(json['sale_price']) ?? 0.0;
      }
    }

    return PriceOptionModel(
      price: price,
      salePrice: salePrice,
    );
  }
}

class ReviewListsModel {
  final int total;
  final List<ReviewModel> data;

  ReviewListsModel({required this.total, required this.data});

  factory ReviewListsModel.fromJson(Map<String, dynamic> json) {
    List<ReviewModel> reviews = [];
    if (json['data'] != null) {
      reviews = (json['data'] as List)
          .map((e) => ReviewModel.fromJson(e ?? {}))
          .toList();
    }

    return ReviewListsModel(
      total: json['total'] ?? 0,
      data: reviews,
    );
  }
}

class ReviewModel {
  final int id;
  final int objectId;
  final String objectModel;
  final String title;
  final String content;
  final int rateNumber;
  final String authorIp;
  final String status;
  final String publishDate;
  final int createUser;
  final int? updateUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int vendorId;
  final int authorId;
  final AuthorModel author;

  ReviewModel({
    required this.id,
    required this.objectId,
    required this.objectModel,
    required this.title,
    required this.content,
    required this.rateNumber,
    required this.authorIp,
    required this.status,
    required this.publishDate,
    required this.createUser,
    this.updateUser,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorId,
    required this.authorId,
    required this.author,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      objectId: json['object_id'] ?? 0,
      objectModel: json['object_model']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      rateNumber: json['rate_number'] ?? 0,
      authorIp: json['author_ip']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      publishDate: json['publish_date']?.toString() ?? '',
      createUser: json['create_user'] ?? 0,
      updateUser: json['update_user'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      vendorId: json['vendor_id'] ?? 0,
      authorId: json['author_id'] ?? 0,
      author: AuthorModel.fromJson(json['author'] ?? {}),
    );
  }
}

class AuthorModel {
  final int? id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? avatarId;
  final String? rank;
  final String? status;

  AuthorModel({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.avatarId,
    this.rank,
    this.status,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      name: json['name']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      avatarId: json['avatar_id']?.toString(),
      rank: json['rank']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
enum DiscountType {fixed,percent}

class CouponModel {
  final int id;
  final String code;
  final String name;
  final double amount;
  final DiscountType? discountType;
  final String endDate;
  final double minTotal;
  final double? maxTotal;
  final String? services;
  final String? onlyForUser;
  final String status;
  final int quantityLimit;
  final int limitPerUser;
  final String? imageId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.name,
    required this.amount,
    required this.discountType,
    required this.endDate,
    required this.minTotal,
    this.maxTotal,
    this.services,
    this.onlyForUser,
    required this.status,
    required this.quantityLimit,
    required this.limitPerUser,
    this.imageId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    double amount = 0.0;
    double minTotal = 0.0;
    double? maxTotal;

    if (json['amount'] != null) {
      if (json['amount'] is num) {
        amount = (json['amount'] as num).toDouble();
      } else if (json['amount'] is String) {
        amount =
            double.tryParse(json['amount'].toString().replaceAll(',', '')) ??
                0.0;
      }
    }

    if (json['min_total'] != null) {
      if (json['min_total'] is num) {
        minTotal = (json['min_total'] as num).toDouble();
      } else if (json['min_total'] is String) {
        minTotal =
            double.tryParse(json['min_total'].toString().replaceAll(',', '')) ??
                0.0;
      }
    }

    if (json['max_total'] != null) {
      if (json['max_total'] is num) {
        maxTotal = (json['max_total'] as num).toDouble();
      } else if (json['max_total'] is String) {
        maxTotal =
            double.tryParse(json['max_total'].toString().replaceAll(',', ''));
      }
    }

    return CouponModel(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      amount: amount,
      discountType: DiscountTypeExtension.fromString(json['discount_type']),
      endDate: json['end_date']?.toString() ?? '',
      minTotal: minTotal,
      maxTotal: maxTotal,
      services: json['services']?.toString(),
      onlyForUser: json['only_for_user']?.toString(),
      status: json['status']?.toString() ?? '',
      quantityLimit: json['quantity_limit'] is int
          ? json['quantity_limit']
          : (int.tryParse(json['quantity_limit']?.toString() ?? '0') ?? 0),
      limitPerUser: json['limit_per_user'] is int
          ? json['limit_per_user']
          : (int.tryParse(json['limit_per_user']?.toString() ?? '0') ?? 0),
      imageId: json['image_id']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

class TermModel {
  final TermParentModel parent;
  final List<TermChildModel> child;

  TermModel({required this.parent, required this.child});

  factory TermModel.fromJson(Map<String, dynamic> json) {
    List<TermChildModel> children = [];
    if (json['child'] != null) {
      children = (json['child'] as List)
          .map((e) => TermChildModel.fromJson(e ?? {}))
          .toList();
    }

    return TermModel(
      parent: TermParentModel.fromJson(json['parent'] ?? {}),
      child: children,
    );
  }
}

class TermParentModel {
  final int id;
  final String title;
  final String slug;
  final String service;
  final String? displayType;
  final int? hideInSingle;

  TermParentModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.service,
    this.displayType,
    this.hideInSingle,
  });

  factory TermParentModel.fromJson(Map<String, dynamic> json) {
    return TermParentModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      service: json['service']?.toString() ?? '',
      displayType: json['display_type']?.toString(),
      hideInSingle: json['hide_in_single'],
    );
  }
}

class TermChildModel {
  final int id;
  final String title;
  final String? content;
  final String imageId;
  final String? icon;
  final int attrId;
  final String slug;

  TermChildModel({
    required this.id,
    required this.title,
    this.content,
    required this.imageId,
    this.icon,
    required this.attrId,
    required this.slug,
  });

  factory TermChildModel.fromJson(Map<String, dynamic> json) {
    return TermChildModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString(),
      imageId: json['image_id']?.toString() ?? '',
      icon: json['icon']?.toString(),
      attrId: json['attr_id'] ?? 0,
      slug: json['slug']?.toString() ?? '',
    );
  }
}

class InsuranceInfoModel {
  final Map<String, InsuranceOptionModel> options;
  final List<InsuranceFeatureModel> features;
  final PassengerInsuranceModel passengerInsurance;

  InsuranceInfoModel({
    required this.options,
    required this.features,
    required this.passengerInsurance,
  });

  factory InsuranceInfoModel.fromJson(Map<String, dynamic> json) {
    // Xử lý options để tránh null
    Map<String, InsuranceOptionModel> optionsMap = {};
    if (json['options'] != null && json['options'] is Map) {
      optionsMap = (json['options'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, InsuranceOptionModel.fromJson(value ?? {})),
      );
    }

    // Xử lý features để tránh null
    List<InsuranceFeatureModel> featuresList = [];
    if (json['features'] != null) {
      featuresList = (json['features'] as List)
          .map((e) => InsuranceFeatureModel.fromJson(e ?? {}))
          .toList();
    }

    return InsuranceInfoModel(
      options: optionsMap,
      features: featuresList,
      passengerInsurance:
          PassengerInsuranceModel.fromJson(json['passenger_insurance'] ?? {}),
    );
  }
}

class InsuranceOptionModel {
  final String name;
  final double? price;
  final String? priceUnit;
  final bool? includesAll;
  final String? coverageNote;
  final double? coverageAmount;
  final String? description;

  InsuranceOptionModel({
    required this.name,
    this.price,
    this.priceUnit,
    this.includesAll,
    this.coverageNote,
    this.coverageAmount,
    this.description,
  });

  factory InsuranceOptionModel.fromJson(Map<String, dynamic> json) {
    double? price;
    double? coverageAmount;

    if (json['price'] != null) {
      if (json['price'] is num) {
        price = (json['price'] as num).toDouble();
      } else if (json['price'] is String) {
        price = double.tryParse(json['price'].toString().replaceAll(',', ''));
      }
    }

    if (json['coverage_amount'] != null) {
      if (json['coverage_amount'] is num) {
        coverageAmount = (json['coverage_amount'] as num).toDouble();
      } else if (json['coverage_amount'] is String) {
        coverageAmount = double.tryParse(
            json['coverage_amount'].toString().replaceAll(',', ''));
      }
    }

    return InsuranceOptionModel(
      name: json['name']?.toString() ?? '',
      price: price,
      priceUnit: json['price_unit']?.toString(),
      includesAll: json['includes_all'] is bool ? json['includes_all'] : null,
      coverageNote: json['coverage_note']?.toString(),
      coverageAmount: coverageAmount,
      description: json['description']?.toString(),
    );
  }
}

class InsuranceFeatureModel {
  final String id;
  final String name;

  InsuranceFeatureModel({required this.id, required this.name});

  factory InsuranceFeatureModel.fromJson(Map<String, dynamic> json) {
    return InsuranceFeatureModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class PassengerInsuranceModel {
  final String name;
  final double price;
  final String priceUnit;
  final String description;
  final String? coverageNote;

  PassengerInsuranceModel({
    required this.name,
    required this.price,
    required this.priceUnit,
    required this.description,
    this.coverageNote,
  });

  factory PassengerInsuranceModel.fromJson(Map<String, dynamic> json) {
    double price = 0.0;

    if (json['price'] != null) {
      if (json['price'] is num) {
        price = (json['price'] as num).toDouble();
      } else if (json['price'] is String) {
        price = double.tryParse(json['price'].toString().replaceAll(',', '')) ??
            0.0;
      }
    }

    return PassengerInsuranceModel(
      name: json['name']?.toString() ?? '',
      price: price,
      priceUnit: json['price_unit']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      coverageNote: json['coverage_note']?.toString(),
    );
  }
}

class AdditionalFeeModel {
  final int id;
  final String? iconUrl;
  final String? iconId;
  final String name;
  final double amount;
  final String? unit;
  final String description;

  AdditionalFeeModel({
    required this.id,
    this.iconUrl,
    this.iconId,
    required this.name,
    required this.amount,
    this.unit,
    required this.description,
  });

  factory AdditionalFeeModel.fromJson(Map<String, dynamic> json) {
    double amount = 0.0;

    if (json['amount'] != null) {
      if (json['amount'] is num) {
        amount = (json['amount'] as num).toDouble();
      } else if (json['amount'] is String) {
        amount =
            double.tryParse(json['amount'].toString().replaceAll(',', '')) ??
                0.0;
      }
    }

    return AdditionalFeeModel(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      iconUrl: json['icon_url']?.toString(),
      iconId: json['icon_id']?.toString(),
      name: json['name']?.toString() ?? '',
      amount: amount,
      unit: json['unit']?.toString(),
      description: json['description']?.toString() ?? '',
    );
  }
}

class LocationModel {
  final int id;
  final String name;

  LocationModel({
    required this.id,
    required this.name,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}

class RentalInfoModel {
  final String id;
  final RentalTimeModel? rentalTime;
  final String pickupLocation;
  final String deliveryLocation;
  final String bookingStatus;
  final String returnSameLocation;

  RentalInfoModel(
      {required this.id,
      required this.rentalTime,
      required this.pickupLocation,
      required this.deliveryLocation,
      required this.bookingStatus,
      required this.returnSameLocation});

  factory RentalInfoModel.fromJson(Map<String, dynamic> json) {
    return RentalInfoModel(
      id: json['booking_id']?.toString() ?? '',
      rentalTime: json['rental_time'] != null && json['rental_time'] is Map
          ? RentalTimeModel.fromJson(json['rental_time'])
          : null,
      pickupLocation: json['pickup_location']?.toString() ?? '',
      deliveryLocation: json['delivery_location']?.toString() ?? '',
      bookingStatus: json['booking_status']?.toString() ?? '',
      returnSameLocation: json['return_same_location']?.toString() ?? '',
    );
  }
}

class RentalTimeModel {
  final DateTime startDate;
  final DateTime endDate;

  RentalTimeModel({required this.startDate, required this.endDate});

  factory RentalTimeModel.fromJson(Map<String, dynamic> json) {
    return RentalTimeModel(
      startDate: DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['start_date']),
      endDate: DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['end_date']),
    );
  }
}

class CarDetailResponse {
  final CarDetailModel data;
  final int status;

  CarDetailResponse({required this.data, required this.status});

  factory CarDetailResponse.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint("Đang parse CarDetailResponse từ JSON");
      return CarDetailResponse(
        data: CarDetailModel.fromJson(json['data'] ?? {}),
        status: json['status'] ?? 0,
      );
    } catch (e) {
      debugPrint("Lỗi khi parse CarDetailResponse: $e");
      rethrow;
    }
  }

  @override
  String toString() {
    return 'CarDetailResponse(status: $status, data: ${data.title})';
  }
}

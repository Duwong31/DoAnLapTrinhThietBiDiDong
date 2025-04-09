import 'package:easy_localization/easy_localization.dart';


import '../../../core/styles/style.dart';
import '../car_model/car_detail_model.dart' show DiscountType;

class VoucherResponse {
  final List<Voucher> availableCoupons;
  final List<Voucher> usedCoupons;

  VoucherResponse({required this.availableCoupons, required this.usedCoupons});

  factory VoucherResponse.fromJson(Map<String, dynamic> json) {
    return VoucherResponse(
      availableCoupons: (json['data']['available_coupons'] as List)
          .map((e) => Voucher.fromJson(e))
          .toList(),
      usedCoupons: (json['data']['used_coupons'] as List)
          .map((e) => Voucher.fromJson(e))
          .toList(),
    );
  }
}

class Voucher {
  final int id;
  final String code;
  final String name;
  final dynamic amount;
  final DiscountType? discountType;
  final DateTime? endDate;
  final dynamic minTotal;
  final dynamic maxTotal;
  final int timesUsed;
  final int limitPerUser;
  final int quantityLimit;
  final String? onlyForUser;
  final int? createUser;

  Voucher({
    required this.id,
    required this.code,
    required this.name,
    required this.amount,
    required this.discountType,
    required this.endDate,
    required this.minTotal,
    this.maxTotal,
    required this.timesUsed,
    required this.limitPerUser,
    required this.quantityLimit,
    this.onlyForUser,
    this.createUser,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      amount: json['amount'],
      discountType: DiscountTypeExtension.fromString(json['discount_type']),
      endDate: DateFormat("yyyy-MM-dd HH:mm:ss").tryParse(json['end_date']),
      minTotal: json['min_total'],
      maxTotal: json['max_total'],
      timesUsed: json['times_used'],
      limitPerUser: json['limit_per_user'],
      quantityLimit: json['quantity_limit'],
      onlyForUser: json['only_for_user'],
      createUser: json['create_user'],
    );
  }
}

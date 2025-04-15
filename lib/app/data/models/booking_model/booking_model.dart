import '../car_model/car_model.dart';

class BookingModel {
  final int id;
  String status;
  final String total;
  final int totalGuests;
  final String startDate;
  final String endDate;
  final CarModel? service;

  BookingModel({
    required this.id,
    required this.status,
    required this.total,
    required this.totalGuests,
    required this.startDate,
    required this.endDate,
    required this.service,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      status: json['status'] ?? '',
      total: json['total'] ?? '',
      totalGuests: json['total_guests'] ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      service: json['service'] != null ? CarModel.fromJson(json['service']) : null,
    );
  }
}


class BookingHistoryResponse {
  final BookingHistoryModel? history;

  BookingHistoryResponse({required this.history});

  factory BookingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return BookingHistoryResponse(
      history:
      json['data'] != null ? BookingHistoryModel.fromJson(json['data']) : null,
    );
  }
}

class BookingHistoryModel {
  final List<BookingModel> complete;
  final List<BookingModel> upcoming;

  BookingHistoryModel({
    required this.complete,
    required this.upcoming,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    return BookingHistoryModel(
      complete:
      (json['complete'] as List).map((e) => BookingModel.fromJson(e)).toList(),
      upcoming:
      (json['upcoming'] as List).map((e) => BookingModel.fromJson(e)).toList(),
    );
  }
}

class BookingResponse {
  final String message;
  final int status;
  final String? bookingCode;

  BookingResponse(
      {required this.message, required this.status, required this.bookingCode});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
        message: json['message'] ?? '',
        status: json['status'] ?? 0,
        bookingCode: json['booking_code']);
  }
}
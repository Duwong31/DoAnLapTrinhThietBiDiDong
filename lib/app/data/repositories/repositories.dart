library repositories;

import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_image/extended_image.dart' as _apiClient;
import 'package:get/get.dart';

import '../models/favorite_model.dart';
import '../http_client/http_client.dart';
import '../models/dashboard_model.dart';
import '../models/models.dart';
import '../models/playlist.dart';
import '../providers/providers.dart';
import 'history_repository.dart';
import 'song_repository.dart';

part 'auth_repository.dart';
part 'user_repository.dart';
part 'notification_repository.dart';

abstract class BaseRepository {
  Future<T> handleCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      rethrow;
    }
  }
}

class Repo {
  factory Repo() => _instance;
  Repo._internal();
  static final Repo _instance = Repo._internal();

  static final _auth = AuthRepository();
  static final _user = UserRepository(ApiClient());
  static final _notify = NotificationRepository();
  // static final _car = CarRepository();
  // static final _lifeStyle = LifeStyleRepository();
  // static final _voucher = VoucherRepository();
  // static final _address = AddressRepository();
  // static final _booking = BookingRepository();
  // static final _feedback = FeedbackRepository();
   static final _song = DefaultRepository();
   static final _history = HistoryRepository();

  // Getters
  static AuthRepository get auth => _auth;
  static UserRepository get user => _user;
  static NotificationRepository get notify => _notify;
  // static CarRepository get car => _car;
  // static LifeStyleRepository get lifeStyle => _lifeStyle;
  // static VoucherRepository get voucher => _voucher;
  // static AddressRepository get address => _address;
  // static BookingRepository get booking => _booking;
  // static FeedbackRepository get feedback => _feedback;
  static DefaultRepository get song => _song;
  static HistoryRepository get history => _history;
}

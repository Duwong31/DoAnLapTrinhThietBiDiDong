library repositories;

import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import '../models/dashboard_model.dart';
import '../models/models.dart';
import '../models/playlist.dart';
import '../providers/providers.dart';

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
  static final _user = UserRepository();
  static final _notify = NotificationRepository();
  // static final _car = CarRepository();
  // static final _lifeStyle = LifeStyleRepository();
  // static final _voucher = VoucherRepository();
  // static final _address = AddressRepository();
  // static final _booking = BookingRepository();
  // static final _feedback = FeedbackRepository();

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
}

part of '../models.dart';

class UserModel {
  UserModel({
    this.id,
    this.nickname,
    this.fullName = '',
    this.email,
    this.phone,
    this.phoneVerified = false,
    this.birthYear,
    this.gender,
    this.referralCode,
    this.walletBalance,
    this.points,
    this.rank,
    this.soBhxh,
    this.facebookLinked = false,
    this.tiktokLinked = false,
    this.currentAddress = '',
    this.company,
    this.activeStatus = false,
    this.darkMode = false,
    this.messengerColor,
    this.avatarUrl,
    this.avatarThumbUrl,
    this.firstName,
    this.lastName,
    this.birthday,
    this.userName,
    this.address,
    this.businessName,
    this.avatarId,
    this.createdAt,
    this.updatedAt,
    this.isEnableNotification = false,
    this.isVerified = false,
  });

  String? id;
  String? nickname;
  String fullName;
  String? email;
  String? phone;
  bool phoneVerified;
  int? birthYear;
  String? gender;
  String? referralCode;
  int? walletBalance;
  int? points;
  String? rank;
  String? soBhxh;
  bool facebookLinked;
  bool tiktokLinked;
  String currentAddress;
  String? company;
  bool activeStatus;
  bool darkMode;
  String? messengerColor;
  String? avatarUrl;
  String? firstName;
  String? lastName;
  String? birthday;
  String? userName;
  String? address;
  String? businessName;
  int? avatarId;
  String? avatarThumbUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isEnableNotification;
  bool isVerified;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"].toString(),
        nickname: json["nickname"],
        fullName: json["full_name"] ?? '',
        email: json["email"],
        phone: json["phone"],
        phoneVerified: json["phone_verified"] ?? false,
        birthYear: json["birth_year"],
        gender: json["gender"],
        referralCode: json["referral_code"],
        walletBalance: json["wallet_balance"],
        points: json["points"],
        rank: json["rank"],
        soBhxh: json["so_bhxh"],
        facebookLinked: json["facebook_linked"] ?? false,
        isVerified: json["is_verified"] == 1,
        tiktokLinked: json["tiktok_linked"] ?? false,
        currentAddress: json["current_address"] ?? '',
        company: json["company"],
        isEnableNotification: json["is_enable_notification"] ?? false,
        activeStatus: json["active_status"] ?? false,
        darkMode: json["dark_mode"] ?? false,
        messengerColor: json["messenger_color"],
        avatarUrl: json["avatar_url"],
        avatarThumbUrl: json["avatar_thumb_url"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        birthday: json["birthday"],
        userName: json["user_name"],
        address: json["address"],
        businessName: json["business_name"],
        avatarId: json["avatar_id"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "nickname": nickname,
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "phone_verified": phoneVerified,
        "birth_year": birthYear,
        "gender": gender,
        "referral_code": referralCode,
        "wallet_balance": walletBalance,
        "points": points,
        "rank": rank,
        "so_bhxh": soBhxh,
        "facebook_linked": facebookLinked,
        "tiktok_linked": tiktokLinked,
        "current_address": currentAddress,
        "company": company,
        "active_status": activeStatus,
        "dark_mode": darkMode,
        "messenger_color": messengerColor,
        "avatar_url": avatarUrl,
        "fullName": fullName,
        "birthYear": birthYear,
        "soBhxh": soBhxh,
        "currentAddress": currentAddress,
        "activeStatus": activeStatus,
        "darkMode": darkMode,
        "messengerColor": messengerColor,
        "avatar_thumb_url": avatarThumbUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class AuthResponse {
  AuthResponse({
    required this.accessToken,
    required this.user,
    required this.status,
  });

  String accessToken;
  UserModel user;
  int status;

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        accessToken: json["access_token"],
        user: UserModel.fromMap(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "access_token": accessToken,
        "data": user.toMap(),
        "status": status,
      };
}

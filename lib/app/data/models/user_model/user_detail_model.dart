import 'dart:math';

class UserDetailModel {
  String? avatarUrl;
  String nickname;
  String fullName;
  String birthYear;
  String gender;
  String socialID;
  String? facebook; // Optional field for Facebook link
  String? tiktok;   // Optional field for TikTok link
  String? address;  // Optional field for temporary residence
  String? workLocation; // Optional field for workplace

  UserDetailModel({
    this.avatarUrl,
    required this.nickname,
    required this.fullName,
    required this.birthYear,
    required this.gender,
    required this.socialID,
    this.facebook,
    this.tiktok,
    this.address,
    this.workLocation,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      avatarUrl: json['avatarUrl'],
      nickname: json['nickname'] ?? '',
      fullName: json['fullName'] ?? '',
      birthYear: json['birthYear'] ?? '',
      gender: json['gender'] ?? '',
      socialID: json['socialID'] ?? '',
      facebook: json['facebook'],
      tiktok: json['tiktok'],
      address: json['address'],
      workLocation: json['workLocation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatarUrl': avatarUrl,
      'nickname': nickname,
      'fullName': fullName,
      'birthYear': birthYear,
      'gender': gender,
      'socialID': socialID,
      'facebook': facebook,
      'tiktok': tiktok,
      'address': address,
      'workLocation': workLocation,
    };
  }

  // Function to generate a random social ID with the first two numbers as '35' and the rest as 'X'
  static String generateRandomSocialID() {
    var random = Random();
    String randomNumbers = List.generate(12, (index) => random.nextInt(10)).join('');
    return '35$randomNumbers'.substring(0, 14).padRight(14, 'X');
  }

  // Function to format the social ID (showing only the first 2 digits and masking the rest)
  String get formattedSocialID {
    return socialID.substring(0, 2) + 'X' * (socialID.length - 2);
  }
}

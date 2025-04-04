part of 'models.dart';

class MessageOld {
  MessageOld({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.message,
    // required this.timestamp,
    this.photoUrl,
    this.height = 0,
    this.width = 0,
    this.isMe = false,
    this.isRead = false,
  });
  MessageOld.fileMessage({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    // required this.timestamp,
    this.photoUrl,
    required this.height,
    required this.width,
    required this.isMe,
    required this.isRead,
  });
  MessageOld.fromMap(Map<String, dynamic> map) {
    senderId = map['senderId'];
    receiverId = map['receiverId'];
    type = map['type'];
    message = map['message'] != null
        ? EncryptData.decryptFile(map['message'])
        : map['message'];
    // timestamp = Timestamp.fromMillisecondsSinceEpoch(map['timestamp']);
    photoUrl = map['photoUrl'] != null
        ? EncryptData.decryptFile(map['photoUrl'])
        : map['photoUrl'];
    height = map['height'] ?? 0;
    width = map['width'] ?? 0;
    isRead = map['isRead'] ?? false;
  }
  Map toMap() {
    final map = <String, dynamic>{};
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['type'] = type;
    map['message'] =
        message.isNotEmpty ? EncryptData.crypteFile(message) : message;
    // map['timestamp'] = timestamp.millisecondsSinceEpoch;
    map['width'] = width;
    map['height'] = height;
    map['photoUrl'] =
        photoUrl != null ? EncryptData.crypteFile(photoUrl!) : photoUrl;
    map['isRead'] = isRead;
    return map;
  }

  String? id;
  late String senderId;
  late String receiverId;
  late String type;
  late String message;
  // late Timestamp timestamp;
  String? photoUrl;
  String? thumbnail;
  late int height;
  late int width;
  late bool isMe;
  // late int messageType;
  late bool isRead;
  bool get isFile => type == DbKeys.image || type == DbKeys.video;
}

enum UserState {
  offline,
  online,
  waiting,
}

class UserChatModel {
  final String uid;
  final String? displayName,
      profilePic,
      firstName,
      lastName,
      fcmToken,
      phone,
      email;
  final int? npi;
  final int state;
  final StoreModelOld? storeModel;
  UserChatModel({
    required this.uid,
    this.displayName,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.npi,
    this.state = 0,
    this.fcmToken,
    this.storeModel,
    this.phone,
    this.email,
  });
  String get fullName => "$firstName $lastName";
  factory UserChatModel.fromJson(Map<String, dynamic> json) {
    return UserChatModel(
      displayName: json['displayName'],
      profilePic: json['profilePic'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      npi: json['npi'],
      uid: json['uid'],
      state: json['state'] ?? 0,
      fcmToken: json['fcmToken'],
      storeModel:
          json['store'] != null ? StoreModelOld.fromJson(json['store']) : null,
      email: json['email'],
      phone: json['phone'],
    );
  }
  toJson() {
    return {
      "displayName": displayName,
      "profilePic": profilePic,
      "firstName": firstName,
      "lastName": lastName,
      "npi": npi,
      "uid": uid,
      "state": state,
      "fcmToken": fcmToken,
      "phone": phone,
      "email": email,
    };
  }
}

class StoreModelOld {
  final String? placeId;
  final String? name;
  final AddressModel? addressModel;

  StoreModelOld({this.placeId, this.name, this.addressModel});

  factory StoreModelOld.fromJson(Map<String, dynamic> json) => StoreModelOld(
        placeId: json['placeId'],
        name: json['name'],
        addressModel: AddressModel.fromJson(json['address']),
      );
}

class AddressModel {
  String? fullAddress;

  AddressModel({this.fullAddress});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      fullAddress: json['fullAddress'],
    );
  }
}

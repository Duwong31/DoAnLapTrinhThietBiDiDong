part of 'models.dart';

class UserModel {
  UserModel({
    this.id,
    this.email,
    this.firstName = '',
    this.lastName = '',
    this.fullName = '',
    this.fullAddress = '',
    this.dateOfBirth,
    this.phone,
    this.avatar,
    this.insuranceCard,
    this.address = const [],
    this.defaultStore,
    this.gender,
    this.medicalRecordNumber,
    this.emergencyContact,
    this.isEnableNotification = false,
    this.isV1 = false,
    this.isDeleted = false,
    this.shopNPI,
    this.userStoreModel,
  });
  String? id;
  String? email;
  String firstName;
  String lastName;
  String? phone;
  String fullName;
  String? avatar;
  String? insuranceCard;
  List<Address> address;
  EmergencyContact? emergencyContact;
  bool isEnableNotification;
  bool isV1;
  bool isDeleted;

  final String fullAddress;
  final DateTime? dateOfBirth;
  final String? gender;
  final DefaultStore? defaultStore;
  final String? medicalRecordNumber;
  String? get currentAddress =>
      address.firstWhereOrNull((e) => e.isDefault)?.fullAddress;

  String get birthDay =>
      AppUtils.timeFormat(dateOfBirth?.millisecondsSinceEpoch,
          format: 'MM/dd/yyyy');
  //Shop Info
  final int? shopNPI;
  final UserStoreModel? userStoreModel;

  factory UserModel.fromMap(Map<dynamic, dynamic> json) => UserModel(
        id: json["id"]?.toString(),
        email: json["email"],
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
        dateOfBirth: json['date_of_birth'] != null
            ? DateTime.parse(json['date_of_birth'])
            : null,
        phone: json['phone_number'].toString(),
        insuranceCard: json["insurance_card"].toString(),
        avatar: json['avatar'],
        address: json['addresses'] == null
            ? []
            : (json['addresses'] as List)
                .map((e) => Address.fromMap(e))
                .toList(),
        defaultStore: json["default_store"] == null
            ? null
            : DefaultStore.fromMap(json["default_store"]),
        gender: json['gender'],
        medicalRecordNumber: json["medical_record_number"],
        emergencyContact: json["emergency_contact"] == null
            ? null
            : EmergencyContact.fromMap(json["emergency_contact"]),
        fullName: json['full_name'] ?? '',
        isEnableNotification: json["is_enable_notification"] ?? false,
        fullAddress: json["full_address"] ?? '',
        isV1: json['version_app'] == 'v1',
        isDeleted: json['is_deleted'] ?? false,
        shopNPI: json["npi"],
        userStoreModel: json["store"] == null
            ? null
            : UserStoreModel.fromMap(json["store"]),
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "date_of_birth": dateOfBirth?.toString(),
        "phone_number": phone,
        'gender': gender?.toLowerCase(),
        "medical_record_number": medicalRecordNumber,
        "emergency_contact_attributes": emergencyContact?.toMap(),
      };
}

class Address {
  Address({
    required this.id,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.isDefault,
    required this.apartment,
    this.loading = false,
  });

  final String id;
  final String fullAddress;
  final String apartment;
  final String city;
  final String state;
  final bool isDefault;
  bool loading;
  factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["id"] ?? '',
        fullAddress: json["full_address"] ?? '',
        city: json["city"] ?? '',
        state: json["state"] ?? '',
        isDefault: json["is_default"] ?? false,
        apartment: json["apartment"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "full_address": fullAddress,
        "city": city,
        "state": state,
        "is_default": isDefault,
        "apartment": apartment,
      };
}

class DefaultStore {
  DefaultStore({
    required this.id,
    required this.npi,
    required this.name,
    required this.companyName,
    required this.openTime,
    required this.closeTime,
  });

  final String id;
  final String npi;
  final String name;
  final String companyName;
  final String openTime;
  final String closeTime;

  factory DefaultStore.fromMap(Map<String, dynamic> json) => DefaultStore(
        id: json["id"] ?? '',
        npi: json["npi"] ?? '',
        name: json["name"] ?? '',
        companyName: json["company_name"] ?? '',
        openTime: json["open_time"] ?? '',
        closeTime: json["close_time"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "npi": npi,
        "name": name,
        "company_name": companyName,
        "open_time": openTime,
        "close_time": closeTime,
      };
}

class EmergencyContact {
  EmergencyContact({
    required this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.relationship,
  });
  final String id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? relationship;
  String get fullName => '$firstName $lastName';
  factory EmergencyContact.fromMap(Map<String, dynamic> json) =>
      EmergencyContact(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        relationship: json["relationship"],
        id: json['id'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "relationship": relationship,
      };
}

class UserStoreModel {
  UserStoreModel({
    this.storeNumber,
    this.phone,
    this.name,
    this.address,
    this.onfleetTeamId,
    this.fax,
  });
  final String? storeNumber;
  final String? phone;
  final String? name;
  final Address? address;
  final String? onfleetTeamId;
  final String? fax;

  factory UserStoreModel.fromMap(Map<String, dynamic> json) {
    var userStoreModel = UserStoreModel(
      storeNumber: json["storeNumber"],
      phone: json["phone"],
      name: json["name"],
      address: Address.fromMap(json["address"]),
      onfleetTeamId: json["onfleetTeamId"],
      fax: json['fax'] ?? '',
    );
    return userStoreModel;
  }
}

class InternalPharmacyModel {
  InternalPharmacyModel({
    this.npi,
    this.phone,
    this.name,
    this.fullAddress,
    this.lat,
    this.lon,
  });
  final String? npi;
  final String? phone;
  final String? name;
  final String? fullAddress;
  final double? lat;
  final double? lon;

  factory InternalPharmacyModel.fromMap(Map<String, dynamic> json) {
    var userStoreModel = InternalPharmacyModel(
      npi: json["npi"],
      phone: json["phone"],
      name: json["name"],
      fullAddress: json["full_address"],
      lat: json["lat"],
      lon: json['lon'],
    );
    return userStoreModel;
  }
}

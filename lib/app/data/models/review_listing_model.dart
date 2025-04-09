import 'package:easy_localization/easy_localization.dart';

class ReviewListingModel{
  int id;
  String? content;
  dynamic rateNumber;
  int? authorId;
  String? authorName;
  String? authorAvatar;
  DateTime? createdAt;
  List<String> images;
  dynamic ratingAverage;

//<editor-fold desc="Data Methods">
  ReviewListingModel({
    required this.id,
    this.content,
    required this.rateNumber,
    this.authorId,
    this.authorName,
    this.authorAvatar,
    this.createdAt,
    required this.images,
    required this.ratingAverage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewListingModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          rateNumber == other.rateNumber &&
          authorId == other.authorId &&
          authorName == other.authorName &&
          authorAvatar == other.authorAvatar &&
          createdAt == other.createdAt &&
          images == other.images &&
          ratingAverage == other.ratingAverage);

  @override
  int get hashCode =>
      id.hashCode ^
      content.hashCode ^
      rateNumber.hashCode ^
      authorId.hashCode ^
      authorName.hashCode ^
      authorAvatar.hashCode ^
      createdAt.hashCode ^
      images.hashCode ^
      ratingAverage.hashCode;


  ReviewListingModel copyWith({
    int? id,
    String? content,
    dynamic rateNumber,
    int? authorId,
    String? authorName,
    String? authorAvatar,
    DateTime? createdAt,
    List<String>? images,
    dynamic ratingAverage,
  }) {
    return ReviewListingModel(
      id: id ?? this.id,
      content: content ?? this.content,
      rateNumber: rateNumber ?? this.rateNumber,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
      ratingAverage: ratingAverage ?? this.ratingAverage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'rateNumber': rateNumber,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'createdAt': createdAt,
      'images': images,
      'ratingAverage': ratingAverage,
    };
  }

  factory ReviewListingModel.fromMap(Map<String, dynamic> map) {
    return ReviewListingModel(
      id: map['id'] as int,
      content: map['content'] as String,
      rateNumber: map['rateNumber'],
      authorId: map['author']['id'],
      authorName: map['author']['name'],
      authorAvatar: map['author']['avatar'] ,
      createdAt: map['created_at'] == null? null: DateFormat("MM/dd/yyyy HH:mm").parse(map['created_at']),
      images:map['images'] == null || map['images'].isEmpty?[]:List<String>.from( map['images']
          .map((json) =>json['url'].toString())
          .toList()),
      ratingAverage: map['rating_average'],
    );
  }

//</editor-fold>
}
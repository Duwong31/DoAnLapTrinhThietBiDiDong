library models;

import 'package:get/utils.dart';
import 'package:intl/intl.dart';

import '../../core/utilities/app_utils.dart';
import '../../core/utilities/db_keys.dart';
import '../../core/utilities/encry_data.dart';
part 'in_chat.dart';
part 'message.dart';
part 'message_model.dart';
part 'notification.dart';
part 'notification_old.dart';
part 'user.dart';

class AppStatus<T> {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final bool isEmpty;
  final bool isLoadingMore;
  final String? errorMessage;
  final T? data;
  AppStatus._({
    this.isEmpty = false,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isLoadingMore = false,
    this.data,
  });

  factory AppStatus.loading() {
    return AppStatus._(isLoading: true);
  }

  factory AppStatus.loadingMore([T? val]) {
    return AppStatus._(isSuccess: true, isLoadingMore: true, data: val);
  }

  factory AppStatus.success([T? val]) {
    return AppStatus._(isSuccess: true, data: val);
  }

  factory AppStatus.error([String? message]) {
    return AppStatus._(isError: true, errorMessage: message);
  }

  factory AppStatus.empty() {
    return AppStatus._(isEmpty: true);
  }
}

class ReposeData<T> {
  ReposeData({
    required this.data,
    required this.meta,
  });

  final List<T> data;
  final Meta meta;
}

class Meta {
  Meta({
    this.count = 0,
    this.items = 0,
    this.page = 0,
    this.outset = 0,
    this.last = 0,
    this.pages = 0,
    this.offset = 0,
    this.from = 0,
    this.to = 0,
    this.prev = 0,
    this.next = 0,
    this.limit = 0,
    this.totalUnreadMessage = 0,
  });

  final int count;
  final int items;
  final int page;
  final int outset;
  final int last;
  final int pages;
  final int offset;
  final int from;
  final int to;
  final int prev;
  final int next;
  final int limit;
  final int totalUnreadMessage;
  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        count: json["count"] ?? 0,
        items: json["items"] ?? 0,
        page: json["page"] ?? 0,
        outset: json["outset"] ?? 0,
        last: json["last"] ?? 0,
        pages: json["pages"] ?? 0,
        offset: json["offset"] ?? 0,
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        prev: json["prev"] ?? 0,
        next: json["next"] ?? 0,
        limit: json["limit"] ?? 0,
        totalUnreadMessage: json['total_unread_message'] ?? 0,
      );
}

typedef Json = Map<String, dynamic>;

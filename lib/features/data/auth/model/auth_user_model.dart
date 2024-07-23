import 'dart:developer';
// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';

class AuthUserData {
  AuthUserData({
    required this.message,
    required this.authToken,
    required this.user,
  });

  final String message;
  final String authToken;
  final Manager user;

  factory AuthUserData.fromJson(Map<String, dynamic> json) {
    log(Manager.fromJson(json["user"]).toString());
    return AuthUserData(
        message: json["message"],
        authToken: json["auth_token"],
        user: Manager.fromJson(json["user"]));
  }
}

class AppCurrentUserData {
  final int id;
  final String? name;
  final String fio;
  final String? bin;
  final dynamic squareArea;
  final String? phone;
  final dynamic address;
  final dynamic lat;
  final dynamic long;
  final dynamic avatar;
  final int? headsCount;
  final int? trackersCount;
  final dynamic region;
  final Manager? manager;
  final String? role;
  final Subscription? subscription;
  final String? newPassword;
  final String? oldPassword;

  AppCurrentUserData({
    required this.id,
    required this.name,
    required this.fio,
    required this.bin,
    this.squareArea,
    required this.phone,
    this.address,
    this.lat,
    this.long,
    this.avatar,
    required this.headsCount,
    required this.trackersCount,
    this.region,
    required this.manager,
    required this.role,
    required this.subscription,
    this.oldPassword,
    this.newPassword,
  });

  factory AppCurrentUserData.fromJson(Map<String, dynamic> json) {
    return AppCurrentUserData(
      id: json["id"],
      name: json["name"] ?? '',
      fio: json["fio"],
      bin: json["bin"] ?? '',
      squareArea: json["square_area"] ?? '',
      phone: json["phone"],
      address: json["address"] ?? '',
      lat: json["lat"] ?? '',
      long: json["long"] ?? '',
      avatar: json["avatar"],
      headsCount: json["heads_count"] ?? '',
      trackersCount: json["trackers_count"] ?? '',
      region: json["region"] ?? '',
      manager:
          json["manager"] != null ? Manager.fromJson(json["manager"]) : null,
      role: json["role"],
      oldPassword: json["password"] ?? '',
      newPassword: json["old_password"] ?? '',
      subscription: json["status"] != null
          ? Subscription.fromJson(json["subscription"])
          : null,
    );
  }
}

class Manager {
  final int? id;
  final String fio;
  final String? phone;
  final dynamic avatar;
  final String? role;

  Manager({
    required this.id,
    required this.fio,
    required this.phone,
    this.avatar,
    required this.role,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      return Manager(
          id: json["id"],
          fio: json["fio"] ?? '',
          phone: json["phone"] ?? '',
          avatar: json["avatar"] ?? '',
          role: json["role"] ?? '');
    } else {
      return Manager(
          fio: CoreConstant.empty,
          id: 1,
          phone: CoreConstant.empty,
          role: CoreConstant.empty);
    }
  }
}

class Subscription {
  final bool status;
  final DateTime expiration;

  Subscription({
    required this.status,
    required this.expiration,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
      status: json["status"], expiration: DateTime.parse(json["expiration"]));
}

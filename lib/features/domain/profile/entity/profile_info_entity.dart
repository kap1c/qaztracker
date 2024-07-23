// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable

import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/features/data/auth/model/auth_user_model.dart';

class AppCurrentUserEntity extends CoreState {
  AppCurrentUserEntity({
    this.id,
    this.fio,
    this.phone,
    this.avatar,
    this.role,
    this.name,
    this.bin,
    this.squareArea,
    this.address,
    this.headsCount,
    this.lat,
    this.long,
    this.manager,
    this.region,
    this.subscription,
    this.trackersCount,
    this.newPassword,
    this.oldPassword,
  });

  final int? id;
  String? fio;
  String? phone;
  final String? avatar;
  final String? role;
  String? name;
   String? bin;
   dynamic? squareArea;
  final dynamic? address;
  final dynamic? lat;
  final dynamic? long;
  final int? headsCount;
  final int? trackersCount;
  final dynamic? region;
  final Manager? manager;
  final Subscription? subscription;
   String? newPassword;
  final String? oldPassword;

  AppCurrentUserEntity copyWith(
          {int? id,
          String? fio,
          String? phone,
          String? avatar,
          String? role,
          String? name,
          String? bin,
          dynamic? squareArea,
          dynamic? address,
          dynamic? lat,
          dynamic? long,
          int? headsCount,
          int? trackersCount,
          dynamic? region,
          Manager? manager,
          Subscription? subscription,
          String? newPassword,
          String? oldPassword}) =>
      AppCurrentUserEntity(
        id: id ?? this.id,
        fio: fio ?? this.fio,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        role: role ?? this.role,
        name: name ?? this.name,
        bin: bin ?? this.bin,
        squareArea: squareArea ?? this.squareArea,
        address: address ?? this.address,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        newPassword: newPassword ?? this.newPassword,
        oldPassword: oldPassword ?? this.oldPassword,
        headsCount: headsCount ?? this.headsCount,
        trackersCount: trackersCount ?? this.trackersCount,
        region: region ?? this.region,
        manager: manager ?? this.manager,
        subscription: subscription ?? this.subscription,
      );

  factory AppCurrentUserEntity.fromDTO(AppCurrentUserData dto) =>
      AppCurrentUserEntity(
          id: dto.id,
          fio: dto.fio,
          phone: dto.phone,
          avatar: dto.avatar,
          role: dto.role,
          name: dto.name,
          bin: dto.bin,
          squareArea: dto.squareArea,
          address: dto.address,
          lat: dto.lat,
          long: dto.long,
          headsCount: dto.headsCount,
          trackersCount: dto.trackersCount,
          region: dto.region,
          manager: dto.manager,
          oldPassword: dto.oldPassword,
          newPassword: dto.newPassword,
          subscription: dto.subscription);

  Map<String, dynamic> toJson() { 
    String phoneToJson = removePlusSeven(phone!);
    
    return {

    
        "id": id,
        "fio": fio,
        "phone": '+7$phoneToJson',
        "avatar": avatar,
        "role": role,
        "square_area": squareArea,
        "name": name,
        "heads_count": headsCount,
        "region_id": region!=null? region['id'] : null,
        "bin": bin,
        "lat": lat,
        "long": long,
        "address": address,
        // "password": newPassword,
        // "old_password": oldPassword,
      };}

  @override
  List<Object?> get props => [
        id,
        fio,
        phone,
        avatar,
        role,
        name,
        bin,
        squareArea,
        address,
        lat,
        long,
        headsCount,
        trackersCount,
        region,
        manager,
        subscription
      ];
}


String removePlusSeven(String input) {
  RegExp regex = RegExp(r'\+7');
  return input.replaceAll(regex, '');
}

import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class SensorModel {
  int? id;
  String? trackerId;
  double? battery;
  double? network;
  bool? isTurnedOn;
  int? trackersCount; // this number is in design, but it makes zero sense
  // TODO: remove trackersCount from design
  String networkSignalDescription() {
    if (network! > 0 && network! <= 3) {
      return 'Низкий';
    } else if (network! > 3 && network! <= 6) {
      return 'Нормальный';
    } else if (network! > 6 && network! <= 10) {
      return 'Высокий';
    }
    return 'Unknown';
  }

  Color networkSignalColor() {
    if (network! > 0 && network! <= 3) {
      return AppColors.primaryRedColor;
    } else if (network! > 3 && network! <= 6) {
      return Color(0XFFffcd44);
    } else if (network! > 6 && network! <= 10) {
      return Color(0XFF55c153);
    }
    return Colors.grey;
  }

  SensorModel({
    this.id,
    this.trackerId,
    this.battery,
    this.network,
    this.isTurnedOn,
  });

  SensorModel.fromJson(Map<String, dynamic> json, int trackersCountInFarm) {
    id = json['id'];
    trackerId = json['tracker_id'];
    battery = json['battery'];
    network = json['network'];
    isTurnedOn = true;
    trackersCount = trackersCountInFarm;
  }
}

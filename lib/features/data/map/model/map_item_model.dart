import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MapInfoData {
  final List<MapElement> map;

  MapInfoData({required this.map});

  factory MapInfoData.fromJson(Map<String, dynamic> json) => MapInfoData(
      map: List<MapElement>.from(
          json["map"].map((x) => MapElement.fromJson(x))));
}

class MapElement {
  final int id;
  final String trackerId;
  final AnimalType? type;
  final Breed? breed;
  final int weight;
  final int age;
  final String farm;
  final int battery;
  final int network;
  final double lat;
  final double long;

  MapElement({
    required this.id,
    required this.trackerId,
    required this.type,
    required this.breed,
    required this.weight,
    required this.age,
    required this.farm,
    required this.battery,
    required this.network,
    required this.lat,
    required this.long,
  });

  factory MapElement.fromJson(Map<String, dynamic> json) => MapElement(
        id: json["id"],
        trackerId: json["tracker_id"],
        type: json["type"] != null ? AnimalType.fromJson(json["type"]) : null,
        breed: json["breed"] != null ? Breed.fromJson(json["breed"]) : null,
        weight: json["weight"],
        age: json["age"],
        farm: json["farm"],
        battery: json["battery"],
        network: json["network"],
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
      );
}

class Breed {
  int? id;
  String? name;
  int? animalTypeId;
  int? animalTypeIdFromTable;
  String? animalTypeName;
  bool? isSelected;
  Breed(
      {this.id,
      this.name,
      this.animalTypeId,
      this.animalTypeIdFromTable,
      this.animalTypeName,
      this.isSelected = false,
      });

  factory Breed.fromJson(Map<String, dynamic> json) => Breed(
      id: json["id"],
      name: json["name"],
      animalTypeId: json["animal_type_id"],
      animalTypeIdFromTable: json["type"] != null ? json["type"]["id"] : 0,
      animalTypeName: json["type"] != null ? json["type"]["name"] : "");
}

class AnimalType {
  final int id;
  final String name;

  AnimalType({required this.id, required this.name});

  factory AnimalType.fromJson(Map<String, dynamic> json) =>
      AnimalType(id: json["id"], name: json["name"]);
}

class MapDataClass extends Equatable {
  final int? id;
  final String? icon;
  final String? title;
  final String? code;
  final int? amount;
  final Color? bgColor;
  bool isSelected;
  MapDataClass(
      {this.id,
      this.title,
      this.code,
      this.amount,
      this.icon,
      this.bgColor,
      this.isSelected = false});

  @override
  List<Object?> get props => [isSelected];
}

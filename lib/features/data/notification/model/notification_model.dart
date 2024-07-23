import 'package:intl/intl.dart';

class NotificationsData {
  final List<NotificationItemData> data;
  final int page;
  final int total;
  final int pages;

  NotificationsData({
    required this.data,
    required this.page,
    required this.total,
    required this.pages,
  });

  factory NotificationsData.fromJson(Map<String, dynamic> json) =>
      NotificationsData(
        data: List<NotificationItemData>.from(
            json["data"].map((x) => NotificationItemData.fromJson(x))),
        page: json["page"],
        total: json["total"],
        pages: json["pages"],
      );
}

class NotificationItemData {
  final int id;
  final DatumType type;
  final String trackerId;
  final Animal animal;
  final String message;
  final String createdAt;

  NotificationItemData({
    required this.id,
    required this.type,
    required this.trackerId,
    required this.animal,
    required this.message,
    required this.createdAt,
  });

  factory NotificationItemData.fromJson(Map<String, dynamic> json) =>
      NotificationItemData(
        id: json["id"],
        type: DatumType.fromJson(json["type"]),
        trackerId: json["tracker_id"],
        animal: Animal.fromJson(json["animal"]),
        message: json["message"],
        createdAt: convertUnixTimestampToRussianDateTime(json["created_at"]),
      );
}

class Animal {
  final int id;
  final String name;
  final int weight;
  final String trackerId;
  final int age;
  final String gender;
  final AnimalType type;
  final Breed breed;

  Animal({
    required this.id,
    required this.name,
    required this.weight,
    required this.trackerId,
    required this.age,
    required this.gender,
    required this.type,
    required this.breed,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        id: json["id"],
        name: json["name"],
        weight: json["weight"],
        trackerId: json["tracker_id"],
        age: json["age"],
        gender: json["gender"],
        type: AnimalType.fromJson(json["type"]),
        breed: Breed.fromJson(json["breed"]),
      );
}

class Breed {
  final int id;
  final String name;
  final int animalTypeId;

  Breed({
    required this.id,
    required this.name,
    required this.animalTypeId,
  });

  factory Breed.fromJson(Map<String, dynamic> json) => Breed(
        id: json["id"],
        name: json["name"],
        animalTypeId: json["animal_type_id"],
      );
}

class AnimalType {
  final int id;
  final String name;

  AnimalType({
    required this.id,
    required this.name,
  });

  factory AnimalType.fromJson(Map<String, dynamic> json) => AnimalType(
        id: json["id"],
        name: json["name"],
      );
}

class DatumType {
  final int key;
  final String value;

  DatumType({
    required this.key,
    required this.value,
  });

  factory DatumType.fromJson(Map<String, dynamic> json) => DatumType(
        key: json["key"],
        value: json["value"],
      );
}

String convertUnixTimestampToRussianDateTime(int timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  String formattedDateTime = DateFormat('EEEE, MMMM d, y hh:mm:ss a', 'ru_RU').format(dateTime);
  return formattedDateTime;
}

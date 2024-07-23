import 'dart:ui';

class FarmAnimalModel {
  // animal is assigned to the farm
  // tracker is assigned to the animal automatically I guess?

  FarmAnimalModel({
    this.id,
    this.name,
    this.weight,
    this.trackerId,
    this.gender,
    this.age,
    this.animalTypeId,
    this.breedId,
    this.animalTypeName,
    this.breedName,
    
  });

  int? id;
  String? name;
  double? weight;
  String? trackerId;
  String? gender;
  double? age;
  int? animalTypeId;
  int? breedId;
  String? animalTypeName;
  String? breedName;

  factory FarmAnimalModel.fromJson(Map<String, dynamic> json) {
    return FarmAnimalModel(
      id: json["id"],
      name: json["name"],
      weight: json["weight"],
      age: json["age"],
      gender: json["gender"],
      animalTypeId: json["type"] != null ? json["type"]["id"] : 0,
      breedId: json["breed"] != null ? json["breed"]["id"] : 0,
      // trackerId: json["tracking"] != null ? json["tracking"]["tracker_id"] : "",
      trackerId: json["tracker_id"],
      animalTypeName: json["type"] != null ? json["type"]["name"] : "",
      breedName: json["breed"] != null ? json["breed"]["name"] : "",
    );
  }

  bool validate() {
    if (name == null || name!.isEmpty) return false;
    if (weight == null || weight == 0) return false;
    if (trackerId == null || trackerId!.isEmpty) return false;
    if (gender == null || gender!.isEmpty) return false;
    if (age == null || age == 0) return false;
    if (animalTypeId == null || animalTypeId == 0) return false;
    if (breedId == null || breedId == 0) return false;
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "weight": weight,
      "tracker_id": trackerId,
      "gender": gender,
      "age": age,
      "animal_type_id": animalTypeId,
      "animal_breed_id": breedId,
    };
  }
}

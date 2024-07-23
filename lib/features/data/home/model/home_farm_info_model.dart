class HomeFarmInfoData {
  final Map<String, FarmDiagram> diagram;
  final FarmAnimals animals;
  final int trackers;
  final double statistics;
  final List<AnimalType> animalTypes;

  HomeFarmInfoData({
    required this.diagram,
    required this.animals,
    required this.trackers,
    required this.statistics,
    required this.animalTypes,
  });

  factory HomeFarmInfoData.fromJson(Map<String, dynamic> json) {
    final res = json["diagram"] is List ? null : json["diagram"];
    final animal = json["animals"] is List ? null : json["animals"];
    return HomeFarmInfoData(
        diagram: res != null
            ? Map.from(res).map((k, v) =>
                MapEntry<String, FarmDiagram>(k, FarmDiagram.fromJson(v)))
            : {},
        animals: animal != null ? FarmAnimals.fromJson(animal) : FarmAnimals(),
        trackers: json["trackers"],
        animalTypes: List<AnimalType>.from(
            json["animal_types"].map((x) => AnimalType.fromJson(x))),
        statistics: json["statistics"] is int
            ? json["statistics"].toDouble()
            : json["statistics"]);
  }
}

class FarmAnimals {
  final FarmAnimal? farmAnimalKrs;
  final FarmAnimal? farmAnimalMrs;
  final FarmAnimal? farmAnimalHorse;
  final FarmAnimal? farmAnimalTreker;

  FarmAnimals(
      {this.farmAnimalKrs,
      this.farmAnimalMrs,
      this.farmAnimalHorse,
      this.farmAnimalTreker,});

  factory FarmAnimals.fromJson(Map<String, dynamic> json) => FarmAnimals(
        farmAnimalKrs: json["КРС"] != null
            ? FarmAnimal.fromJson(json["КРС"])
            : FarmAnimal(),
        farmAnimalMrs: json["МРС"] != null
            ? FarmAnimal.fromJson(json["МРС"])
            : FarmAnimal(),
        farmAnimalHorse: json["Лошадь"] != null
            ? FarmAnimal.fromJson(json["Лошадь"])
            : FarmAnimal(),
        // farmAnimalTreker: json["Трекер"] != null
        //     ? FarmAnimal.fromJson(json["Трекер"])
        //     : FarmAnimal(),
      );
}

class FarmAnimal {
  final int? total;
  final int? animalTypeId;
  final double? percentage;
  FarmAnimal({this.total = 0, this.animalTypeId = 0, this.percentage = 0});

  factory FarmAnimal.fromJson(Map<String, dynamic> json) => FarmAnimal(
        total: json["total"] ?? 0,
        animalTypeId: json["animal_type_id"] ?? 0,
        percentage: json["percentage"] ?? 0,
      );
}

class FarmDiagram {
  final String steps;
  final int gpsSpeed;
  final int gpsRange;
  final int network;

  FarmDiagram({
    required this.steps,
    required this.gpsSpeed,
    required this.gpsRange,
    required this.network,
  });

  factory FarmDiagram.fromJson(Map<String, dynamic> json) => FarmDiagram(
        steps: json["steps"],
        gpsSpeed: json["gps_speed"],
        gpsRange: json["gps_range"],
        network: json["network"],
      );
}

class AnimalType {
  final int id;
  final String name;

  AnimalType({
    required this.id,
    required this.name,
  });

  factory AnimalType.fromJson(Map<String, dynamic> json) =>
      AnimalType(id: json["id"], name: json["name"]);
}

class HomeInfoAllTrackers {}

import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';

class HomeInfoData {
  HomeInfoData({
    required this.farms,
    required this.animals,
    required this.trackers,
  });

  final HomeFarms farms;
  final FarmAnimals animals;
  final HomeTrackers trackers;

  factory HomeInfoData.fromJson(Map<String, dynamic> json) => HomeInfoData(
        farms: HomeFarms.fromJson(json["farms"]),
        animals: FarmAnimals.fromJson(json["animals"]),
        trackers: HomeTrackers.fromJson(json["trackers"]),
      );
}

class HomeAnimal {
  HomeAnimal({
    required this.total,
    required this.percentage,
    required this.animalTypeId,
  });

  final int total;
  final int percentage;
  final int animalTypeId;

  factory HomeAnimal.fromJson(Map<String, dynamic> json) => HomeAnimal(
        total: json["total"],
        percentage: json["percentage"],
        animalTypeId: json["animal_type_id"],
      );
}

class HomeFarms {
  HomeFarms({
    required this.total,
    required this.percentage,
  });

  final int total;
  final double percentage;

  factory HomeFarms.fromJson(Map<String, dynamic> json) => HomeFarms(
        total: json["total"],
        percentage: json["percentage"],
      );
}

class HomeTrackers {
  HomeTrackers({
    required this.homeTrackerList,
  });

  final List<HomeTracker> homeTrackerList;
  //
  factory HomeTrackers.fromJson(Map<String, dynamic> json) {
    List<HomeTracker> resultList = [];
    json.forEach((key, value) {
      resultList.add(HomeTracker.fromJson(key, value));
    });

    return HomeTrackers(homeTrackerList: resultList);
  }
}

class HomeTracker {
  HomeTracker({
    required this.regionName,
    required this.total,
    required this.regionId,
  });

  final String regionName;
  final int total;
  final int regionId;

  factory HomeTracker.fromJson(String regionName, Map<String, dynamic> json) =>
      HomeTracker(
        regionName: regionName,
        total: json["total"],
        regionId: json["region_id"],
      );
}

class HomeAnimalTableDatabaseModel {
  final List<AnimalSchedule> schedule;

  HomeAnimalTableDatabaseModel({required this.schedule});

  factory HomeAnimalTableDatabaseModel.fromJson(Map<String, dynamic> json) =>
      HomeAnimalTableDatabaseModel(
          schedule: List<AnimalSchedule>.from(
              json["schedule"].map((x) => AnimalSchedule.fromJson(x))));
}

class AnimalSchedule {
  final int id;
  final String trackerId;
  final Type type;
  final int battery;
  final int gpsRange;
  final int gpsSpeed;
  final int network;
  final int steps;

  AnimalSchedule({
    required this.id,
    required this.trackerId,
    required this.type,
    required this.battery,
    required this.gpsRange,
    required this.gpsSpeed,
    required this.network,
    required this.steps,
  });

  factory AnimalSchedule.fromJson(Map<String, dynamic> json) => AnimalSchedule(
        id: json["id"],
        trackerId: json["tracker_id"],
        type: Type.fromJson(json["type"]),
        battery: json["battery"],
        gpsRange: json["gps_range"],
        gpsSpeed: json["gps_speed"],
        network: json["network"],
        steps: json["steps"],
      );
}

class Type {
  final int id;
  final String name;

  Type({
    required this.id,
    required this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        name: json["name"],
      );
}

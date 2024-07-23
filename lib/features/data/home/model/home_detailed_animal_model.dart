class DetailedAnimalInfoData {
  final List<Datum> data;
  final int page;
  final int total;
  final int pages;

  DetailedAnimalInfoData({
    required this.data,
    required this.page,
    required this.total,
    required this.pages,
  });

  factory DetailedAnimalInfoData.fromJson(Map<String, dynamic> json) =>
      DetailedAnimalInfoData(
          data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
          page: json["page"],
          total: json["total"],
          pages: json["pages"]);
}

class Datum {
  final int id;
  final String name;
  final int weight;
  final String trackerId;
  final int age;
  final String gender;
  final Type type;
  final Breed breed;
  final Tracking tracking;

  Datum({
    required this.id,
    required this.name,
    required this.weight,
    required this.trackerId,
    required this.age,
    required this.gender,
    required this.type,
    required this.breed,
    required this.tracking,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["id"],
      name: json["name"],
      weight: json["weight"],
      trackerId: json["tracker_id"],
      age: json["age"],
      gender: json["gender"],
      type: Type.fromJson(json["type"]),
      breed: json["breed"] ?? Breed.fromJson(json["breed"]),
      tracking: Tracking.fromJson(json["tracking"]));
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

class Tracking {
  final int id;
  final String trackerId;
  final int events;
  final double lat;
  final double long;
  final int gpsAlt;
  final int gpsCourse;
  final int gpsSpeed;
  final int gpsRange;
  final int network;
  final int gyroX;
  final int gyroY;
  final int gyroZ;
  final int accelX;
  final int accelY;
  final int accelZ;
  final int steps;
  final int battery;
  final int date;
  final dynamic createdAt;

  Tracking({
    required this.id,
    required this.trackerId,
    required this.events,
    required this.lat,
    required this.long,
    required this.gpsAlt,
    required this.gpsCourse,
    required this.gpsSpeed,
    required this.gpsRange,
    required this.network,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.steps,
    required this.battery,
    required this.date,
    this.createdAt,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) => Tracking(
        id: json["id"],
        trackerId: json["tracker_id"],
        events: json["events"],
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
        gpsAlt: json["gps_alt"],
        gpsCourse: json["gps_course"],
        gpsSpeed: json["gps_speed"],
        gpsRange: json["gps_range"],
        network: json["network"],
        gyroX: json["gyro_x"],
        gyroY: json["gyro_y"],
        gyroZ: json["gyro_z"],
        accelX: json["accel_x"],
        accelY: json["accel_y"],
        accelZ: json["accel_z"],
        steps: json["steps"],
        battery: json["battery"],
        date: json["date"],
        createdAt: json["created_at"],
      );
}

class Type {
  final int id;
  final String name;

  Type({required this.id, required this.name});

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        name: json["name"],
      );
}

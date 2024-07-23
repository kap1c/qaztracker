class MapAnimalHistoryLocationsModel {
  final List<MapAnimalHistoryData> data;
  final int page;
  final int total;
  final int pages;

  MapAnimalHistoryLocationsModel({
    required this.data,
    required this.page,
    required this.total,
    required this.pages,
  });

  factory MapAnimalHistoryLocationsModel.fromJson(Map<String, dynamic> json) =>
      MapAnimalHistoryLocationsModel(
          data: List<MapAnimalHistoryData>.from(
              json["data"].map((x) => MapAnimalHistoryData.fromJson(x))),
          page: json["page"],
          total: json["total"],
          pages: json["pages"]);
}

class MapAnimalHistoryData {
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

  MapAnimalHistoryData({
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

  factory MapAnimalHistoryData.fromJson(Map<String, dynamic> json) =>
      MapAnimalHistoryData(
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

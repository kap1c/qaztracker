class MapAnimalStatisticInfoModel {
  final double steps;
  final double battery;
  final double gpsRange;
  final double network;
  final double gpsSpeed;

  MapAnimalStatisticInfoModel({
    required this.steps,
    required this.battery,
    required this.gpsRange,
    required this.network,
    required this.gpsSpeed,
  });

  factory MapAnimalStatisticInfoModel.fromJson(Map<String, dynamic> json) =>
      MapAnimalStatisticInfoModel(
        steps: json["steps"]?.toDouble(),
        battery: json["battery"] is int
            ? json["battery"].toDouble()
            : json["battery"],
        gpsRange: json["gps_range"]?.toDouble(),
        network: json["network"]?.toDouble(),
        gpsSpeed: json["gps_speed"]?.toDouble(),
      );
}

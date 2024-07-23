// diagram 

class TrackingDiagramInformation {

  TrackingDiagramInformation({
    this.date,
    this.steps,
    this.gpsSpeed,
    this.gpsRange,
    this.network,
  });

  String? date;
  int? steps;
  int? gpsSpeed;
  int? gpsRange;
  int? network;

  factory TrackingDiagramInformation.fromJson(
      Map<String, dynamic> json) {
    if (json["steps"].runtimeType == int) {
      return TrackingDiagramInformation(
        // date: key,
        steps: json["steps"],
        gpsSpeed: json["gps_speed"],
        gpsRange: json["gps_range"],
        network: json["network"],
      );
    } else {
      return TrackingDiagramInformation(
        // date: key,
        steps: int.tryParse(json["steps"]),
        gpsSpeed: json["gps_speed"],
        gpsRange: json["gps_range"],
        network: json["network"],
      );
    }
  }
}

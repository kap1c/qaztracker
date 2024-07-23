import 'package:qaz_tracker/features/data/farm/model/tracking_diagram.dart';

// // Датчики

class FarmTracking {
  int? farmId;
  String? farmFio;
  String? farmName;
  String? phone;
  double? battery;
  double? network;
  List<TrackingDiagramInformation?>? diagram;

  FarmTracking({
    this.farmId,
    this.farmName,
    this.phone,
    this.farmFio,
    this.diagram,
    this.battery,
    this.network,
  });

  factory FarmTracking.fromJson(Map<String, dynamic> json, String key) {
    List<TrackingDiagramInformation> diagram = [];
    // if (json["battery"] == null) {
    json["trackings"].forEach((value) {
      diagram.add(TrackingDiagramInformation.fromJson(value));
    });
    return FarmTracking(
      farmId: json["id"],
      farmFio: json["fio"],
      farmName: json["name"],
      phone: json["phone"],
      battery: json["battery"] ?? 0.0,
      network: json["network"] ?? 0.0,
      diagram: diagram,
    );
    // } else {
    //   return FarmTracking(
    //     farmId: json["id"],
    //     farmFio: json["fio"],
    //     farmName: json["name"],
    //     phone: json["phone"],
    //     battery: json["battery"],
    //     network: json["network"],

    //   );
    // }
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is FarmTracking &&
        other.farmId == farmId &&
        other.farmFio == farmFio &&
        other.farmName == farmName &&
        other.phone == phone &&
        other.battery == battery &&
        other.network == network;
    // listEquals(other.diagram, diagram);
  }

  @override
  int get hashCode {
    return farmId.hashCode ^
        farmFio.hashCode ^
        farmName.hashCode ^
        phone.hashCode ^
        battery.hashCode ^
        network.hashCode ^
        diagram.hashCode;
  }
}

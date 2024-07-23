import 'package:qaz_tracker/features/data/farm/model/trackings_model.dart';

// Ферма


class FarmModel {
  int? id;
  String? name;
  String? fio;
  String? phone;
  double? area;
  String? bin;
  int? trackersCount;
  String? password;
  int? regionId;
  int? headsCount;
  String? regionName;
  String? managerName;

  FarmModel({
    this.id,
    this.name,
    this.fio,
    this.phone,
    this.area,
    this.bin,
    this.trackersCount,
    this.password,
    this.regionId,
    this.regionName,
    this.headsCount,
    this.managerName,
  });

  factory FarmModel.fromJson(Map<String, dynamic> json) => FarmModel(
        id: json["id"],
        name: json["name"],
        fio: json["fio"],
        phone: json["phone"],
        area: json["square_area"],
        bin: json["bin"],
        trackersCount: json["trackers_count"],
        password: json["password"] != null ? json["password"] : "Aa1234567",
        regionId: json["region"] != null ? json["region"]["id"] : null,
        regionName: json["region"] != null ? json["region"]["name"] : null,
        headsCount: json["heads_count"],
        managerName: json["manager"] != null ? json["manager"]["fio"] : null,
      );

  Map<String, dynamic> toJson() {
    String phoneToJson = removePlusSeven(phone!);

    return {
      "name": name,
      "bin": bin,
      "square_area": area,
      "fio": fio,
      "password": password,
      "phone": "+7$phoneToJson",
      "region_id": regionId,
      "heads_count": headsCount,
    };
  }

  bool validate() {
    if (name == null || name!.isEmpty) return false;
    if (bin == null || bin!.isEmpty) return false;
    if (area == null || area! <= 0) return false;
    if (fio == null || fio!.isEmpty) return false;
    if (phone == null || phone!.isEmpty) return false;
    if (regionId == null || regionId! <= 0) return false;
    if ((headsCount == null && trackersCount == null) ||
        (headsCount! <= 0 && trackersCount! <= 0)) return false;

    return true;
  }
}

String removePlusSeven(String input) {
  RegExp regex = RegExp(r'\+7');
  return input.replaceAll(regex, '');
}

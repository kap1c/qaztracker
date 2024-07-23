class ManagerModel {
  int? id;

  String? fio;
  String? phone;
  String? role;

  ManagerModel({
    this.id,
    this.fio,
    this.phone,
    this.role,
  });

  factory ManagerModel.fromJson(Map<String, dynamic> json) => ManagerModel(
        id: json["id"],
        fio: json["fio"],
        phone: json["phone"],
        role: json["role"],
      );
}

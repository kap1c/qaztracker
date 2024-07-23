import 'package:qaz_tracker/common/widgets/notification/cubit/notification_cubit.dart';
import 'package:qaz_tracker/features/data/notification/model/notification_model.dart';

class LogModel {
  int? id;
  String? message;
  String? userName;
  String? role;
  String? createdAt;
  String? submitterIp;

  LogModel({
    this.id,
    this.message,
    this.userName,
    this.role,
    this.createdAt,
    this.submitterIp,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
        id: json["id"],
        message: json["message"],
        userName: json["user"] != null ? json["user"]["fio"] : "",
        role: json["user"] != null ? json["user"]["role"] : "",
        createdAt: convertUnixTimestampToRussianDateTime(json["created_at"]),
        submitterIp: json["submitter_ip"],
      );
}

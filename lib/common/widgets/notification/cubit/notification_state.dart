part of 'notification_cubit.dart';

class NotificationState extends CoreState {
  NotificationState({
    this.notificationsList,
    this.isLoading = false,
    this.numberOfUnseenNotifications,
  });
  bool? isLoading;
  List<NotificationModel>? notificationsList;
  int? numberOfUnseenNotifications;

  NotificationState copyWith({
    List<NotificationModel>? notificationsList,
    bool? isLoading,
    int? numberOfUnseenNotifications,
  }) {
    return NotificationState(
      notificationsList: notificationsList ?? this.notificationsList,
      isLoading: isLoading ?? this.isLoading,
      numberOfUnseenNotifications:
          numberOfUnseenNotifications ?? this.numberOfUnseenNotifications,
    );
  }

  @override
  List<Object?> get props => [
        notificationsList,
        isLoading,
        numberOfUnseenNotifications,
      ];
}

enum NotificationStatus { lowPriority, mediumPriority, highPriority }

class NotificationModel {
  String? message;
  String? notificationDate;
  NotificationStatus? notificationStatus;
  bool? isSeen;
  NotificationModel({
    this.message,
    this.notificationDate,
    this.notificationStatus,
    this.isSeen,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationStatus notificationStatus;
    switch (json["type"]["value"]) {
      case "Не важный":
        notificationStatus = NotificationStatus.lowPriority;
        break;

      case "Средний":
        notificationStatus = NotificationStatus.mediumPriority;

        break;

      case "Очень важный":
        notificationStatus = NotificationStatus.highPriority;

        break;
      default:
        notificationStatus = NotificationStatus.lowPriority;
    }

    return NotificationModel(
      message: json['message'],
      notificationDate:
          convertUnixTimestampToRussianDateTime(json['created_at']),
      notificationStatus: notificationStatus,
      isSeen:json['is_seen']!=null? json['is_seen']:false,
    );
  }
}

// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/features/data/notification/model/notification_model.dart';

class NotificationsState extends CoreState {
  final bool isLoading;
  final List<NotificationItemData> notifications;

  NotificationsState({this.isLoading = false, this.notifications = const []});

  NotificationsState copyWith(
          {bool? isLoading, List<NotificationItemData>? notifications}) =>
      NotificationsState(
          isLoading: isLoading ?? this.isLoading,
          notifications: notifications ?? this.notifications);

  @override
  List<Object> get props => [
        isLoading,
        notifications,
      ];
}

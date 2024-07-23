// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/domain/notification/usecase/notification_usecase.dart';
import 'package:qaz_tracker/features/presentation/notifications/cubit/notification_state.dart';

/// this cubit class responsible for getting new and all notification
/// list fron server and sends to UI
class NotificationCubit extends CoreCubit {
  NotificationCubit()
      : notificatinoUseCase = locator(),
        super(NotificationsState());
  final NotificatinoUseCase notificatinoUseCase;

  late int page = 1;
  late int limit = 15;

  void getNotifications() {
    final request = notificatinoUseCase
        .execute(NotificatinoParams(page: page, limit: limit));
    launchWithError<NotificatinoResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          emit(NotificationsState(isLoading: true));
        },
        resultData: (result) {
          emit(NotificationsState(notifications: result.answer!.data));
        },
        errorData: (error) {
          emit(NotificationsState());
          showErrorCallback?.call(error.detail);
        });
  }

  


}

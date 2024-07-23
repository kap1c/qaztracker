// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/notification/model/notification_model.dart';

/// репозиторий Ask Doubt

class NotificationRepository {
  final QazTrackerApiService _apiService;

  NotificationRepository() : _apiService = locator();

  Future<NotificationsData> getNotificationList({int? page, int? limit}) =>
      safeApiCallWithError(
          _apiService.getNotificationList(
              page: page, limit: limit, ), (response) {
        return NotificationsData.fromJson(response);
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error);
      });
}

// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/notification/model/notification_model.dart';
import 'package:qaz_tracker/features/data/notification/repository/notification_repository.dart';

class NotificatinoUseCase
    extends CoreFutureUseCase<NotificatinoParams, NotificatinoResult> {
  final NotificationRepository notificationRepository;

  NotificatinoUseCase() : notificationRepository = locator();

  @override
  Future<NotificatinoResult> execute(param) async {
    final result = await notificationRepository.getNotificationList(
        limit: param.limit, page: param.page);
    return NotificatinoResult(answer: result);
  }
}

class NotificatinoParams {
  final int? page;
  final int? limit;
  NotificatinoParams({this.page, this.limit});
}

class NotificatinoResult {
  final NotificationsData? answer;
  NotificatinoResult({this.answer});
}

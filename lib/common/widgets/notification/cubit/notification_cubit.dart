import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';
import 'package:qaz_tracker/features/data/notification/model/notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit()
      : _apiService = locator(),
        super(NotificationState());

  late QazTrackerApiService _apiService;

  void fetchNotifications() async{
    // get role
    // final state = _getNotificationState();
    emit(state.copyWith(isLoading: true));
    safeApiCallWithError(_apiService.getNotificationList(),
        (response) {
      List<dynamic> responseJson = response["data"];
      int unseenNotificationsCount = 0;
      List<NotificationModel> notificationList = responseJson.map((e) {
        return NotificationModel.fromJson(e);
      }).toList();

      notificationList.forEach((element) {
        if (!element.isSeen!) {
          unseenNotificationsCount++;
        }
      });

      emit(
        state.copyWith(
          notificationsList: notificationList,
          isLoading: false,
          numberOfUnseenNotifications: unseenNotificationsCount
        ),
      );
    }, (error, defaultError, code) {
      emit(state.copyWith(isLoading: false));
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  void seeNotifications() {
    if (state.notificationsList != null) {
      int count = 0;
      state.notificationsList!.forEach((element) {
        element.isSeen = true;
      });
      state.notificationsList!.forEach((element) {
        if (!element.isSeen!) {
          count++;
        }
      });


      emit(state.copyWith(
          notificationsList: state.notificationsList,
          numberOfUnseenNotifications: count,),);
    }
  }

  // NotificationState _getNotificationState() {
  //   if (state is NotificationState) {
  //     return state as NotificationState;
  //   } else {
  //     return NotificationState(
  //       isLoading: false,
  //       notificationsList: [],
  //     );
  //   }
  // }
}

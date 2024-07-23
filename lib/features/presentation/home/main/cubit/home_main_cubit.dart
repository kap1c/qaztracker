// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';
import 'package:qaz_tracker/features/data/home/model/home_info_model.dart';
import 'package:qaz_tracker/features/domain/home/usecase/home_usecase.dart';
import 'package:qaz_tracker/features/presentation/home/main/cubit/home_main_state.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';

class HomeCubit extends CoreCubit {
  HomeCubit()
      : homeUseCase = locator(),
        globalPersonalSecureDataRepository = locator(),
        super(HomeState());

  final HomeUseCase homeUseCase;
  final GlobalPersonalSecureDataRepository globalPersonalSecureDataRepository;

  late HomeInfoData _homeInfoData;

  int page = 1;
  int limit = 100;

  void fetchHomeScreenData() async {
    final String? userRole =
        await globalPersonalSecureDataRepository.getUserRole();
    final request = homeUseCase.execute(HomeParams(role: userRole));
    final state = HomeState();
    launchWithError<HomeResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          if (isLoading) {
            emit(state.copyWith(isLoading: true));
          } else {
            emit(state.copyWith(isBottomLoading: true));
          }
        },
        resultData: (result) {
          _homeInfoData = result.homeInfoData!;
          emit(
            state.copyWith(homeInfoData: _homeInfoData, isLoading: false),
          );
        },
        errorData: (error) {
          emit(state);
          showErrorCallback?.call(error.detail);
        });
  }

  // void getFarmHomeInfo({bool isShowLoading = true}) {
  //   final state = _getSearchCityState();
  //   final request = homeFarmUseCase.execute(HomeFarmParams(
  //       filterRange: filterRange, statisticType: homeStatisticType));
  //   launchWithError<HomeFarmResult, HttpExceptionData>(
  //       request: request,
  //       loading: (isLoading) {
  //         if (isShowLoading) {
  //           emit(state.copyWith(isLoading: true));
  //         } else {
  //           emit(state.copyWith(isBottomLoading: true));
  //         }
  //       },
  //       resultData: (result) {
  //         _homeFarmInfoData = result.homeInfoData!;
  //         emit(
  //           state.copyWith(
  //               filterRange: filterRange,
  //               homeFarmInfoData: _homeFarmInfoData,
  //               homeTypeFilter: homeStatisticType,
  //               isLoading: false),
  //         );
  //       },
  //       errorData: (error) {
  //         emit(state);
  //         showErrorCallback.call(error.detail);
  //       });
  // }

  // void selectHomeStatisticsType(String val) {
  //   final state = _getSearchCityState();
  //   homeStatisticType = val;
  //   emit(state.copyWith(
  //     homeTypeFilter: homeStatisticType,
  //     filterRange: filterRange,
  //   ));
  //   getFarmHomeInfo();
  // }

  // void selectHomeFilterRange(String val) {
  //   filterRange = val;

  //   getFarmHomeInfo(isShowLoading: false);
  // }

  // HomeState _getSearchCityState() {
  //   if (state is HomeState) {
  //     return state as HomeState;
  //   }
  //   return HomeState(
  //     homeTypeFilter: homeStatisticType,
  //     homeFarmInfoData: _homeFarmInfoData,
  //     filterRange: filterRange,
  //   );
  // }
}

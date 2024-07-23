// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/home/model/home_animal_database_model.dart';
import 'package:qaz_tracker/features/domain/home/usecase/home_detailed_animal_usecase.dart';
import 'package:qaz_tracker/features/domain/home/usecase/home_farm_usecase.dart';
import 'package:qaz_tracker/features/domain/home/usecase/home_usecase.dart';
import 'package:qaz_tracker/features/presentation/home/detailed/cubit/home_detailed_state.dart';

class HomeDetailedCubit extends CoreCubit {
  HomeDetailedCubit()
      : homeUseCase = locator(),
        homeFarmUseCase = locator(),
        homeDetailedAnimalUseCase = locator(),
        super(HomeDetailState());

  final HomeUseCase homeUseCase;
  final HomeFarmUseCase homeFarmUseCase;
  final HomeDetailedAnimalUseCase homeDetailedAnimalUseCase;

  late HomeAnimalTableDatabaseModel homeAnimalTableDatabaseModel;

  String homeStatisticType = 'steps';
  String filterRange = 'month';
  int page = 1;
  int limit = 10;
  int? animalType;

  void getDetailedAnimalInfo({int? animalTypeId}) {
    animalType = animalTypeId;
    final state = _getSearchCityState();
    final request = homeDetailedAnimalUseCase.execute(HomeDetailedAnimalParams(
        page: page, limit: limit, animalTypeId: animalType));
    launchWithError<HomeDetailedAnimalResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          emit(state.copyWith(isLoading: true));
        },
        resultData: (result) {
          if (result != null) {
            homeAnimalTableDatabaseModel = result.homeAnimalTableDatabaseModel!;

            emit(state.copyWith(
                filterRange: filterRange,
                homeTypeFilter: homeStatisticType,
                detailedAnimalInfoData: homeAnimalTableDatabaseModel));
          }
        },
        errorData: (error) {
          emit(state);
          showErrorCallback?.call(error.detail);
        });
  }

  void selectHomeFilterRange(String val) {
    filterRange = val;
    getDetailedAnimalInfo();
  }

  HomeDetailState _getSearchCityState() {
    if (state is HomeDetailState) {
      return state as HomeDetailState;
    }
    return HomeDetailState(
        homeTypeFilter: homeStatisticType,
        filterRange: filterRange,
        detailedAnimalInfoData: homeAnimalTableDatabaseModel);
  }
}

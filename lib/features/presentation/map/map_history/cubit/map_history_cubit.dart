// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/constants/app_global_regex_consts.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_history_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_statistics_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_regions_model.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_animal_move_history_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_animal_statistics_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_points_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_regions_usecase.dart';
import 'package:qaz_tracker/features/presentation/map/map_main/cubit/map_state.dart';
import 'package:qaz_tracker/features/presentation/map/map_history/cubit/map_history_state.dart';
import 'package:qaz_tracker/features/presentation/map/mixin/map_info_mixin.dart';

class MapHistoryCubit extends CoreCubit with MapDataMixin {
  MapHistoryCubit()
      : mapRegionsUseCase = locator(),
        mapPointsUseCase = locator(),
        mapAnimalHistoryMoveCase = locator(),
        mapAnimalStatisticsUseCase = locator(),
        globalPersonalSecureDataRepository = locator(),
        super(MapState());

  final MapRegionsUseCase mapRegionsUseCase;
  final MapPointsUseCase mapPointsUseCase;
  final MapAnimalHistoryMoveCase mapAnimalHistoryMoveCase;
  final MapAnimalStatisticsUseCase mapAnimalStatisticsUseCase;
  final GlobalPersonalSecureDataRepository globalPersonalSecureDataRepository;

  late RegionsData? regionsDataList;
  RegionsData? get getRegionDataList => regionsDataList;
  late String selectedRegionList = CoreConstant.empty;
  late String filterIdTraker = CoreConstant.empty;
  String? rangeDate = 'all';
  late MapInfoData? mapInfoData;
  int? limit = 14;
  MapAnimalHistoryLocationsModel? mapAnimalHistoryLocationsModel;
  MapAnimalStatisticInfoModel? mapAnimalStatisticInfoModel;

  /// get all History of movement and locations in specific time period
  void getHistoryMovementOfMapAnimal(int animalId) {
    // String? userRole = await globalPersonalSecureDataRepository.getUserRole();

    final request = mapAnimalHistoryMoveCase.execute(
      MapAnimalHistoryParams(
        animalId: animalId,
        page: 1,
        limit: 40,
        
      ),
    );
    final state = _getMapAnimalHistoryState();
    launchWithError<MapAnimalHistoryResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          emit(MapAnimalHistoryState(isLoading: true));
        },
        resultData: (result) {
          if (result.mapInfoData != null) {
            mapAnimalHistoryLocationsModel = result.mapInfoData;
          }
          // _getMapSelectedAnimalStatistics(animalId);
          emit(state.copyWith(
              isLoading: false,
              mapAnimalHistoryLocationsModel: mapAnimalHistoryLocationsModel));
        },
        errorData: (error) {
          emit(MapAnimalHistoryState());
          showErrorCallback?.call(error.detail);
        });
  }

  /// get all History of movement and locations in specific time period
  // void _getMapSelectedAnimalStatistics(int animalId) async {
  //   String? userRole = await globalPersonalSecureDataRepository.getUserRole();

  //   final state = _getMapAnimalHistoryState();
  //   final request = mapAnimalStatisticsUseCase.execute(MapAnimalStatisticsParam(
  //       animalId: animalId, rangeDate: rangeDate, role: userRole));
  //   launchWithError<MapAnimalStatisticsResult, HttpExceptionData>(
  //       request: request,
  //       loading: (isLoading) {
  //         emit(state.copyWith(isLoading: true));
  //       },
  //       resultData: (result) {
  //         if (result.mapAnimalStatisticInfoModel != null) {
  //           mapAnimalStatisticInfoModel = result.mapAnimalStatisticInfoModel;
  //         }
  //         emit(state.copyWith(
  //             mapAnimalHistoryLocationsModel: mapAnimalHistoryLocationsModel,
  //             mapAnimalStatisticInfoModel: mapAnimalStatisticInfoModel));
  //       },
  //       errorData: (error) {
  //         emit(state);
  //         showErrorCallback.call(error.detail);
  //       });
  // }

  void selectMapStatisticFilterRange(String val, int animalId) {
    rangeDate = val;
    if (rangeDate == 'week') {
      limit = 14;
    } else if (rangeDate == 'month') {
      limit = 60;
    } else if (rangeDate == 'all') {
      limit = 720;
    }

    getHistoryMovementOfMapAnimal(animalId);
  }

  MapAnimalHistoryState _getMapAnimalHistoryState() {
    if (state is MapAnimalHistoryState) {
      return state as MapAnimalHistoryState;
    }
    return MapAnimalHistoryState(
        mapAnimalHistoryLocationsModel: mapAnimalHistoryLocationsModel);
  }
}

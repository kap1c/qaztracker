// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_animal_move_history_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_animal_statistics_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_points_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_regions_usecase.dart';
import 'package:qaz_tracker/features/presentation/map/map_main/cubit/map_state.dart';
import 'package:qaz_tracker/features/presentation/map/mixin/map_info_mixin.dart';

class MapCubit extends CoreCubit with MapDataMixin {
  MapCubit()
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

  // late RegionsData?  regionsDataList;
  // RegionsData? get getRegionDataList => regionsDataList;
  late String selectedRegionList = CoreConstant.empty;
  late String filterIdTraker = CoreConstant.empty;
  late double? trackersLimit = 10000;
  late MapInfoData? mapInfoData;
  List<MapDataClass>? selectedMapAnimalCategories;

  /// get general and all objects with detailed information
  void getAllMapInfo({Map<String, dynamic>? queryParams}) async {
    String? userRole = await globalPersonalSecureDataRepository.getUserRole();

    selectedMapAnimalCategories = getAnimalCategories;
    List<String> selectedAnimalTypeIds = [];
    List<String> selectedRegionIds = [];
    List<String> selectedFarmIds = [];
    final state = _getMapState();

    if (queryParams != null) {
      if (queryParams.containsKey('tracker_id')) {
        filterIdTraker = queryParams['trackerId'];
      }
      if (queryParams.containsKey('trackers_limit')) {
        trackersLimit = queryParams['trackers_limit'];
      } else {
        trackersLimit = 2000;
      }
      if (queryParams.containsKey('animal_type_ids[]')) {
        selectedAnimalTypeIds = queryParams["animal_type_ids[]"];
      }
      if (queryParams.containsKey('region_ids[]')) {
        selectedRegionIds = queryParams['region_ids[]'];
      }
      if (queryParams.containsKey('farm_ids[]')) {
        selectedFarmIds = queryParams['farm_ids[]'];
      }
    }

    final request = mapPointsUseCase.execute(
      MapPointsParams(
        trackersLimit: trackersLimit!.toInt(),
        animalTypeIds: selectedAnimalTypeIds,
        selectedRegionIds: selectedRegionIds,
        selectedFarmIds: selectedFarmIds,
        trackerId: filterIdTraker,
        role: userRole,
      ),
    );

    launchWithError<MapPointsResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          emit(state.copyWith(isLoading: isLoading));
        },
        resultData: (result) {
          if (result != null) {
            mapInfoData = result.mapInfoData!;
          }
          emit(state.copyWith(
              mapInfoData: mapInfoData,
              getMapAnimalCategories: selectedMapAnimalCategories,
              // regionsDataList: regionsDataList,
              trackersLimit: trackersLimit));
        },
        errorData: (error) {
          emit(state);
          showErrorCallback!.call(error.detail);
        });
  }

  // /// get all regions in Kazakhstan needed for filtering
  // void getAllRegions() {
  //   final state = _getMapState();

  //   final request =
  //       mapRegionsUseCase.execute(MapRegionsParams(page: 0, limit: 100));

  //   launchWithError<MapRegionsResult, HttpExceptionData>(
  //       request: request,
  //       loading: (isLoading) {
  //         emit(state.copyWith(isLoading: true));
  //       },
  //       resultData: (result) {
  //         regionsDataList = result.regionsData;
  //         emit(state.copyWith(regionsDataList: regionsDataList));
  //       },
  //       errorData: (error) {
  //         emit(state);
  //         showErrorCallback.call(error.detail);
  //       });
  // }

  /// set specific filter with tracker ID
  // void setMapFilterIdTracker(String? val) {
  //   final state = _getMapState();
  //   filterIdTraker = val!;
  //   emit(state.copyWith(
  //     mapFilterIdTracker: filterIdTraker,
  //     // animalMapType: animalTypeIds,
  //     selectedRegionList: selectedRegionList,
  //     regionsDataList: regionsDataList,
  //     trackersLimit: trackersLimit,
  //   ));
  // }

  // /// select & reselect animal type from filter bottomsheet
  // void selectAnimalType(int index) {
  //   final state = _getMapState();

  //   selectedMapAnimalCategories![index].isSelected =
  //       selectedMapAnimalCategories![index].isSelected ? false : true;

  //   /// this emit(null) needed to reset state of filter widget state when select and reselect
  //   emit(null);

  //   emit(state.copyWith(
  //     getMapAnimalCategories: selectedMapAnimalCategories,
  //     mapFilterIdTracker: filterIdTraker,
  //     selectedRegionList: selectedRegionList,
  //     regionsDataList: regionsDataList,
  //     trackersLimit: trackersLimit,
  //   ));
  // }

  // /// here to select and reselect Region from UI(UI element maybe removed but u can find it from git history)  from filter bottomsheet filter
  // void selectRegion(int id) {
  //   final state = _getMapState();

  //   regionsDataList!.items
  //       .firstWhere((element) => element.id == id)
  //       .isSelected = regionsDataList!.items
  //           .firstWhere((element) => element.id == id)
  //           .isSelected
  //       ? false
  //       : true;
  //   final res =
  //       regionsDataList!.items.where((element) => element.isSelected).toList();
  //   selectedRegionList = res.map((e) => e.name).toList().join(', ');

  //   emit(null);
  //   emit(state.copyWith(
  //     selectedRegionList: selectedRegionList,
  //     mapFilterIdTracker: filterIdTraker,
  //     trackersLimit: trackersLimit,
  //     regionsDataList: regionsDataList,
  //   ));
  // }

  // /// this method responsible for sorting and filtering data on the map by sending request to server
  // void doFilterMap() {
  //   getAllMapInfo();
  // }

  // /// we need to reset or clean all local cubit variables
  // void clearFilter() {
  //   selectedRegionList = CoreConstant.empty;
  //   filterIdTraker = CoreConstant.empty;
  //   trackersLimit = 10000;
  //   // animalTypeIds.clear();
  //   // animalTypeIds.add(0);
  //   mapInfoData = null;
  // }

  // /// set and resubmit local and ui state data for trackers limit
  // void setTrackersLimit(double? limit) {
  //   final state = _getMapState();
  //   trackersLimit = limit;
  //   emit(state.copyWith(
  //     selectedRegionList: selectedRegionList,
  //     mapFilterIdTracker: filterIdTraker,
  //     trackersLimit: trackersLimit,
  //     regionsDataList: regionsDataList,
  //   ));
  // }

  MapState _getMapState() {
    if (state is MapState) {
      return state as MapState;
    }
    return MapState(
        isLoading: false,
        mapInfoData: mapInfoData,
        trackersLimit: trackersLimit,
        // regionsDataList: regionsDataList,
        mapFilterIdTracker: filterIdTraker,
        getMapAnimalCategories: selectedMapAnimalCategories,
        selectedRegionList: selectedRegionList);
  }
}

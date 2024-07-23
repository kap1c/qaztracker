import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/farm/model/farm_model.dart';
// import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_regions_model.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_animal_move_history_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_animal_statistics_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_points_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_regions_usecase.dart';
import 'package:qaz_tracker/features/presentation/map/mixin/map_info_mixin.dart';
import 'package:bloc/bloc.dart';

// ignore_for_file: import_of_legacy_library_into_null_safe

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit()
      : mapRegionsUseCase = locator(),
        mapPointsUseCase = locator(),
        mapAnimalHistoryMoveCase = locator(),
        mapAnimalStatisticsUseCase = locator(),
        globalPersonalSecureDataRepository = locator(),
        qazTrackerApi = locator(),
        super(FilterState());

  final MapRegionsUseCase mapRegionsUseCase;
  final MapPointsUseCase mapPointsUseCase;
  final MapAnimalHistoryMoveCase mapAnimalHistoryMoveCase;
  final MapAnimalStatisticsUseCase mapAnimalStatisticsUseCase;
  final GlobalPersonalSecureDataRepository globalPersonalSecureDataRepository;
  final QazTrackerApiService qazTrackerApi;

  late RegionsData? regionsDataList;
  RegionsData? get getRegionDataList => regionsDataList;
  bool? isLoadingRegions = true;
  bool? isLoadingFarms = true;

  late List<FarmData>? farmDataList;

  late String selectedRegionList = CoreConstant.empty;
  Set<int> selectedRegionIds = {};
  Set<int> selectedFarmIds = {};
  Set<int> animalMapType = {};

  late String filterIdTraker = CoreConstant.empty;
  late double? trackersLimit;
  late MapInfoData? mapInfoData;
  List<MapDataClass>? selectedMapAnimalCategories;

  void getAllFilterInfo() {
    // String? userRole = await globalPersonalSecureDataRepository.getUserRole();
    // selectedMapAnimalCategories = getAnimalCategories;

    emit(
      state.copyWith(
        getMapAnimalCategories: [
          MapDataClass(
              id: 3,
              icon: AppSvgImages.homeGoatIcon,
              title: 'МРС',
              amount: 0,
              code: 'mrs',
              bgColor: AppColors.secondaryRedColor),
          MapDataClass(
              id: 1,
              icon: AppSvgImages.homeCowIcon,
              title: 'КРС',
              amount: 0,
              code: 'krs',
              bgColor: AppColors.secondaryGreenColor),
          MapDataClass(
              id: 2,
              icon: AppSvgImages.homeHorseIcon,
              title: 'Лошадь',
              code: 'horse',
              amount: 0,
              bgColor: AppColors.secondaryOrangeColor),
        ],
        trackersLimit: 100,
      ),
    );
  }

  void getAllRegions() {
    emit(state.copyWith(loadingRegions: true));

    safeApiCallWithError(qazTrackerApi.getRegionsList(0, 40), (response) {
      emit(state.copyWith(
          loadingRegions: false,
          regionsDataList: RegionsData.fromJson(response)));
    }, (error, defaultError, code) {
      emit(state.copyWith(loadingRegions: false, regionsDataList: null));
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  void getAllFarms() {
    emit(state.copyWith(loadingFarms: true));
    safeApiCallWithError(
        qazTrackerApi.getTableData(
            category: "farm", queryParameters: {"limit": 1000}), (response) {
      final List<dynamic> farmList = response["data"];

      final List<FarmData> _farmDataList = [];
      farmList.forEach((element) {
        _farmDataList.add(FarmData.fromJson(element));
      });

      emit(state.copyWith(
        farmDataList: _farmDataList,
        loadingFarms: false,
      ));
    }, (error, defaultError, code) {
      emit(state.copyWith(loadingRegions: false, regionsDataList: null));
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  void getAllAnimalTypes() {
    emit(state.copyWith(isLoading: true));
    safeApiCallWithError(qazTrackerApi.getAllInfo(limit: 100), (response) {
      // List<Breed> breedItems = [];
      // response["breeds"]["items"].forEach((element) {
      //   breedItems.add(Breed.fromJson(element));
      // });

      List<AnimalType> animalTypeItems = [];
      response["animal_types"]["items"].forEach((element) {
        animalTypeItems.add(AnimalType.fromJson(element));
      });

      emit(state.copyWith(
        isLoading: false,

        // animalBreeds: breedItems,
        // animalTypes: animalTypeItems,
      ));
    }, (error, defaultError, code) {
      emit(state.copyWith(isLoading: false));
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  Map<String, dynamic> returnQueryParams() {
    return state.toQuery();
  }

  /// set specific filter with tracker ID
  void setMapFilterIdTracker(String? val) {
    filterIdTraker = val!;
    emit(state.copyWith(
      mapFilterIdTracker: filterIdTraker,
    ));
  }

  void selectRegion(int id) {
    if (selectedRegionIds.contains(id)) {
      selectedRegionIds.remove(id);
    } else {
      selectedRegionIds.add(id);
    }
    log(selectedRegionIds.toString());
    emit(state.copyWith(
      selectedRegionIds: selectedRegionIds,
    ));
  }

  void selectdDateRange(Map<String, String> selectedDateRange) {
    emit(state.copyWith(
      selectedDateRange: selectedDateRange,
    ));
  }

  void setTrackerUpperBound(double? upperBound) {
    emit(state.copyWith(
      trackerUpperBound: upperBound != null ? upperBound.toInt() : 0,
    ));
  }

  void setTrackerLowerBound(double? lowerBound) {
    emit(state.copyWith(
      trackerLowerBound: lowerBound != null ? lowerBound.toInt() : 0,
    ));
  }

  /// set and resubmit local and ui state data for trackers limit
  // void setTrackersLimit(double? limit) {
  //   emit(state.copyWith(
  //     trackersLimit: limit!=null? limit.toInt():0,
  //   ));
  // }

  void setFarm(int farmId) {
    if (selectedFarmIds.contains(farmId)) {
      selectedFarmIds.remove(farmId);
    } else {
      selectedFarmIds.add(farmId);
    }
    emit(
      state.copyWith(
        selectedFarmIds: selectedFarmIds,
      ),
    );
  }

  void setFarmIdToFetchTrackings(int id) {
    if (state.farmIdToFetchTrackings == id) {
      id = 0;
    }

    emit(
      state.copyWith(
        farmIdToFetchTrackings: id,
      ),
    );
  }

  void setBin(int BIN) {
    emit(
      state.copyWith(
        BIN: BIN,
      ),
    );
  }

  /// we need to reset or clean all local cubit variables
  void clearFilter() {
    selectedRegionIds = <int>{};
    selectedFarmIds = <int>{};
    animalMapType = <int>{};

    emit(state.copyWith(
      selectedRegionIds: selectedRegionIds,
      selectedFarmIds: selectedFarmIds,
      selectedDateRange: {"all": "За все время"},
      trackerUpperBound: 1000,
      trackerLowerBound: 0,
      animalMapType: animalMapType,
      farmIdToFetchTrackings: 0,
      BIN: 0,
      mapFilterIdTracker: '',
      batteryLowerBound: 0,
      batteryUpperBound: 100,
      signalLowerBound: 0,
      signalUpperBound: 100,
    ));
  }

  void selectAnimalType(int index) {
    if (animalMapType.contains(index)) {
      animalMapType.remove(index);
    } else {
      animalMapType.add(index);
    }
    // selectedMapAnimalCategories =
    //     getAnimalCategories.where((element) => element.id == index).toList();

    emit(state.copyWith(
      // getMapAnimalCategories: selectedMapAnimalCategories,
      animalMapType: animalMapType,
    ));
  }

  void setBatteryLowerBound(double? val) {
    emit(state.copyWith(batteryLowerBound: val != null ? val.toInt() : 0));
  }

  void setBatteryUpperBound(double? val) {
    emit(state.copyWith(batteryUpperBound: val != null ? val.toInt() : 0));
  }

  void setSignalLowerBound(double? val) {
    emit(state.copyWith(signalLowerBound: val != null ? val.toInt() : 0));
  }

  void setSignalUpperBound(double? val) {
    emit(state.copyWith(signalUpperBound: val != null ? val.toInt() : 0));
  }
}

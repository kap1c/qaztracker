// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';
import 'package:qaz_tracker/features/data/home/model/home_info_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_regions_model.dart';

class MapState extends CoreState {
  final bool isLoading;
  final bool isSuccessfullyLogged;
  final List<int?> animalMapType;
  // final RegionsData? regionsDataList;
  final String? selectedRegionList;
  final String? mapFilterIdTracker;
  final MapInfoData? mapInfoData;
  final double? trackersLimit;
  final List<MapDataClass>? getMapAnimalCategories;

  MapState(
      {this.isLoading = false,
      this.isSuccessfullyLogged = false,
      this.animalMapType = const [],
      this.selectedRegionList,
      this.mapFilterIdTracker,
      this.mapInfoData,
      this.getMapAnimalCategories,
      this.trackersLimit = 10000,
      // this.regionsDataList,
      });

  MapState copyWith(
          {bool? isLoading,
          bool? isSuccessfullyLogged = false,
          HomeInfoData? homeInfoData,
          List<int?> animalMapType = const [],
          String? selectedRegionList,
          List<MapDataClass>? getMapAnimalCategories,
          String? mapFilterIdTracker,
          HomeFarmInfoData? homeFarmInfoData,
          MapInfoData? mapInfoData,
          double? trackersLimit = 10000,
          RegionsData? regionsDataList}) =>
      MapState(
          isLoading: isLoading ?? this.isLoading,
          trackersLimit: trackersLimit ?? this.trackersLimit,
          getMapAnimalCategories:
              getMapAnimalCategories ?? this.getMapAnimalCategories,
          mapInfoData: mapInfoData ?? this.mapInfoData,
          animalMapType: animalMapType,
          // regionsDataList: regionsDataList ?? this.regionsDataList,
          selectedRegionList: selectedRegionList ?? this.selectedRegionList,
          mapFilterIdTracker: mapFilterIdTracker ?? this.mapFilterIdTracker,
          isSuccessfullyLogged:
              isSuccessfullyLogged ?? this.isSuccessfullyLogged);

  @override
  List<Object?> get props => [
        isLoading,
        isSuccessfullyLogged,
        animalMapType,
        // regionsDataList,
        selectedRegionList,
        mapFilterIdTracker,
        mapInfoData,
        trackersLimit,
        getMapAnimalCategories,
      ];
}

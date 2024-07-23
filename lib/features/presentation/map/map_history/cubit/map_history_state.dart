// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_history_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_statistics_model.dart';

class MapAnimalHistoryState extends CoreState {
  final bool isLoading;
  final MapAnimalHistoryLocationsModel? mapAnimalHistoryLocationsModel;
  final MapAnimalStatisticInfoModel? mapAnimalStatisticInfoModel;

  MapAnimalHistoryState({
    this.isLoading = false,
    this.mapAnimalHistoryLocationsModel,
    this.mapAnimalStatisticInfoModel,
  });

  MapAnimalHistoryState copyWith({
    bool? isLoading = false,
    MapAnimalHistoryLocationsModel? mapAnimalHistoryLocationsModel,
    MapAnimalStatisticInfoModel? mapAnimalStatisticInfoModel,
  }) =>
      MapAnimalHistoryState(
        isLoading: isLoading ?? this.isLoading,
        mapAnimalStatisticInfoModel:
            mapAnimalStatisticInfoModel ?? this.mapAnimalStatisticInfoModel,
        mapAnimalHistoryLocationsModel: mapAnimalHistoryLocationsModel ??
            this.mapAnimalHistoryLocationsModel,
      );

  @override
  List<Object?> get props =>
      [isLoading, mapAnimalHistoryLocationsModel, mapAnimalStatisticInfoModel];
}

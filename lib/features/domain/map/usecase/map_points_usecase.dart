// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/data/map/repository/map_repository.dart';

class MapPointsUseCase
    extends CoreFutureUseCase<MapPointsParams, MapPointsResult> {
  final MapRepository mapRepository;

  MapPointsUseCase() : mapRepository = locator();

  @override
  Future<MapPointsResult> execute(param) async {
    final result = await mapRepository.getMapLocationsRepo(
        trackersLimit: param.trackersLimit,
        trackerId: param.trackerId,
        animalTypeIds: param.animalTypeIds,
        role: param.role,
        selectedFarmIds: param.selectedFarmIds,
        selectedRegionIds: param.selectedRegionIds
        );
    return MapPointsResult(mapInfoData: result);
  }
}

class MapPointsParams {
  final int? trackersLimit;
  final List<String?> animalTypeIds;
  final List<String?> selectedRegionIds;
  List<String?> selectedFarmIds;
  final String? trackerId;
  final String? role;
  MapPointsParams(
      {this.trackersLimit,
      this.animalTypeIds = const [],
      this.selectedRegionIds = const[],
      this.selectedFarmIds = const[],
      this.trackerId,
      this.role});
}

class MapPointsResult {
  final MapInfoData? mapInfoData;
  MapPointsResult({this.mapInfoData});
}

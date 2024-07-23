// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_history_model.dart';
import 'package:qaz_tracker/features/data/map/repository/map_repository.dart';

class MapAnimalHistoryMoveCase
    extends CoreFutureUseCase<MapAnimalHistoryParams, MapAnimalHistoryResult> {
  final MapRepository mapRepository;

  MapAnimalHistoryMoveCase() : mapRepository = locator();

  @override
  Future<MapAnimalHistoryResult> execute(param) async {
    final result = await mapRepository.getAnimalHistoryOfMoveRepo(
        page: param.page,
        limit: param.limit,
        animalId: param.animalId,
        role: param.role);
    return MapAnimalHistoryResult(mapInfoData: result);
  }
}

class MapAnimalHistoryParams {
  final int? animalId;
  final String? role;
  final int? page;
  final int? limit;
  final int? farmId;
  MapAnimalHistoryParams({this.animalId, this.role, this.limit, this.page, this.farmId});
}

class MapAnimalHistoryResult {
  final MapAnimalHistoryLocationsModel? mapInfoData;
  MapAnimalHistoryResult({this.mapInfoData});
}

// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_statistics_model.dart';
import 'package:qaz_tracker/features/data/map/repository/map_repository.dart';

/// get selected animal statistics info from server
class MapAnimalStatisticsUseCase extends CoreFutureUseCase<
    MapAnimalStatisticsParam, MapAnimalStatisticsResult> {
  final MapRepository mapRepository;

  MapAnimalStatisticsUseCase() : mapRepository = locator();

  @override
  Future<MapAnimalStatisticsResult> execute(param) async {
    final result = await mapRepository.getAnimalStatisticsByRangeTimeRepo(
        rangeDate: param.rangeDate, animalId: param.animalId, role: param.role);
    return MapAnimalStatisticsResult(mapAnimalStatisticInfoModel: result);
  }
}

class MapAnimalStatisticsParam {
  final int? animalId;
  final String? role;
  final String? rangeDate;

  MapAnimalStatisticsParam({this.animalId, this.role, this.rangeDate});
}

class MapAnimalStatisticsResult {
  final MapAnimalStatisticInfoModel? mapAnimalStatisticInfoModel;
  MapAnimalStatisticsResult({this.mapAnimalStatisticInfoModel});
}

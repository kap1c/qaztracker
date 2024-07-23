// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/map/model/map_regions_model.dart';
import 'package:qaz_tracker/features/data/map/repository/map_repository.dart';

class MapRegionsUseCase
    extends CoreFutureUseCase<MapRegionsParams, MapRegionsResult> {
  final MapRepository mapRepository;

  MapRegionsUseCase() : mapRepository = locator();

  @override
  Future<MapRegionsResult> execute(param) async {
    final result = await mapRepository.getRegionsRepo(
        limit: param.limit, page: param.page);
    return MapRegionsResult(regionsData: result);
  }
}

class MapRegionsParams {
  final int? page;
  final int? limit;
  MapRegionsParams({this.page, this.limit});
}

class MapRegionsResult {
  final RegionsData? regionsData;
  MapRegionsResult({this.regionsData});
}

// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';
import 'package:qaz_tracker/features/data/home/repository/home_repository.dart';

class HomeFarmUseCase
    extends CoreFutureUseCase<HomeFarmParams, HomeFarmResult> {
  final HomeRepository homeRepository;

  HomeFarmUseCase() : homeRepository = locator();

  @override
  Future<HomeFarmResult> execute(param) async {
    final res = await homeRepository.getFarmHomeInfoRepository(
        statisticType: param.statisticType, rangeFilter: param.filterRange);

    return HomeFarmResult(homeInfoData: res);
  }
}

class HomeFarmResult {
  final HomeFarmInfoData? homeInfoData;
  HomeFarmResult({this.homeInfoData});
}

class HomeFarmParams {
  final String? statisticType;
  final String? filterRange;
  final String? role;
  HomeFarmParams({this.statisticType, this.filterRange, this.role});
}

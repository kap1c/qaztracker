// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:developer';

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/home/model/home_info_model.dart';
import 'package:qaz_tracker/features/data/home/repository/home_repository.dart';
import 'package:qaz_tracker/features/domain/home/usecase/home_farm_usecase.dart';

class HomeUseCase extends CoreFutureUseCase<HomeParams, HomeResult> {
  final HomeRepository homeRepository;

  HomeUseCase() : homeRepository = locator();

  @override
  Future<HomeResult> execute(param) async {
    final res = await homeRepository.getAdminHomeInfoRepository(
      role: param.role,
    );
    log(res.toString());
    return HomeResult(homeInfoData: res);
  }
}

class HomeResult {
  final HomeInfoData? homeInfoData;
  HomeResult({this.homeInfoData});
}

class HomeParams {
  final String? role;
  HomeParams({this.role});
}

// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/home/model/home_animal_database_model.dart';
import 'package:qaz_tracker/features/data/home/repository/home_repository.dart';

class HomeDetailedAnimalUseCase extends CoreFutureUseCase<
    HomeDetailedAnimalParams, HomeDetailedAnimalResult> {
  final HomeRepository homeRepository;

  HomeDetailedAnimalUseCase() : homeRepository = locator();

  @override
  Future<HomeDetailedAnimalResult> execute(param) async {
    final res = await homeRepository.getDetailedAnimalInfoRepo(
        page: param.page,
        limit: param.limit,
        range: param.range,
        animalTypeId: param.animalTypeId);

    return HomeDetailedAnimalResult(homeAnimalTableDatabaseModel: res);
  }
}

class HomeDetailedAnimalResult {
  final HomeAnimalTableDatabaseModel? homeAnimalTableDatabaseModel;
  HomeDetailedAnimalResult({this.homeAnimalTableDatabaseModel});
}

class HomeDetailedAnimalParams {
  final int? page;
  final int? limit;
  final String? range;
  final int? animalTypeId;

  HomeDetailedAnimalParams(
      {this.page, this.limit, this.animalTypeId, this.range});
}

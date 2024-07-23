// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/home/model/home_animal_database_model.dart';
import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';
import 'package:qaz_tracker/features/data/home/model/home_info_model.dart';

/// repository get and do call server side request about home screen stuffs
class HomeRepository {
  final QazTrackerApiService _apiService;

  HomeRepository() : _apiService = locator();

  Future<HomeInfoData> getAdminHomeInfoRepository({String? role}) =>
      safeApiCallWithError(_apiService.getHomeInfo(), (response) {
        return HomeInfoData.fromJson(response);
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error['message']);
      });

  Future<HomeFarmInfoData> getFarmHomeInfoRepository(
          {String? statisticType, String? rangeFilter, String? role}) =>
      // change role to admin
      safeApiCallWithError(
          _apiService.getFarmHomeInfo(
              statType: statisticType,
              filterRange: rangeFilter,
              ), (response) {
        return HomeFarmInfoData.fromJson(response);
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error['message']);
      });

  Future<HomeAnimalTableDatabaseModel> getDetailedAnimalInfoRepo(
          {int? page, int? limit, int? animalTypeId, String? range}) =>
      safeApiCallWithError(
          _apiService.getDetailedAnimalInfoService(
              page: page,
              limit: limit,
              animalTypeId: animalTypeId,
              range: range,
              ), (response) {
        return HomeAnimalTableDatabaseModel.fromJson(response);
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error['message']);
      });
}

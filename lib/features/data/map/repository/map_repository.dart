// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_history_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_animal_statistics_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_regions_model.dart';

/// repository get and do call server side request about home screen stuffs
class MapRepository {
  final QazTrackerApiService _apiService;

  MapRepository() : _apiService = locator();

  Future<RegionsData> getRegionsRepo({int? page, int? limit = 100}) =>
      safeApiCallWithError(_apiService.getRegionsList(page, limit), (response) {
        return RegionsData.fromJson(response);
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error['message']);
      });

  Future<MapInfoData> getMapLocationsRepo(
          {int? trackersLimit,
          List<String?> animalTypeIds = const [],
          String? trackerId,
          String? role,
          List<String?>? selectedRegionIds = const [],
          List<String?>? selectedFarmIds = const [],
          
          }) =>
      safeApiCallWithError(
          _apiService.getMapLocations(
              trackersLimit, animalTypeIds, trackerId, regionIds: selectedRegionIds,farmIds: selectedFarmIds), (response) {
        return MapInfoData.fromJson(response);
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error['message']);
      });

  Future<MapAnimalHistoryLocationsModel> getAnimalHistoryOfMoveRepo(
          {int? page, int? limit, int? animalId, String? role}) =>
      safeApiCallWithError(
          _apiService.getAnimalHistoryOfMoveService(
              page: page,
              limit: limit,
              animalId: animalId,
              ), (response) {
        return MapAnimalHistoryLocationsModel.fromJson(response);
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error['message']);
      });

  Future<MapAnimalStatisticInfoModel> getAnimalStatisticsByRangeTimeRepo(
          {String? rangeDate, int? animalId, String? role}) =>
      safeApiCallWithError(
          _apiService.getAnimalStatisticsByRangeTimeService(
              rangeDate: rangeDate,
              animalId: animalId,
              ), (response) {
        return MapAnimalStatisticInfoModel.fromJson(response);
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error['message']);
      });
}

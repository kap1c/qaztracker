// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:core';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:qaz_tracker/features/data/auth/model/auth_user_model.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';
import 'network_call_routes.dart';

class QazTrackerApiService {
  final Future<Dio> _httpClient;
  String? role;
  QazTrackerApiService(this._httpClient, this.role);

  

  Future<Response> login(String? phone, String? password) async {
    final response = await _httpClient;
    return response.post(NetworkApiRoutes.authLogin, data: {
      'phone': '+7$phone',
      'password': password,
    });
  }

  Future<Response> forgotPassword(String? phone, String? password) async {
    final response = await _httpClient;
    return response.post(NetworkApiRoutes.authForgotPassword, data: {
      'phone': phone,
      'password': password,
    });
  }

  /// get all notifications for current user
  Future<Response> getNotificationList({
    int? page,
    int? limit,
    
  }) async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.notificationList(role: role),
        queryParameters: {'page': page, 'limit': limit});
  }

  /// get current user profile detailed information
  Future<Response> getCurrentProfile() async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.getAdminProfile(role: role));
  }

  Future<Response> getFarmCurrentProfile() async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.getFarmProfile(role: role));
  }

  Future<Response> getFarmAnimalTrackers(String uri,
      {Map<String, dynamic>? queryParams = const {}}) async {
    final response = await _httpClient;

    return response.get(
      uri,
      queryParameters: queryParams,

    );
  }

  /// TODO: use this method for updating profile of managers
  Future<Response> updateProfile({
    AppCurrentUserEntity? appCurrentUserData,
  }) async {
    final response = await _httpClient;
    return response.post(NetworkApiRoutes.updateProfile(role: role),
        data: appCurrentUserData?.toJson());
  }

  Future<Response> updateManager(
      {AppCurrentUserEntity? appCurrentUserData,
      required int managerId}) async {
    final response = await _httpClient;
    return response.post(
        NetworkApiRoutes.updateManager(role: role, managerId: managerId),
        data: appCurrentUserData?.toJson());
  }

  /// update Farm current user profile information
  Future<Response> updateFarmProfile({
    AppCurrentUserEntity? appCurrentUserData,
  }) async {
    final response = await _httpClient;
    return response.post(NetworkApiRoutes.updateFarmProfile(role: role),
        data: appCurrentUserData?.toJson());
  }

  Future<Response> updateRegion(
      {required int regionId, String? newRegionName}) {
    return _httpClient.then((value) => value.post(
        NetworkApiRoutes.updateRegion(regionId: regionId, role: role),
        data: {'name': newRegionName}));
  }

  // create new farm
  Future<Response> createFarm(
      {required Map<String, dynamic> requestData, int? farmId}) async {
    final response = await _httpClient;
    return response.post(
      NetworkApiRoutes.createFarm(role: role, id: farmId),
      data: requestData,
    );
  }

  Future<Response> getFarm(
      {required String bin, int? page = 1, int? limit = 100}) async {
    return _httpClient.then((response) =>
        response.get(NetworkApiRoutes.getFarm(
          role: role,
        ), queryParameters: {
          'bin': bin,
          'page': page,
          'limit': limit,
        }));
  }

  Future<Response> createTracker(
      {required Map<String, dynamic> requestData,
      required int farmId,
      int? trackerId}) async {
    final response = await _httpClient;

    return response.post(
        NetworkApiRoutes.createTracker(
          role: role,
          farmId: farmId,
          trackerId: trackerId,
        ),
        data: requestData);
  }

  Future<Response> updateTracker({
    required Map<String, dynamic> requestData,
    required int farmId,
    required int trackerId,
  }) async {
    final response = await _httpClient;
    return response.post(
      NetworkApiRoutes.updateTracker(farmId: farmId, animalId: trackerId,role: role),
      data: requestData,
    );
  }

  Future<Response> deleteTracker({
    required int farmId,
    required int trackerId,
  }) async {
    return _httpClient.then((response) => response.delete(
        NetworkApiRoutes.deleteTracker(farmId: farmId, trackerId: trackerId,role: role),),);
  }

  // create new user
  Future<Response> createNewUser({
    String? createdUserRole,
    String? fio,
    String? phone,
    String? password,
  }) async {
    final response = await _httpClient;
    return response.post(
        NetworkApiRoutes.createNewUser(
          // role: role,
          // userRole: createdUserRole!,
        ),
        data: {
          "fio": fio,
          "phone": phone,
          "password": password,
        });
  }

  Future<Response> createRegion({
    String? regionName,
  }) async {
    final response = await _httpClient;
    return response.post(NetworkApiRoutes.createRegion(role: role),
        data: {'name': regionName});
  }

  Future<Response> getAnimalTypes() async {
    return _httpClient.then((response) =>
        response.get(NetworkApiRoutes.getAnimalTypes(), queryParameters: {}));
  }

  Future<Response> createAnimalBreed({
    String? name,
    int? animalType,
  }) async {
    final response = await _httpClient;
    return response.post(NetworkApiRoutes.createAnimalBreed(role: role),
        data: {'name': name, 'animal_type_id': animalType});
  }

  Future<Response> updateAnimalBreed(
      {String? name, required int breedId, required int? animalTypeId}) async {
    final response = await _httpClient;
    return response.post(
        NetworkApiRoutes.updateAnimalBreed(breedId: breedId, role: "admin"),
        data: {'name': name, "animal_type_id": animalTypeId});
  }

  /// delete current profile
  Future<Response> deleteProfile({
    AppCurrentUserData? appCurrentUserData,
  }) async {
    final response = await _httpClient;
    return response.post(NetworkApiRoutes.deleteProfile(role: role));
  }

  Future<Response> deleteManager({
    required int managerId,
  }) {
    return _httpClient.then((response) =>
        response.delete(NetworkApiRoutes.deleteManager(managerId: managerId)));
  }

  // Future<Response> deleteAnimalTracker({required b}) {}

  Future<Response> deleteAnimalBreed({int? breedId}) {
    return _httpClient.then((response) =>
        response.delete(NetworkApiRoutes.deleteAnimalBreed(breedId: breedId)));
  }

  Future<Response> deleteRegion({int? regionId}) {
    return _httpClient.then((response) =>
        response.delete(NetworkApiRoutes.deleteRegion(regionId: regionId)));
  }

  /// get all home page screen info
  Future<Response> getHomeInfo() async {
    final response = await _httpClient;
    return response
        .get(NetworkApiRoutes.getAdminHomeInfo(role: role), queryParameters: {
      "page": 1,
      "limit": 100,
    });
  }

  Future<Response> getFarmHomeInfo({
    String? statType = 'steps',
    String? filterRange = 'week',
  }) async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.getFarmHomeInfo(role: role),
        queryParameters: {'statistic_type': statType, 'range': filterRange});
  }

  // get information for table
  Future<Response> getTableData({
    required String category,
    int? page,
    Map<String, dynamic> queryParameters = const {},
    int? limit = 100,
  }) async {
    final response = await _httpClient;
    // int? farmId = queryParameters['farm_id'];

    return response.get(
        NetworkApiRoutes.getTableInformation(
          category: category,
          page: page,
          role: role,
        ),
        queryParameters: queryParameters);
  }

  /// set firebase push service to server side
  Future<void> sendFcmToken(String? fcmToken) async {
    final response = await _httpClient;
    if (fcmToken != null) {
      // if (Platform.isAndroid) {
      //   await response.post(NetworkApiRoutes.setAndroidFcmToken + fcmToken);
      // } else {
      await response.post(NetworkApiRoutes.setIosFcmToken + fcmToken);
      // }
    }
  }

  /// get All logs from server for clients
  Future<Response> getAllLogs(
    int? page,
    int? limit,
  ) async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.getLogs(role: role),
        queryParameters: {'page': page, 'limit': limit});
  }

  /// get All regions for trackers and animals where they are exist
  Future<Response> getRegionsList(int? page, int? limit) async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.getListRegions,
        queryParameters: {'page': page, 'limit': limit});
  }

  /// get All cities for trackers and animals where they are exist
  Future<Response> getCitiesList(int? page, int? limit) async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.getListCities,
        queryParameters: {'page': page, 'limit': limit});
  }

  /// get all types of KPC
  Future<Response> getKRSTypes(int? page, int? limit) async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.getKRSTypes,
        queryParameters: {'page': page, 'limit': limit});
  }

  /// get all types of KPC
  Future<Response> getAnimalBreedList(int? page, int? limit) async {
    final response = await _httpClient;
    return response.get(NetworkApiRoutes.getAnimalBreedList,
        queryParameters: {'page': page, 'limit': limit});
  }

  /// get All locations/points with other info
  Future<Response> getMapLocations(
      int? trackersLimit, List<String?> animalTypeIds, String? trackerId,
      {List<String?>? regionIds, List<String?>? farmIds}) async {
    final response = await _httpClient;

    Map<String, dynamic> queryParams = {};

    if (trackersLimit != null && trackersLimit != 0) {
      queryParams['trackers_limit'] = trackersLimit;
    }
    if (animalTypeIds.isNotEmpty) {
      queryParams['animal_type_ids[]'] = animalTypeIds;
    }
    if (trackerId != null && trackerId != '') {
      queryParams['tracker_id'] = trackerId;
    }
    if (regionIds != null && regionIds.isNotEmpty) {
      queryParams['region_ids[]'] = regionIds;
    }
    if (farmIds != null && regionIds!.isNotEmpty) {
      queryParams['farm_ids[]'] = farmIds;
    }

    inspect(queryParams);

    return response.get(NetworkApiRoutes.getMapInfo(role: role),
        queryParameters: queryParams);
  }

  /// get detailed information when we select one of the avaiable animals
  Future<Response> getDetailedAnimalInfoService({
    int? page,
    int? limit,
    int? animalTypeId,
    String? range,
  }) async {
    final response = await _httpClient;

    Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

    if (animalTypeId != null && animalTypeId != 0) {
      queryParams['animal_type_id'] = animalTypeId;
    }
    if (range != null && range != '') {
      queryParams['range'] = range;
    }
    inspect(queryParams);
    return response.get(NetworkApiRoutes.getDetailInfoAnimal(role: role),
        queryParameters: queryParams);
  }

  Future<Response> getAnimalHistoryOfMoveService({
    int? page,
    int? limit,
    int? animalId,
  }) async {
    final response = await _httpClient;

    Map<String, dynamic> queryParams = {'page': page, 'limit': limit};
    return response.get(
        NetworkApiRoutes.getAnimalHistoryOfMove(role: role, animalId: animalId),
        queryParameters: queryParams);
  }

  Future<Response> getAnimalStatisticsByRangeTimeService({
    int? animalId,
    String? rangeDate,
  }) async {
    final response = await _httpClient;

    Map<String, dynamic> queryParams = {'range': rangeDate};
    return response.get(
        NetworkApiRoutes.getAnimalStatisticsByRangeTime(
            role: role, id: animalId),
        queryParameters: queryParams);
  }

  Future<Response> getAllInfo({int? page = 1, int? limit = 10}) async {
    final response = await _httpClient;

    return response.get(NetworkApiRoutes.getAllInfo(), queryParameters: {
      'page': page,
      'limit': limit,
    });
  }
}

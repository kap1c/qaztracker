// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/auth/model/auth_user_model.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';

/// репозиторий [ProfileRepository]
class ProfileRepository {
  final QazTrackerApiService _apiService;

  ProfileRepository() : _apiService = locator();

  Future<AppCurrentUserEntity> getCurrentProfile({String? role}) =>
      safeApiCallWithError(_apiService.getCurrentProfile(),
          (response) {
        if (response != null) {
          return AppCurrentUserEntity.fromDTO(
              AppCurrentUserData.fromJson(response['user']));
              
        } else {
          return AppCurrentUserEntity();
        }
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error);
      });

  Future<AppCurrentUserEntity> updateCurrentProfileInfo(
          AppCurrentUserEntity appCurrentUserData) =>
      safeApiCallWithError(
          _apiService.updateProfile(
              appCurrentUserData: appCurrentUserData,
              ), (response) {
        if (response != null) {
          return AppCurrentUserEntity.fromDTO(
              AppCurrentUserData.fromJson(response['user']));
        } else {
          return AppCurrentUserEntity();
        }
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error);
      });

  Future<AppCurrentUserEntity> updateFarmCurrentProfileInfo(
          AppCurrentUserEntity appCurrentUserData) =>
      safeApiCallWithError(
          _apiService.updateFarmProfile(
              appCurrentUserData: appCurrentUserData,
              ), (response) {
        if (response != null) {
          return AppCurrentUserEntity.fromDTO(
              AppCurrentUserData.fromJson(response['user']));
        } else {
          return AppCurrentUserEntity();
        }
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error);
      });

  Future<AppCurrentUserEntity> getFarmCurrentProfile() =>
      safeApiCallWithError(_apiService.getFarmCurrentProfile(),
          (response) {
        if (response != null) {
          return AppCurrentUserEntity.fromDTO(
              AppCurrentUserData.fromJson(response['user']));
        } else {
          return AppCurrentUserEntity();
        }
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error);
      });
}

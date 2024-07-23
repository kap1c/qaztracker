// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:developer';

import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/auth/model/auth_user_model.dart';

/// репозиторий Ask Doubt

class AuthLoginRepository {
  final QazTrackerApiService _apiService;

  AuthLoginRepository() : _apiService = locator();

  Future<AuthUserData> doLogin({String? phone, String? password}) =>
      safeApiCallWithError(_apiService.login(phone, password), (response) {
        return AuthUserData.fromJson(response);
      }, (error, defaultError, code) {
        inspect(error);
        return HttpExceptionData(status: code, detail: error['message']);
      });

  Future<dynamic> deleteFavoriteQuestion({String? phone, String? password}) =>
      safeApiCallWithError(_apiService.forgotPassword(phone, password),
          (response) {
        return response;
      }, (error, defaultError, code) {
        return HttpExceptionData(status: code, detail: error);
      });
}

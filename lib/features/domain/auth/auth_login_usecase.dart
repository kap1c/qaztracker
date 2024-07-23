// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:developer';

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/auth/model/auth_user_model.dart';
import 'package:qaz_tracker/features/data/auth/repository/auth_repository.dart';

class AuthLoginUseCase
    extends CoreFutureUseCase<AuthLoginParams, AuthLoginResult> {
  final AuthLoginRepository authLoginRepository;
  final GlobalPersonalSecureDataRepository _globalPersonalSecureDataRepository;

  AuthLoginUseCase()
      : authLoginRepository = locator(),
        _globalPersonalSecureDataRepository = locator();

  @override
  Future<AuthLoginResult> execute(param) async {
    final res = await authLoginRepository.doLogin(
        phone: param.phone, password: param.password);
    log(res.authToken);

    if (res.authToken.isNotEmpty) {
      _globalPersonalSecureDataRepository.setAccessToken(res.authToken);
      log(res.user.role!);
      _globalPersonalSecureDataRepository.setUserRole(res.user.role!);
    }
    updateUserRole(res.user.role!, res.user.fio);

    return AuthLoginResult(answer: res);
  }
}

class AuthLoginParams {
  final String? phone;
  final String? password;
  AuthLoginParams({this.phone, this.password});
}

class AuthLoginResult {
  final AuthUserData? answer;
  AuthLoginResult({this.answer});
}

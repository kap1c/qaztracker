// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';

/// выполняет действия при входе в приложение
class GlobalMakeActionInputApplicationUseCase
    extends CoreFutureNoneParamUseCase<GlobalMakeActionInputApplicationResult> {
  final GlobalPersonalSecureDataRepository _globalPersonalSecureDataRepository;

  GlobalMakeActionInputApplicationUseCase()
      : _globalPersonalSecureDataRepository = locator();

  @override
  Future<GlobalMakeActionInputApplicationResult> execute() async {
    /// берем токен если оно есть у юзера/мобилке
    final accessToken = await _globalPersonalSecureDataRepository.accessToken;

    return GlobalMakeActionInputApplicationResult(accessToken: accessToken);
  }
}

/// результат для [GlobalMakeActionInputApplicationUseCase]
class GlobalMakeActionInputApplicationResult {
  final String? accessToken;

  GlobalMakeActionInputApplicationResult({this.accessToken});
}

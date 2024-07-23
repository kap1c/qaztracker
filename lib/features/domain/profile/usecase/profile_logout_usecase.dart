// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';

class ProfileLogoutUseCase extends CoreNoneParamUseCase<void> {
  final GlobalPersonalSecureDataRepository _globalPersonalSecureDataRepository;

  ProfileLogoutUseCase() : _globalPersonalSecureDataRepository = locator();

  @override
  Future<void> execute() async {
    _globalPersonalSecureDataRepository.clearAllUserData();
  }
}

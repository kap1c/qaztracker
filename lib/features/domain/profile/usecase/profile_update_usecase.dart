// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/profile/repository/profile_repository.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';

class ProfileUpdateInfoUseCase extends CoreFutureUseCase<
    ProfileUpdateInfoParams, ProfileUpdateInfoResult> {
  final ProfileRepository profileRepository;

  ProfileUpdateInfoUseCase() : profileRepository = locator();

  @override
  Future<ProfileUpdateInfoResult> execute(ProfileUpdateInfoParams param) async {
    final result = await profileRepository
        .updateCurrentProfileInfo(param.appCurrentUserData!);
    return ProfileUpdateInfoResult(appCurrentUserData: result);
  }
}

class ProfileUpdateInfoResult {
  final AppCurrentUserEntity? appCurrentUserData;
  ProfileUpdateInfoResult({this.appCurrentUserData});
}

class ProfileUpdateInfoParams {
  final AppCurrentUserEntity? appCurrentUserData;
  ProfileUpdateInfoParams({this.appCurrentUserData});
}

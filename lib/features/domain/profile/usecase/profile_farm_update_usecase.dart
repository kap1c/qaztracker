// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/profile/repository/profile_repository.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';

class ProfileFarmUpdateInfoUseCase extends CoreFutureUseCase<
    ProfileFarmUpdateInfoParams, ProfileFarmUpdateInfoResult> {
  final ProfileRepository profileRepository;

  ProfileFarmUpdateInfoUseCase() : profileRepository = locator();

  @override
  Future<ProfileFarmUpdateInfoResult> execute(
      ProfileFarmUpdateInfoParams param) async {
    final result = await profileRepository
        .updateFarmCurrentProfileInfo(param.appCurrentUserData!);
    return ProfileFarmUpdateInfoResult(appCurrentUserData: result);
  }
}

class ProfileFarmUpdateInfoResult {
  final AppCurrentUserEntity? appCurrentUserData;
  ProfileFarmUpdateInfoResult({this.appCurrentUserData});
}

class ProfileFarmUpdateInfoParams {
  final AppCurrentUserEntity? appCurrentUserData;
  ProfileFarmUpdateInfoParams({this.appCurrentUserData});
}

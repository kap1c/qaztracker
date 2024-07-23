// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/domain/abstract/use_case/core_use_case.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/profile/repository/profile_repository.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';

class ProfileFarmGetInfoUseCase
    extends CoreFutureNoneParamUseCase<ProfileFarmGetInfoResult> {
  final ProfileRepository profileRepository;

  ProfileFarmGetInfoUseCase() : profileRepository = locator();

  @override
  Future<ProfileFarmGetInfoResult> execute() async {
    final result = await profileRepository.getFarmCurrentProfile();
    return ProfileFarmGetInfoResult(profile: result);
  }
}

class ProfileFarmGetInfoResult {
  final AppCurrentUserEntity? profile;
  ProfileFarmGetInfoResult({this.profile});
}

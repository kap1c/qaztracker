// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_farm_info_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_farm_update_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_info_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_logout_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_update_usecase.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_state.dart';

/// this cubit class responsible for getting all profile info
class ProfileCubit extends CoreCubit {
  ProfileCubit()
      : profileInfoUseCase = locator(),
        profileUpdateInfoUseCase = locator(),
        profileFarmGetInfoUseCase = locator(),
        profileFarmUpdateInfoUseCase = locator(),
        profileLogoutUseCase = locator(),
        super(ProfileState());
  final ProfileGetInfoUseCase profileInfoUseCase;
  final ProfileUpdateInfoUseCase profileUpdateInfoUseCase;
  final ProfileFarmUpdateInfoUseCase profileFarmUpdateInfoUseCase;
  final ProfileFarmGetInfoUseCase profileFarmGetInfoUseCase;
  final ProfileLogoutUseCase profileLogoutUseCase;
  AppCurrentUserEntity? appCurrentUserData = AppCurrentUserEntity();

  ///get Admin currenut user profile data
  void getProfileInfo() {
    final request = profileInfoUseCase.execute();
    launchWithError<ProfileGetInfoResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          emit(ProfileState(isLoading: true));
        },
        resultData: (result) {
          if (result.profile != null) {
            appCurrentUserData = result.profile;
            emit(ProfileState(appCurrentUserEntity: appCurrentUserData));
          }
        },
        errorData: (error) {
          emit(ProfileState());
          showErrorCallback?.call(error.detail);
        });
  }

  ///get Farm current user profile data
  void getFarmProfileInfo() {
    final request = profileFarmGetInfoUseCase.execute();
    launchWithError<ProfileFarmGetInfoResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          emit(ProfileState(isLoading: true));
        },
        resultData: (result) {
          if (result.profile != null) {
            appCurrentUserData = result.profile;
            emit(ProfileState(appCurrentUserEntity: appCurrentUserData));
          }
        },
        errorData: (error) {
          emit(ProfileState());
          showErrorCallback?.call(error.detail);
        });
  }

  /// update profile data
  void updateProfile() {
    final request = profileUpdateInfoUseCase.execute(
        ProfileUpdateInfoParams(appCurrentUserData: appCurrentUserData));
    launchWithError<ProfileUpdateInfoResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          emit(ProfileState(isLoading: true));
        },
        resultData: (result) {
          if (result.appCurrentUserData != null) {
            appCurrentUserData = result.appCurrentUserData;
            emit(ProfileState(appCurrentUserEntity: appCurrentUserData));
          }
        },
        errorData: (error) {
          emit(ProfileState());
          showErrorCallback?.call(error.detail);
        });
  }

  /// update Farm profile data
  void updateFarmProfile() {
    final request = profileFarmUpdateInfoUseCase.execute(
        ProfileFarmUpdateInfoParams(appCurrentUserData: appCurrentUserData));
    launchWithError<ProfileFarmUpdateInfoResult, HttpExceptionData>(
        request: request,
        loading: (isLoading) {
          emit(ProfileState(isLoading: true));
        },
        resultData: (result) {
          if (result.appCurrentUserData != null) {
            appCurrentUserData = result.appCurrentUserData;
            emit(ProfileState(
                appCurrentUserEntity: appCurrentUserData, isSuccess: true));
          }
        },
        errorData: (error) {
          emit(ProfileState());
          showErrorCallback?.call(error.detail);
        });
  }

  void setFarmName(String? val) {
    appCurrentUserData?.fio = val;
  }

  void setPhone(String? val) {
    appCurrentUserData?.phone = val;
  }

  void setTitleName(String? val) {
    appCurrentUserData?.name = val;
  }

  /// logout user and clear all saved local data from storage
  void logoutApp() {
    profileLogoutUseCase.execute();
  }
}

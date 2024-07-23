// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';

class ProfileState extends CoreState {
  final bool isLoading;
  final AppCurrentUserEntity? appCurrentUserEntity;
  final bool isSuccess;

  ProfileState(
      {this.isLoading = false,
      this.appCurrentUserEntity,
      this.isSuccess = false});

  ProfileState copyWith(
          {bool? isLoading = false,
          bool? isSuccess = false,
          AppCurrentUserEntity? appCurrentUserEntity}) =>
      ProfileState(
          isLoading: isLoading ?? this.isLoading,
          isSuccess: isSuccess ?? this.isSuccess,
          appCurrentUserEntity:
              appCurrentUserEntity ?? this.appCurrentUserEntity);

  @override
  List<Object?> get props => [
        isLoading,
        appCurrentUserEntity,
        isSuccess,
      ];
}

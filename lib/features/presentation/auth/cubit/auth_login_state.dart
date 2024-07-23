// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';

class AuthLoginState extends CoreState {
  final bool isLoading;
  final bool isSuccessfullyLogged;

  AuthLoginState({this.isLoading = false, this.isSuccessfullyLogged = false});

  AuthLoginState copyWith(
          {bool? isLoading = false, bool? isSuccessfullyLogged = false}) =>
      AuthLoginState(
        isLoading: isLoading ?? this.isLoading,
        isSuccessfullyLogged: isSuccessfullyLogged ?? this.isSuccessfullyLogged,
      );

  @override
  List<Object> get props => [isLoading, isSuccessfullyLogged];
}

class AuthFillFieldsState extends CoreState {}

// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/domain/auth/auth_login_usecase.dart';
import 'package:qaz_tracker/features/presentation/auth/cubit/auth_login_state.dart';

/// Кубит отвечает за роботу приложения при старте, то есть если необходимо
/// выполнить какой либо процесс при запуске приложения то необходимо описать тут
class AuthLoginCubit extends CoreCubit {
  AuthLoginCubit()
      : authLoginUseCase = locator(),
        super(AuthLoginState());
  final AuthLoginUseCase authLoginUseCase;

  late String password = CoreConstant.empty;
  late String phone = CoreConstant.empty;

  /// set phone variable from ui
  void setPhone(val) {
    phone = val;
  }

  /// set password variable from ui
  void setPassword(val) {
    password = val;
  }

  void doLogin() {
    if (phone.isNotEmpty && password.isNotEmpty) {
      final request = authLoginUseCase
          .execute(AuthLoginParams(phone: phone, password: password));
      launchWithError<AuthLoginResult, HttpExceptionData>(
          request: request,
          loading: (isLoading) {
            emit(AuthLoginState(isLoading: true));
          },
          resultData: (result) {
            emit(AuthLoginState(isSuccessfullyLogged: true));
          },
          errorData: (error) {
            emit(AuthLoginState());
            // showErrorCallback!.call(error.detail);
          });
    } else {
      emit(null);
      emit(AuthFillFieldsState());
    }
  }
}

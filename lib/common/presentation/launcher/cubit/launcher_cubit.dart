// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:qaz_tracker/common/domain/launcher/usecase/launcher_main_usecase.dart';
import 'package:qaz_tracker/common/presentation/launcher/cubit/launcher_state.dart';
import 'package:qaz_tracker/di/di_locator.dart';

/// Кубит отвечает за роботу приложения при старте, то есть если необходимо
/// выполнить какой либо процесс при запуске приложения то необходимо описать тут
class GlobalLauncherCubit extends CoreCubit {
  GlobalLauncherCubit()
      : _inputApplicationUseCase = locator(),
        super(null);
  final GlobalMakeActionInputApplicationUseCase _inputApplicationUseCase;

  /// запрашивает состояние для  открытия нужного экрана
  Future<void> checkLaunchState() async {
    final action = await _inputApplicationUseCase.execute();

    if (action.accessToken != null) {
      emit(GlobalUserLoggedInState());
      return;
    }
    emit(GlobalUnAuthState());
  }
}

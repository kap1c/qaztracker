// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';

// /// состояние при первичном входе (выбор языка, далее онбординг)
// class GlobalLauncherShowSelectLanguageState extends CoreState {}

/// состояние когда требуеться открыть экран главной страници фин части
class GlobalLauncherShowIndexPageState extends CoreState {
  GlobalLauncherShowIndexPageState(
      {this.accessToken, this.isFirstTimeRegistered, this.isStudent});
  final String? accessToken;
  final bool? isFirstTimeRegistered;
  final bool? isStudent;
}

class GlobalUserLoggedInState extends CoreState {}

class GlobalUnAuthState extends CoreState {}

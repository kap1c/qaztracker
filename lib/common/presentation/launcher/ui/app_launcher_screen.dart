// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/common/presentation/launcher/cubit/launcher_cubit.dart';
import 'package:qaz_tracker/common/presentation/launcher/cubit/launcher_state.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:qaz_tracker/features/presentation/auth/ui/auth_login_screen.dart';
import 'package:qaz_tracker/features/presentation/index_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLauncherScreen extends StatefulWidget {
  const AppLauncherScreen({super.key});

  @override
  State<AppLauncherScreen> createState() => _AppLauncherScreenState();
}

class _AppLauncherScreenState extends State<AppLauncherScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<GlobalLauncherCubit>().checkLaunchState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      CoreUpgradeBlocBuilder<GlobalLauncherCubit, CoreState>(
        buildWhen: (prevState, curState) =>
            curState is GlobalUserLoggedInState ||
            curState is GlobalUnAuthState,
        builder: (context, state) {
          if (state is GlobalUserLoggedInState) {
            return const IndexScreen();
          } else if (state is GlobalUnAuthState) {
            return const AuthLoginScreen();
          }
          return const Scaffold(body: Center(child: AppLoaderWidget()));
        },
      );
}

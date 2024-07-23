// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:qaz_tracker/app.dart';
import 'package:qaz_tracker/config/routes/app_route_list.dart';
import 'package:qaz_tracker/features/presentation/auth/ui/auth_login_screen.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/profile_edit_screen.dart';

class AppRoutesRegister {
  Map<String, WidgetBuilder> registerRoutes() => {
        AppRoutes.loginScreen: (context) => const AuthLoginScreen(),
        AppRoutes.appOnStartScreen: (context) => const QazTrackerApp(),
        AppRoutes.profileEditScreen: (context) => const ProfileEditScreen(),
      };
}

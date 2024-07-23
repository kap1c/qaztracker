// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/presentation/launcher/cubit/launcher_cubit.dart';
import 'package:qaz_tracker/common/presentation/launcher/ui/app_launcher_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaz_tracker/config/routes/app_route_config.dart';
import 'package:sizer/sizer.dart';

class QazTrackerApp extends StatelessWidget {
  const QazTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          BlocProvider(create: (context) => GlobalLauncherCubit()),
        ],
        child: Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
              title: 'QazTracker',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Roboto",),
              home: const AppLauncherScreen(),
              routes: AppRoutesRegister().registerRoutes());
        }));
  }
}

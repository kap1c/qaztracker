import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qaz_tracker/app.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // HttpOverrides.global = MyHttpOverrides();

  /// пока подифолту запускаем проект на ПРОДе
  // await Firebase.initializeApp();
  await setupLocator();
  initializeDateFormatting();

  runApp(const QazTrackerApp());
}
// id46662
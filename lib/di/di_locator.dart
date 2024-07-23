// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/di/core_locator.dart';
import 'package:get_it/get_it.dart';
import 'package:qaz_tracker/common/data/personal/pref/global_user_secure_data_source.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/common/domain/launcher/usecase/launcher_main_usecase.dart';
import 'package:qaz_tracker/config/network/network_clients.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/constants/app_global_consts.dart';
import 'package:qaz_tracker/constants/app_global_prefs_consts.dart';
import 'package:qaz_tracker/features/data/auth/repository/auth_repository.dart';
import 'package:qaz_tracker/features/data/home/repository/home_repository.dart';
import 'package:qaz_tracker/features/data/map/repository/map_repository.dart';
import 'package:qaz_tracker/features/data/notification/repository/notification_repository.dart';
import 'package:qaz_tracker/features/data/profile/repository/profile_repository.dart';
import 'package:qaz_tracker/features/domain/auth/auth_login_usecase.dart';
import 'package:qaz_tracker/features/domain/home/usecase/home_detailed_animal_usecase.dart';
import 'package:qaz_tracker/features/domain/home/usecase/home_farm_usecase.dart';
import 'package:qaz_tracker/features/domain/home/usecase/home_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_animal_move_history_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_animal_statistics_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_points_usecase.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_regions_usecase.dart';
import 'package:qaz_tracker/features/domain/notification/usecase/notification_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_farm_info_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_farm_update_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_info_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_logout_usecase.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_update_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

class User {
  String? name;
  UserRole role;

  User({required this.name, required this.role});
}

enum UserRole { manager, admin, guest }

Future<void> setupLocator() async {
  locator.registerSingleton<User>(
      User(name: "", role: UserRole.manager)); // Set the default user role
  coreModule();
  _commonMainModule();
  _dataSourceModule();
  _apiServiceModule();
  _repositoryModule();
  _useCaseModule();
}

void _commonMainModule() {
  /// для авторизованной зоны
  locator.registerSingletonAsync(
      () => createAuthorizedHttpClient(AppGlobalConsts.baseUrl),
      instanceName: GlobalPrefConstant.authorized);

  /// Shared preferences
  final sharedPreferences = SharedPreferences.getInstance();
  locator.registerSingletonAsync(() => sharedPreferences);
}

void _apiServiceModule() async {
  // /// для авторизованной зоны
  String? userRole = await GlobalPersonalSecureDataRepository().getUserRole();
  String? userName = await GlobalPersonalSecureDataRepository().getUserName();
  locator.unregister<User>(); // Unregister the previous instance

  /// Register the named factory for QazTrackerApiService
  locator.registerFactory<QazTrackerApiService>(() => QazTrackerApiService(
        locator.getAsync(instanceName: GlobalPrefConstant.authorized),
        userRole, // Provide a default value for the user role
      ));

  if (userRole == "admin") {
    locator.registerSingleton<User>( User(name: userName, role : UserRole.admin));
  } else if (userRole == "manager") {
    // locator.registerSingleton<UserRole>(UserRole.manager);
    locator.registerSingleton<User>( User(name: userName, role : UserRole.manager));

  } else {
    locator.registerSingleton<User>( User(name: userName, role : UserRole.guest));

    // locator.registerSingleton<UserRole>(UserRole.guest);
  }
}

void updateUserRole(String userRole, String userName) {
  locator
      .unregister<QazTrackerApiService>(); // Unregister the previous instance
  locator.registerFactory<QazTrackerApiService>(() => QazTrackerApiService(
        locator.getAsync(instanceName: GlobalPrefConstant.authorized),
        userRole,
      ));

  locator.unregister<User>(); // Unregister the previous instance

  if (userRole == "admin") {
    locator.registerSingleton<User>( User(name: userName, role : UserRole.admin));
  } else if (userRole == "manager") {
    locator.registerSingleton<User>( User(name: userName, role : UserRole.manager));
  } else {
    locator.registerSingleton<User>( User(name: userName, role : UserRole.guest));
  }
}

/// для локального хранения данных
void _dataSourceModule() async {
  final sharedPreferences = SharedPreferences.getInstance();
  locator.registerSingleton(GlobalPersonalSecureDataSource(sharedPreferences));
}

/// для репозиторий
void _repositoryModule() {
  ///платежи
  locator.registerFactory(() => GlobalPersonalSecureDataRepository());
  locator.registerFactory(() => AuthLoginRepository());
  locator.registerFactory(() => NotificationRepository());
  locator.registerFactory(() => HomeRepository());
  locator.registerFactory(() => ProfileRepository());
  locator.registerFactory(() => MapRepository());
}

/// для useCase
void _useCaseModule() {
  locator.registerFactory(() => GlobalMakeActionInputApplicationUseCase());
  locator.registerFactory(() => AuthLoginUseCase());
  locator.registerFactory(() => NotificatinoUseCase());
  locator.registerFactory(() => HomeUseCase());
  locator.registerFactory(() => ProfileGetInfoUseCase());
  locator.registerFactory(() => ProfileUpdateInfoUseCase());
  locator.registerFactory(() => HomeFarmUseCase());
  locator.registerFactory(() => ProfileFarmGetInfoUseCase());
  locator.registerFactory(() => ProfileFarmUpdateInfoUseCase());
  locator.registerFactory(() => MapRegionsUseCase());
  locator.registerFactory(() => MapPointsUseCase());
  locator.registerFactory(() => HomeDetailedAnimalUseCase());
  locator.registerFactory(() => ProfileLogoutUseCase());
  locator.registerFactory(() => MapAnimalHistoryMoveCase());
  locator.registerFactory(() => MapAnimalStatisticsUseCase());
}

import 'package:shared_preferences/shared_preferences.dart';

/// данный репозиторий работает записыват в хранилище данные которые
/// необходиты при первичном запуске приложения
class GlobalLauncherDataSource {
  final Future<SharedPreferences> sharedPreferences;

  GlobalLauncherDataSource(this.sharedPreferences);
}

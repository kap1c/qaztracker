import 'package:qaz_tracker/constants/app_global_prefs_consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalPersonalSecureDataSource {
  final Future<SharedPreferences> sharedPreferences;

  GlobalPersonalSecureDataSource(this.sharedPreferences);

  /// получает токен пользователя
  Future<String?> get accessToken async {
    final prefs = await sharedPreferences;
    return prefs.getString(GlobalPrefConstant.accessToken);
  }

  /// записавыет токен пользователя
  void setAccessToken(String accessToken) async {
    final prefs = await sharedPreferences;
    prefs.setString(GlobalPrefConstant.accessToken, accessToken);
  }

  /// удаляет токен пользователя
  void removeAccessToken() async {
    final prefs = await sharedPreferences;

    prefs.remove(GlobalPrefConstant.accessToken);
  }

  void setUserRole(String userRole) async {
    final prefs = await sharedPreferences;
    prefs.setString(GlobalPrefConstant.userRole, userRole);
  }

  Future<String?> getUserRole() async {
    final prefs = await sharedPreferences;
    return prefs.getString(GlobalPrefConstant.userRole);
  }

  void setUserName(String userName) async {
    final prefs = await sharedPreferences;
    prefs.setString(GlobalPrefConstant.userName, userName);
  }

  Future<String?> getUserName() async {
    final prefs = await sharedPreferences;
    return prefs.getString(GlobalPrefConstant.userName);
  }

  /// очищает все данные
  void clearAll() async {
    final prefs = await sharedPreferences;
    prefs.clear();
  }

  /// очищает access и refresh токены
  void clearTokens() async {
    final prefs = await sharedPreferences;
    prefs.remove(GlobalPrefConstant.accessToken);
    // prefs.remove(GlobalPrefConstant.prefRefreshToken);
  }
}

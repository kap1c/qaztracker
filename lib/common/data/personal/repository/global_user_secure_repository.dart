import 'package:qaz_tracker/common/data/personal/pref/global_user_secure_data_source.dart';
import 'package:qaz_tracker/di/di_locator.dart';

class GlobalPersonalSecureDataRepository {
  final GlobalPersonalSecureDataSource _dataSource;

  GlobalPersonalSecureDataRepository() : _dataSource = locator();

  /// получает токен пользователя
  Future<String?> get accessToken => _dataSource.accessToken;

  /// записавыет токен пользователя
  void setAccessToken(String accessToken) =>
      _dataSource.setAccessToken(accessToken);

  /// удаляет токен пользователя
  void removeAccessToken() => _dataSource.removeAccessToken();

  /// удаляет все данные связянные с пользователем
  void clearAllUserData() => _dataSource.clearAll();

  Future<String?> getUserRole() => _dataSource.getUserRole();

  void setUserRole(String userRole) => _dataSource.setUserRole(userRole);

  void setUserName(String userName) => _dataSource.setUserName(userName);

  Future<String?> getUserName() => _dataSource.getUserName();

  /// удаляет авторизационные токены (при логауте очищаются только токены)
  void clearTokens() => _dataSource.clearTokens();
}

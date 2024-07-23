class NetworkApiRoutes {
  
  static const authLogin = 'login';
  static const authForgotPassword = 'auth/forgot/password';
  static notificationList({String? role = 'admin'}) => '/$role/alert';
  static getAdminProfile({String? role = 'admin'}) => '/$role/profile';
  static updateProfile({String? role = 'admin'}) => '/$role/update';
  static deleteProfile({String? role = 'admin'}) => '/$role/destroy';
  static getAdminHomeInfo({String? role = 'admin'}) => '/$role/main';

  static updateManager({String? role = "admin", required int managerId}) =>
      '/$role/manager/$managerId';

  static createFarm({String? role = 'admin', int? id}) {
    if (id != null) {
      return '/$role/farm/$id';
    } else {
      return '/$role/farm';
    }
  }

  static getFarm({String? role = "admin"}) => '$role/farm';
  static createRegion({String? role}) => '$role/region';
  static createAnimalBreed({String? role = "admin"}) => '$role/animal_breed';
  static updateAnimalBreed({required int breedId, String? role}) =>
      '$role/animal_breed/$breedId';
  static deleteTracker(
          {required int farmId,
          required int trackerId,
          String? role = "admin"}) =>
      '$role/farm/animal/$farmId/$trackerId';
  static createTracker({String? role, required int farmId, int? trackerId}) {
    if (trackerId != null) {
      return '$role/farm/animal/$farmId/$trackerId';
    } else {
return    '$role/farm/animal/$farmId';

    }
  }

  static updateTracker(
          {String? role, required int farmId, required int animalId}) =>
      '$role/farm/animal/$farmId/$animalId';

  static createNewUser({String? role = "admin", String userRole = 'manager'}) =>
      '$role/$userRole';
  static deleteManager({String? role = "admin", required int managerId}) =>
      '/$role/manager/$managerId';

  static deleteAnimalBreed({String? role = "admin", int? breedId}) =>
      '/$role/animal_breed/$breedId';

  static deleteRegion({String? role = "admin", int? regionId}) =>
      "/$role/region/$regionId";
  static updateRegion({String? role = "admin", required int regionId}) =>
      '/$role/region/$regionId';

  static getFarmHomeInfo({String? role = 'farm'}) => '/$role/main';
  static getFarmProfile({String? role = 'farm'}) => '/$role/profile';
  static updateFarmProfile({String? role = 'farm'}) => '/$role/update';
  static getMapInfo({String? role = 'farm'}) => '/$role/map';
  static getDetailInfoAnimal({String? role = 'farm'}) => '/$role/schedule';
  static getAnimalHistoryOfMove({String? role = 'admin', int? animalId}) =>
      '$role/farm/animal/tracking/$animalId';
  static getAnimalStatisticsByRangeTime({String? role = 'admin', int? id}) =>
      '$role/farm/animal/statistic/$id/';

  static getAllInfo({String? role = "admin"}) => '/all_info';
  static getAnimalTypes({int? page = 1, int? limit = 10}) =>
      '/animal_type?page=$page&limit=$limit';
  // table entries

  static getTableInformation({
    String? role = "admin",
    required String category,
    // required String search,
    String? range,
    int? page = 1,
    int? limit = 10,
    int? farmId,
  }) {
    if (farmId != null) {
      return '/$role/$category/$farmId?page=$page&limit=$limit';
    } else {
      return '/$role/$category?page=$page&limit=$limit';
    }
  }

  /// firebase services stuffs
  static const setIosFcmToken = '/token/ios/';
  static const setAndroidFcmToken = '/token/android/';

  /// logs from server
  static getLogs({String? role = 'farm'}) => '/$role/log';

  /// list of regions
  static const getListRegions = '/region';

  /// list of cities
  static const getListCities = '/city';

  /// stuffs about KRS and Animal types
  static const getKRSTypes = '/animal_type';
  static const getAnimalBreedList = '/animal_breed';
}

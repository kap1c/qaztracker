import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_cubit.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/add_farm/add_tracking_model.dart';
import 'package:qaz_tracker/features/data/auth/model/manager_model.dart';
import 'package:qaz_tracker/features/data/farm/model/tracking_diagram.dart';
import 'package:qaz_tracker/features/data/farm/model/trackings_model.dart';
import 'package:qaz_tracker/features/data/logs/model/log_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_regions_model.dart';
import 'package:qaz_tracker/features/data/sensors/sensor_mode.dart';

import '../../../../features/data/farm/model/farm_model.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit({
    required this.category,
    this.dataStream,
  })  : _apiService = locator(),
        super(TableState(
          category: category,
        ));

  final String category;
  final QazTrackerApiService _apiService;

  StreamController<List<FarmTracking>>? dataStream;

  void fetchData({int page = 1, Map<String, dynamic> queryParams = const {}}) {
    emit(state.copyWith(isLoading: true));
    if (category == "farm" || category == "manager") {
      if (queryParams["range"] == null) {
        queryParams = {"range": "all"};
      }
      fetchFarms(page: page, queryParams: queryParams);
    } else if (category == "log") {
      fetchLogs(page: page);
    } else if (category == "regions" || category == "breeds") {
      fetchInfo();
    } else if (category == "sensors") {
      fetchSensors(
        category: category,
        queryParams: queryParams,
      );
    } else {
      fetchFarmAnimalTrackings(category: category, page: page);
    }
  }

  void fetchFarms({int page = 1, Map<String, dynamic> queryParams = const {}}) {
    safeApiCallWithError(
        _apiService.getTableData(
          category: category,
          page: page,
          queryParameters: queryParams,
        ), (response) {
      switch (category) {
        case ("farm"):
          List<FarmModel> farmItems = [];
          response["data"].forEach((element) {
            farmItems.add(FarmModel.fromJson(element));
          });
          List<FarmTracking> trackingItems = [];
          response["diagram"].forEach((element) {
            if (element["trackings"] != null) {
              trackingItems
                  .add(FarmTracking.fromJson(element, element.keys.first));
            }
          });
          if (dataStream != null) {
            dataStream!.add(
              trackingItems,
            );
          }

          emit(state.copyWith(
            isLoading: false,
            farmItems: farmItems,
            trackingItems: trackingItems,
            currentPage: response["page"] ?? 1,
            totalItems: response["total"] ?? 0,
            maximumPages: response["pages"] ?? 1,
          ));
          break;
        case "manager":
          List<ManagerModel> managerItems = [];
          response["data"].forEach((element) {
            managerItems.add(ManagerModel.fromJson(element));
          });
          emit(state.copyWith(
            managerItems: managerItems,
            isLoading: false,
            currentPage: response["page"] ?? 1,
            totalItems: response["total"] ?? 0,
            maximumPages: response["pages"] ?? 1,
          ));
      }
    }, (error, defaultError, code) {
      emit(
        state.copyWith(isLoading: false),
      );
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  void fetchInfo() {
    safeApiCallWithError(
        _apiService.getAllInfo(
          limit: 100,
        ), (response) {
      switch (category) {
        case "regions":
          List<RegionItem> regionItems = [];
          response["regions"]["items"].forEach((element) {
            regionItems.add(RegionItem.fromJson(element));
          });
          emit(state.copyWith(
            regionItems: regionItems,
            isLoading: false,
            currentPage: response["page"] ?? 1,
            totalItems: response["total"] ?? 0,
            maximumPages: response["pages"] ?? 1,
          ));
          break;
        case "breeds":
          List<Breed> breedItems = [];
          response["breeds"]["items"].forEach((element) {
            breedItems.add(Breed.fromJson(element));
          });
          emit(state.copyWith(
            breedItems: breedItems,
            isLoading: false,
            currentPage: response["page"] ?? 1,
            totalItems: response["total"] ?? 0,
            maximumPages: response["pages"] ?? 1,
          ));
          break;
      }
    }, (error, defaultError, code) {
      emit(
        state.copyWith(isLoading: false),
      );
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  void fetchLogs({int page = 1, Map<String, dynamic> queryParams = const {}}) {
    safeApiCallWithError(
        _apiService.getAllLogs(
          page,
          100,
        ), (response) {
      List<LogModel> logItems = [];
      response["data"].forEach((element) {
        logItems.add(LogModel.fromJson(element));
      });
      
      emit(state.copyWith(
        logItems: logItems,
        isLoading: false,
        currentPage: response["page"] ?? 1,
        totalItems: response["total"] ?? 0,
        maximumPages: response["pages"] ?? 1,
      ));
    }, (error, defaultError, code) {
      emit(
        state.copyWith(isLoading: false),
      );
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  fetchSensors(
      {required String category,
      int? farmId,
      int page = 1,
      Map<String, dynamic> queryParams = const {}}) {
    emit(state.copyWith(isLoading: true));
    String url;
    String? userRole = _apiService.role;
    if (queryParams["farm_id"] != null) {
      farmId = queryParams["farm_id"];
      url = "$userRole/tracking/$farmId";
    } else {
      url = "$userRole/tracking/?page=$page";
    }
    Map<String, dynamic> _queryParameters = {};
    queryParams.forEach((key, value) {
      _queryParameters.addAll({key: value});
    });

    if (_queryParameters["range"] == null) {
      _queryParameters.addAll(
        {"range": "all"},
      );
    }

    safeApiCallWithError(
        _apiService.getFarmAnimalTrackers(
          url,
          queryParams: _queryParameters,
        ), (response) {
      List<FarmTracking> trackingItems = [];
      response["diagram"].forEach((element) {
        trackingItems.add(FarmTracking.fromJson(
          element,
          "2002-03-04", // dummy data
        ));
      });

      if (dataStream != null) {
        dataStream!.add(trackingItems);
      }

      if (farmId == null) {
        emit(state.copyWith(
          isLoading: false,
          category: "sensors",
          trackingItems: trackingItems,
          currentPage: response["page"] ?? 1,
          totalItems: response["total"] ?? 0,
          maximumPages: response["pages"] ?? 1,
        ));
      } else {
        List<SensorModel> sensorItems = [];
        response["farm"]["trackings"].forEach((element) {
          sensorItems.add(SensorModel.fromJson(
              element, response["farm"]["trackers_count"]));
        });

        emit(state.copyWith(
          category: "sensors",
          sensorItems: sensorItems,
          trackingItems: trackingItems,
          isLoading: false,
          currentPage: response["page"] ?? 1,
          totalItems: response["total"] ?? 0,
          maximumPages: response["pages"] ?? 1,
        ));
      }
    }, (error, defaultError, code) {
      emit(
        state.copyWith(isLoading: false),
      );
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  void fetchFarmAnimalTrackings(
      {required String category,
      int page = 1,
      Map<String, dynamic> queryParams = const {}}) {
    emit(state.copyWith(isLoading: true));
    safeApiCallWithError(
        _apiService.getFarmAnimalTrackers(
          category + "?page=$page",
          queryParams: queryParams,
        ), (response) {
      List<FarmAnimalModel> animalModels = [];
      response["data"].forEach((element) {
        animalModels.add(FarmAnimalModel.fromJson(
          element,
          // element["date"],
        ));
      });
      emit(state.copyWith(
        farmAnimalItems: animalModels,
        isLoading: false,
        currentPage: response["page"] ?? 1,
        totalItems: response["total"] ?? 0,
        maximumPages: response["pages"] ?? 1,
      ));
    }, (error, defaultError, code) {
      emit(
        state.copyWith(isLoading: false),
      );
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  // sorting

  // filtering

  // selected data from the table should be displayed in the chart

  void createUser() {}

  void createBreed() {}
}

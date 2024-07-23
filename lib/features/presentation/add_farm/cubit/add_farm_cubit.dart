// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/common/widgets/app_snackbar_widget.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/add_farm/add_tracking_model.dart';
import 'package:qaz_tracker/features/data/farm/model/farm_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_regions_model.dart';
import 'package:qaz_tracker/features/domain/map/usecase/map_regions_usecase.dart';

part 'add_farm_state.dart';

class AddFarmCubit extends Cubit<AddFarmState> {
  AddFarmCubit()
      : _apiService = locator(),
        mapRegionsUseCase = locator(),
        super(AddFarmState());

  final QazTrackerApiService _apiService;
  final MapRegionsUseCase mapRegionsUseCase;

  FarmModel _farmModel = FarmModel();
  FarmAnimalModel _farmAnimalModel = FarmAnimalModel();
  RegionsData? _regionsData;


  // fetch all regions
  void getAllRegions() {
    emit(state.copyWith(
      isLoading: true,
    ));

    safeApiCallWithError(_apiService.getRegionsList(1, 1000), (response) {
      _regionsData = RegionsData.fromJson(response);
      emit(state.copyWith(
        regionsData: _regionsData,
        isLoading: false,
      ));
    }, (error, defaultError, code) {
      emit(
        state.copyWith(isLoading: false),
      );
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  void initState() {
    getAllRegions();
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setFarmName(String farmName) {
    _farmModel.name = farmName;
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setRegion(int regionId) {
    _farmModel.regionId = regionId;
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setUserName(String userName) {
    _farmModel.fio = userName;
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setBin(int bin) {
    _farmModel.bin = (bin).toString();
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setArea(double area) {
    _farmModel.area = area;
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setPassword(String password) {
    _farmModel.password = password;
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setPhoneNumber(String phoneNumber) {
    _farmModel.phone = phoneNumber;
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setHeadsCount(int? headsCount) {
    _farmModel.headsCount = headsCount ?? 0;
    emit(state.copyWith(farmModel: _farmModel));
  }

  void setTrackerName(String? trackerName) {
    _farmAnimalModel.name = trackerName;
    emit(state.copyWith(farmAnimalModel: _farmAnimalModel));
  }

  void setTrackerWeight(double? weight) {
    _farmAnimalModel.weight = weight ?? 0;
    emit(state.copyWith(farmAnimalModel: _farmAnimalModel));
  }

  void setTrackerId(String? trackerId) {
    _farmAnimalModel.trackerId = trackerId;
    emit(state.copyWith(farmAnimalModel: _farmAnimalModel));
  }

  void setTrackerGender(String? gender) {
    _farmAnimalModel.gender = gender;
    emit(state.copyWith(farmAnimalModel: _farmAnimalModel));
  }

  void setTrackerAge(double? age) {
    _farmAnimalModel.age = age;
    emit(state.copyWith(farmAnimalModel: _farmAnimalModel));
  }

  void setTrackerBreed(int? breedId) {
    _farmAnimalModel.breedId = breedId;
    emit(state.copyWith(farmAnimalModel: _farmAnimalModel));
  }

  void setTrackerAnimalType(
    int? animalTypeId,
  ) {
    _farmAnimalModel.animalTypeId = animalTypeId;
    emit(state.copyWith(farmAnimalModel: _farmAnimalModel));
  }

  void getFarmRequest(PageController pageController) {
    emit(state.copyWith(isLoading: true));
    safeApiCallWithError(_apiService.getFarm(bin: "123"), (response) {
      List<FarmModel> _farmModelList = [];
      response["data"].forEach((e) {
        _farmModelList.add(FarmModel.fromJson(e));
      });

      _farmModel = _farmModelList.first;

      emit(state.copyWith(
        isLoading: false,
        farmCreated: true, // TODO DELETE THIS PART
        farmModel: _farmModel,
        farmAnimalModel: _farmAnimalModel,
      ));

      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      log("current page is ${pageController.page!.toInt()}");

    }, (error, defaultError, code) {
      emit(state.copyWith(isLoading: false));
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  // send request for adding farm
  void addFarmRequest(PageController pageController, BuildContext context) {
    if (state.farmModel!.validate()) {
      emit(state.copyWith(creatingFarm: true));
      // after this request backend returns an id of the current farm
      // if a farm has id, then send update request, if not, create request
      safeApiCallWithError(
          _apiService.createFarm(
            
            requestData: state.farmModel!.toJson(),
            farmId: state.farmModel!.id,
          ), (response) {
        _farmModel.id = response["data"]["id"];
        _farmModel.bin = response["data"]["bin"];
        _farmModel.regionId = response["data"]["region"]["id"];
        _farmModel.regionName = response["data"]["region"]["name"];
        _regionsData!.items
            .firstWhere((element) => element.id == _farmModel.regionId)
            .isSelected = true;
        
        emit(state.copyWith(
          creatingFarm: false,
          farmModel: _farmModel,
          farmAnimalModel: _farmAnimalModel,
          farmCreated: true,
          regionsData: _regionsData,
        ));
        pageController.nextPage(
          duration: Duration(seconds: 1),
          curve: Curves.linear,
        );
      }, (error, defaultError, code) {
        emit(state.copyWith(creatingFarm: false));
        showCustomFlashBar(
            text: error["message"],
            color: AppColors.primaryRedColor,
            context: context);

        return HttpExceptionData(status: code, detail: error['message']);
      });
    } else {
      emit(state.copyWith(creatingFarm: false));
      showCustomFlashBar(
          text: "Заполните все поля",
          color: AppColors.primaryRedColor,
          context: context);
    }
  }

  void fetchAnimalBreedsAndTypes() {
    emit(state.copyWith(isLoading: true));
    safeApiCallWithError(_apiService.getAllInfo(limit: 100), (response) {
      List<Breed> breedItems = [];
      response["breeds"]["items"].forEach((element) {
        breedItems.add(Breed.fromJson(element));
      });

      List<AnimalType> animalTypeItems = [];
      response["animal_types"]["items"].forEach((element) {
        animalTypeItems.add(AnimalType.fromJson(element));
      });

      emit(state.copyWith(
        isLoading: false,
        animalBreeds: breedItems,
        animalTypes: animalTypeItems,
      ));
    }, (error, defaultError, code) {
      emit(state.copyWith(isLoading: false));
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  void setSelectedFarm(FarmAnimalModel model) {
    _farmAnimalModel = model;
    emit(state.copyWith(
      farmAnimalModel: _farmAnimalModel,
    ));
  }

  void addTrackerRequest(
    BuildContext context,
    ValueNotifier<Map<String, dynamic>> fetchTable,
  ) {

    // there we also should have a functionality of updating a tracker
    if (state.farmAnimalModel!.validate()) {
      emit(state.copyWith(isLoading: true));
      safeApiCallWithError(
          _apiService.createTracker(
            requestData: state.farmAnimalModel!.toJson(),
            trackerId: state.farmAnimalModel!.id,
            farmId: state.farmModel!.id!,
          ), (response) {
        fetchTable.value = {};
        // state.fetchTable = ValueNotifier({"page": state.farmAnimalModel});
        emit(state.copyWith(
          isLoading: false,
        ));
        Navigator.of(context).pop();

        showCustomFlashBar(
            text: "Трекер успешно добавлен",
            color: AppColors.primaryGreenColor,
            context: context);
      }, (error, defaultError, code) {
        emit(state.copyWith(isLoading: false));
        showCustomFlashBar(
            text: error["message"],
            color: AppColors.primaryRedColor,
            context: context);

        return HttpExceptionData(status: code, detail: error['message']);
      });
    } else {
      showCustomFlashBar(
          text: "Заполните все поля",
          color: AppColors.primaryRedColor,
          context: context);
    }
  }


  void clearFarmData(){
    _farmModel = FarmModel();
    _farmAnimalModel = FarmAnimalModel();
    emit(state.copyWith(
      farmModel: _farmModel,
      farmAnimalModel: _farmAnimalModel,
    ));
  }
}

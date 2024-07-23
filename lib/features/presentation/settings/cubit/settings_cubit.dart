import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/presentation/settings/model/create_animal_breed_model.dart';
import 'package:qaz_tracker/features/presentation/settings/model/create_manager_mode.dart';
import 'package:qaz_tracker/features/presentation/settings/model/create_region_model.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : _apiService = locator(),
        super(SettingsState());

  QazTrackerApiService _apiService;

  void createUser() {
    if (state.createManagerModel != null) {
      emit(state.copyWith(creatingManagerIndicator: true));
      // _apiService.createFarm(appCurrentUserData: state.createManagerModel).then((value) {
      //   emit(state.copyWith(creatingManagerIndicator: false));
      // });
    }
  }

  void updateUser() {
    if (state.createManagerModel != null) {
      emit(state.copyWith(creatingManagerIndicator: true));
      // _apiService.updateFarmProfile(state.createManagerModel).then((value) {
      //   emit(state.copyWith(creatingManagerIndicator: false));
      // });
    }
  }

  void createRegion() {
    if (state.createRegionModel != null) {
      emit(state.copyWith(creatingRegionIndicator: true));
      _apiService
          .createRegion(
        regionName: state.createRegionModel!.name,
      )
          .then((value) {
        emit(state.copyWith(creatingRegionIndicator: false));
      });
    }
  }

  void createAnimalBreed() {
    if (state.createAnimalBreedModel != null) {
      emit(state.copyWith(creatingAnimalBreedIndicator: true));
      _apiService
          .createAnimalBreed(
        name: state.createAnimalBreedModel!.name,
        animalType: state.createAnimalBreedModel!.animalTypeId,
      )
          .then((value) {
        emit(state.copyWith(creatingAnimalBreedIndicator: false));
      });
    }
  }
}

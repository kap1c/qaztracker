part of 'settings_cubit.dart';

class SettingsState extends CoreState {
  SettingsState({
    this.createManagerModel,
    this.createRegionModel,
    this.createAnimalBreedModel,
    this.creatingManagerIndicator,
    this.creatingRegionIndicator,
    this.creatingAnimalBreedIndicator,
  });

  CreateManagerModel? createManagerModel;
  CreateRegionModel? createRegionModel;
  CreateAnimalBreedModel? createAnimalBreedModel;

  bool? creatingManagerIndicator;
  bool? creatingRegionIndicator;
  bool? creatingAnimalBreedIndicator;

  SettingsState copyWith(
    {
      CreateManagerModel? createManagerModel,
      CreateRegionModel? createRegionModel,
      CreateAnimalBreedModel? createAnimalBreedModel,
      bool? creatingManagerIndicator,
      bool? creatingRegionIndicator,
      bool? creatingAnimalBreedIndicator,
    }
  ) => SettingsState(
    createManagerModel: createManagerModel ?? this.createManagerModel,
    createRegionModel: createRegionModel ?? this.createRegionModel,
    createAnimalBreedModel: createAnimalBreedModel ?? this.createAnimalBreedModel,
    creatingManagerIndicator: creatingManagerIndicator ?? this.creatingManagerIndicator,
    creatingRegionIndicator: creatingRegionIndicator ?? this.creatingRegionIndicator,
    creatingAnimalBreedIndicator: creatingAnimalBreedIndicator ?? this.creatingAnimalBreedIndicator,
  );

  @override
  List<Object> get props => [
        createManagerModel!,
        createRegionModel!,
        createAnimalBreedModel!,
        creatingManagerIndicator!,
        creatingRegionIndicator!,
        creatingAnimalBreedIndicator!,
      ];
}

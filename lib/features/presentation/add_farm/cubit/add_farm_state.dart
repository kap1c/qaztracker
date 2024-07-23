part of 'add_farm_cubit.dart';

class AddFarmState extends CoreState {
  AddFarmState({
    this.regionsData,
    this.farmCreated = false,
    this.farmModel,
    this.farmAnimalModel,
    this.isLoading,
    this.selectedRegionId,
    this.animalBreeds = const [],
    this.animalTypes = const [],
    // this.isMale = false,
    this.creatingFarm = false,
  });

  bool? isLoading;
  bool? creatingFarm;
  FarmModel? farmModel;
  RegionsData? regionsData;

  List<Breed> animalBreeds;
  List<AnimalType> animalTypes;

  FarmAnimalModel? farmAnimalModel;
  // ValueNotifier<Map<String, dynamic>>? fetchTable;

  int? selectedRegionId;
  bool? farmCreated;
  bool? isMale;

  AddFarmState copyWith({
    FarmModel? farmModel,
    RegionsData? regionsData,
    FarmAnimalModel? farmAnimalModel,
    bool? isLoading,
    int? selectedRegionId,
    bool? farmCreated,
    int? createdFarmId,
    List<AnimalType>? animalTypes,
    List<Breed>? animalBreeds,
    ValueNotifier<Map<String, dynamic>>? fetchTable,
    bool? isMale,
    bool? creatingFarm,
  }) {
    return AddFarmState(
      farmModel: farmModel ?? this.farmModel,
      regionsData: regionsData ?? this.regionsData,
      isLoading: isLoading ?? this.isLoading,
      farmCreated: farmCreated ?? this.farmCreated,
      farmAnimalModel: farmAnimalModel ?? this.farmAnimalModel,
      selectedRegionId: selectedRegionId ?? this.selectedRegionId,
      animalBreeds: animalBreeds ?? this.animalBreeds,
      animalTypes: animalTypes ?? this.animalTypes,
      // isMale: isMale ?? this.isMale,
      creatingFarm: creatingFarm ?? this.creatingFarm,
      // fetchTable: fetchTable ?? this.fetchTable,
    );
  }

  @override
  List<Object?> get props => [
        farmModel,
        animalBreeds,
        animalTypes,
        farmAnimalModel,
        selectedRegionId,
        isLoading,
        // isMale,
        creatingFarm,
        regionsData,
        // fetchTable,
      ];
}

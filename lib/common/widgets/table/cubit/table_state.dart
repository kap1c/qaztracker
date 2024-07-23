part of 'table_cubit.dart';

class TableState extends CoreState {
  TableState({
    required this.category,
    this.farmItems,
    this.trackingItems,
    this.logItems,
    this.regionItems,
    this.sensorItems,
    this.breedItems,
    this.farmAnimalItems,
    this.isLoading = false,
    this.currentPage = 1,
    this.maximumPages,
    this.totalItems,
    this.managerItems,
  });

  int? currentPage;
  int? maximumPages;
  int? totalItems;
  bool isLoading;

  // they can be logs, database, sensors etc
  List<FarmModel>? farmItems = [];
  List<FarmTracking>? trackingItems = [];
  List<LogModel>? logItems = [];
  List<RegionItem>? regionItems = [];
  List<Breed>? breedItems = [];
  List<ManagerModel>? managerItems = [];
  List<FarmAnimalModel>? farmAnimalItems = [];
  List<SensorModel>? sensorItems = [];
  List<dynamic>? selectedTableItems;
  Map<String, String>? translation;

  String category;

  // TODO: FIX THIS PART
  List<dynamic>? get tableItems {
    if (sensorItems != null &&
        sensorItems!.isNotEmpty &&
        category == "sensors") {
      return sensorItems;
    } else if (farmItems != null &&
        farmItems!.isNotEmpty &&
        category == "farm") {
      return farmItems;
    } else if (trackingItems != null &&
        trackingItems!.isNotEmpty &&
        category != "sensors" && category != "farm") {
      return trackingItems;
    } else if (logItems != null && logItems!.isNotEmpty && category == "log") {
      return logItems;
    } else if (regionItems != null &&
        regionItems!.isNotEmpty &&
        category == "regions") {
      return regionItems;
    } else if (breedItems != null && breedItems!.isNotEmpty) {
      return breedItems;
    } else if (managerItems != null && managerItems!.isNotEmpty) {
      return managerItems;
    } else if (farmAnimalItems != null && farmAnimalItems!.isNotEmpty) {
      return farmAnimalItems;
    } else {
      return null;
    }
  }

  TableState copyWith({
    int? currentPage,
    int? maximumPages,
    int? totalItems,
    List<FarmModel>? farmItems = const [],
    List<FarmTracking>? trackingItems = const [],
    List<LogModel>? logItems = const [],
    List<RegionItem>? regionItems = const [],
    List<Breed>? breedItems = const [],
    List<ManagerModel>? managerItems = const [],
    List<FarmAnimalModel>? farmAnimalItems = const [],
    List<SensorModel>? sensorItems = const [],
    String? category,
    bool? isLoading,
    Map<String, String>? translation,
  }) {
    return TableState(
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
      farmItems: farmItems ?? this.farmItems,
      trackingItems: trackingItems ?? this.trackingItems,
      logItems: logItems ?? this.logItems,
      regionItems: regionItems ?? this.regionItems,
      breedItems: breedItems ?? this.breedItems,
      managerItems: managerItems ?? this.managerItems,
      farmAnimalItems: farmAnimalItems ?? this.farmAnimalItems,
      sensorItems: sensorItems ?? this.sensorItems,
      currentPage: currentPage ?? this.currentPage,
      maximumPages: maximumPages ?? this.maximumPages,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  @override
  List<Object?> get props => [
        currentPage!,
        tableItems,
        category,
        isLoading,
      ];
}

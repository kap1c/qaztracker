part of 'filter_cubit.dart';

class FilterState extends CoreState {
  FilterState({
    this.searchCategory,
    this.allFarms,
    this.selectedFarmIds = const <int>{},
    this.isLoading = true,
    this.animalMapType = const <int>{},
    this.regionsDataList,
    this.selectedRegionList,
    this.mapFilterIdTracker,
    this.mapInfoData,
    this.trackersLimit = 1000,
    this.getMapAnimalCategories,
    this.BIN,
    this.farmDataList,
    this.loadingRegions = false,
    this.loadingFarms = false,
    this.batteryLowerBound = 0,
    this.batteryUpperBound = 100,
    this.signalLowerBound = 0,
    this.signalUpperBound = 100,
    this.selectedRegionIds = const <int>{},
    this.farmIdToFetchTrackings,
    this.trackerLowerBound = 0,
    this.trackerUpperBound = 1000,
    this.dateRange = const [
      {"all": "За все время"},
      {"week": "За неделю"},
      {"month": "За месяц"},
    ],
    this.selectedDateRange = const {"all": "За все время"},
  });

  final String? searchCategory;
  final RegionsData? regionsDataList;
  Set<int>? selectedRegionIds;
  Set<int>? animalMapType;
  Set<int>? selectedFarmIds;
  final List<Map<String, String>> dateRange;
  final Map<String, String> selectedDateRange;
  final bool? isLoading;

  final bool? loadingRegions;
  final bool? loadingFarms;

  final String? selectedRegionList;
  final String? mapFilterIdTracker;
  final List<FarmData>? farmDataList;
  final MapInfoData? mapInfoData;

  final int? trackersLimit;
  final List<MapDataClass>? getMapAnimalCategories;

  // all farms
  final List<FarmModel>? allFarms;

  int? batteryUpperBound;
  int? batteryLowerBound;

  int? signalLowerBound;
  int? signalUpperBound;

  int? farmIdToFetchTrackings;
  int? trackerLowerBound;
  int? trackerUpperBound;
  //

  int? BIN;

  Map<String, dynamic> toQuery() {
    final Map<String, dynamic> query = {};

    query.addAll({
      if (searchCategory != null) "search": searchCategory,
      if (selectedRegionList != null && selectedRegionList!.isNotEmpty)
        "region_ids": selectedRegionList,
      if (animalMapType != null && animalMapType!.isNotEmpty)
        "animal_type_ids[]": animalMapType!.map((e) => e.toString()).toList(),
      if (mapFilterIdTracker != null && mapFilterIdTracker!.isNotEmpty)
        "tracker_id": mapFilterIdTracker,
      if (trackerUpperBound != null) "trackers_limit": trackerUpperBound,
      if (selectedFarmIds != null && selectedFarmIds!.isNotEmpty)
        "farm_ids[]": selectedFarmIds!.map((id) => id.toString()).toList(),
      if (BIN != null && BIN != 0) "bin": BIN,
      if (batteryLowerBound != null && batteryLowerBound != 0)
        "battery_from": batteryLowerBound,
      if (batteryUpperBound != null && batteryUpperBound != 100)
        "battery_to": batteryUpperBound,
      if (signalLowerBound != null && signalLowerBound != 0)
        "network_from": signalLowerBound,
      if (signalUpperBound != null && signalUpperBound != 100)
        "network_to": signalUpperBound,
      if (selectedRegionIds != null && selectedRegionIds!.isNotEmpty)
        "region_ids[]": selectedRegionIds!.map((id) => id.toString()).toList(),
      if (farmIdToFetchTrackings != null && farmIdToFetchTrackings != 0)
        "farm_id": farmIdToFetchTrackings, // I have a mistake here
      if (selectedDateRange != null && selectedDateRange.isNotEmpty)
        "range": selectedDateRange.keys.first,
    });

    return query;
  }

  FilterState copyWith({
    bool? isLoading = false,
    String? searchCategory,
    Set<int>? animalMapType,
    RegionsData? regionsDataList,
    String? selectedRegionList,
    String? mapFilterIdTracker,
    MapInfoData? mapInfoData,
    int? trackersLimit,
    Set<int>? selectedFarmIds,
    Set<int>? selectedRegionIds,
    List<MapDataClass>? getMapAnimalCategories,
    Map<String, String>? selectedDateRange,
    int? BIN,
    List<FarmData>? farmDataList,
    bool? loadingRegions,
    bool? loadingFarms,
    int? batteryLowerBound,
    int? batteryUpperBound,
    int? signalLowerBound,
    int? signalUpperBound,
    int? farmIdToFetchTrackings,
    int? trackerLowerBound,
    int? trackerUpperBound,
  }) {
    return FilterState(
      isLoading: isLoading ?? this.isLoading,
      searchCategory: searchCategory ?? this.searchCategory,
      animalMapType: animalMapType ?? this.animalMapType,
      regionsDataList: regionsDataList ?? this.regionsDataList,
      selectedRegionList: selectedRegionList ?? this.selectedRegionList,
      mapFilterIdTracker: mapFilterIdTracker ?? this.mapFilterIdTracker,
      mapInfoData: mapInfoData ?? this.mapInfoData,
      trackersLimit: trackersLimit ?? this.trackersLimit,
      getMapAnimalCategories:
          getMapAnimalCategories ?? this.getMapAnimalCategories,
      BIN: BIN ?? this.BIN,
      selectedFarmIds: selectedFarmIds ?? this.selectedFarmIds,
      selectedRegionIds: selectedRegionIds ?? this.selectedRegionIds,
      farmDataList: farmDataList ?? this.farmDataList,
      loadingRegions: loadingRegions ?? this.loadingRegions,
      loadingFarms: loadingFarms ?? this.loadingFarms,
      batteryLowerBound: batteryLowerBound ?? this.batteryLowerBound,
      batteryUpperBound: batteryUpperBound ?? this.batteryUpperBound,
      signalLowerBound: signalLowerBound ?? this.signalLowerBound,
      signalUpperBound: signalUpperBound ?? this.signalUpperBound,
      trackerUpperBound: trackerUpperBound ?? this.trackerUpperBound,
      farmIdToFetchTrackings:
          farmIdToFetchTrackings ?? this.farmIdToFetchTrackings,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        animalMapType,
        regionsDataList,
        mapFilterIdTracker,
        mapInfoData,
        trackersLimit,
        getMapAnimalCategories,
        BIN,
        farmDataList,
        selectedRegionList,
        selectedFarmIds,
        loadingRegions,
        loadingFarms,
        batteryLowerBound,
        batteryUpperBound,
        trackerUpperBound,
        trackerLowerBound,
        selectedRegionIds,
        farmIdToFetchTrackings,
        selectedDateRange,
      ];
}

class FarmData {
  String? name;
  int? id;
  bool? isSelected;
  FarmData({required this.name, required this.id, this.isSelected = false});

  factory FarmData.fromJson(Map<String, dynamic> json) => FarmData(
        name: json["name"] ?? "",
        id: json["id"] ?? 0,
        isSelected: false,
      );
}

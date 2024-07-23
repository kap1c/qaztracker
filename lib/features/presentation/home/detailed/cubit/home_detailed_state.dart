// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/features/data/home/model/home_animal_database_model.dart';

class HomeDetailState extends CoreState {
  final bool isLoading;
  final bool isSuccessfullyLogged;
  final String? homeTypeFilter;
  final String? filterRange;
  final HomeAnimalTableDatabaseModel? detailedAnimalInfoData;

  HomeDetailState(
      {this.isLoading = false,
      this.isSuccessfullyLogged = false,
      this.homeTypeFilter,
      this.filterRange,
      this.detailedAnimalInfoData});

  HomeDetailState copyWith(
          {bool? isLoading = false,
          bool? isSuccessfullyLogged = false,
          String? homeTypeFilter = 'steps',
          String? filterRange = 'week',
          HomeAnimalTableDatabaseModel? detailedAnimalInfoData}) =>
      HomeDetailState(
          isLoading: isLoading ?? this.isLoading,
          filterRange: filterRange ?? this.filterRange,
          homeTypeFilter: homeTypeFilter ?? this.homeTypeFilter,
          detailedAnimalInfoData:
              detailedAnimalInfoData ?? this.detailedAnimalInfoData,
          isSuccessfullyLogged:
              isSuccessfullyLogged ?? this.isSuccessfullyLogged);

  @override
  List<Object?> get props => [
        isLoading,
        isSuccessfullyLogged,
        homeTypeFilter,
        filterRange,
        detailedAnimalInfoData
      ];
}

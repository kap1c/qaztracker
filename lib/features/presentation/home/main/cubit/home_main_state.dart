// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/features/data/home/model/home_farm_info_model.dart';
import 'package:qaz_tracker/features/data/home/model/home_info_model.dart';

class HomeState extends CoreState {
  final bool isLoading;
  final bool isBottomLoading;
  final bool isSuccessfullyLogged;
  final HomeInfoData? homeInfoData;
  final HomeFarmInfoData? homeFarmInfoData;

  HomeState({
    this.isLoading = false,
    this.isBottomLoading = false,
    this.isSuccessfullyLogged = false,
    this.homeFarmInfoData,
    // this.homeTypeFilter,
    this.homeInfoData,
  });

  HomeState copyWith(
          {bool? isLoading = false,
          bool? isSuccessfullyLogged = false,
          bool? isBottomLoading = false,
          HomeInfoData? homeInfoData,
          String? homeTypeFilter = 'steps',
          String? filterRange = 'week',
          HomeFarmInfoData? homeFarmInfoData}) =>
      HomeState(
          isLoading: isLoading ?? this.isLoading,
          isBottomLoading: isBottomLoading ?? this.isBottomLoading,
          // filterRange: filterRange ?? this.filterRange,
          // homeTypeFilter: homeTypeFilter ?? this.homeTypeFilter,
          homeInfoData: homeInfoData ?? this.homeInfoData,
          homeFarmInfoData: homeFarmInfoData ?? this.homeFarmInfoData,
          isSuccessfullyLogged:
              isSuccessfullyLogged ?? this.isSuccessfullyLogged);

  @override
  List<Object?> get props => [
        isLoading,
        isSuccessfullyLogged,
        homeInfoData,
        homeFarmInfoData,
        // homeTypeFilter,
        // filterRange,
        isBottomLoading
      ];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:qaz_tracker/common/widgets/filter/cubit/filter_cubit.dart';
import 'package:qaz_tracker/features/presentation/add_farm/cubit/add_farm_cubit.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_cubit.dart';

enum TabScreen {
  home,
  farm,
  sensors,
  database,
  settings,
  logs,
  addFarm,
}

class NavigationCubit extends Cubit<TabScreen> {
  final FilterCubit _filterCubit;
  final AddFarmCubit _addFarmCubit;
  final ProfileCubit _profileCubit;
  int _currentIndex = 0;
  int _previousIndex = 0;

  NavigationCubit({
    required FilterCubit filterCubit,
    required AddFarmCubit addFarmCubit,
    required ProfileCubit profileCubit,
  })  : _filterCubit = filterCubit,
        _addFarmCubit = addFarmCubit,
        _profileCubit = profileCubit,
        super(TabScreen.home);

  void navigateToScreen(int index) {
    _previousIndex = _currentIndex;

    _filterCubit.clearFilter(); // Reset filter cubit if needed

    switch (index) {
      case 1:
        _filterCubit.getAllFilterInfo();
        _filterCubit.getAllFarms();
        _filterCubit.getAllRegions();
        emit(TabScreen.farm);
        break;
      case 2:
        _filterCubit.getAllFilterInfo();
        _filterCubit.getAllFarms();
        _filterCubit.getAllRegions();
        emit(TabScreen.sensors);
        break;
      case 3:
        _filterCubit.getAllFilterInfo();

        _filterCubit.getAllFarms();
        _filterCubit.getAllRegions();
        emit(TabScreen.database);
        break;
      case 4:
        _filterCubit.getAllFilterInfo();

        _filterCubit.getAllFarms();
        _filterCubit.getAllRegions();
        emit(TabScreen.settings);
        break;
      case 5:
        _filterCubit.getAllFilterInfo();

        _filterCubit.getAllFarms();
        _filterCubit.getAllRegions();
        emit(TabScreen.logs);
        break;
      case 6:
        _filterCubit.getAllFilterInfo();

        _filterCubit.getAllFarms();
        _filterCubit.getAllRegions();
        emit(TabScreen.addFarm);
        break;
      default:
        _filterCubit.getAllFilterInfo();
        _filterCubit.getAllFarms();
        _filterCubit.getAllRegions();
        // _profileCubit.clearFilter(); // Reset profile cubit if needed
        emit(TabScreen.home);
        break;
    }
    _currentIndex = index;
  }

  void navigateToPreviousScreen() {
    navigateToScreen(_previousIndex);
  }
}

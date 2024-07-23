// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/app.dart';
import 'package:qaz_tracker/common/widgets/app_appbar_widget.dart';
import 'package:qaz_tracker/common/widgets/filter/cubit/filter_cubit.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/domain/profile/usecase/profile_logout_usecase.dart';
import 'package:qaz_tracker/features/presentation/add_farm/cubit/add_farm_cubit.dart';
import 'package:qaz_tracker/features/presentation/add_farm/ui/add_farm_screen.dart';
import 'package:qaz_tracker/features/presentation/cubit/navigation_cubit.dart';
import 'package:qaz_tracker/features/presentation/database/ui/database_screen.dart';
import 'package:qaz_tracker/features/presentation/farm/ui/farm_screen.dart';
import 'package:qaz_tracker/features/presentation/home/main/cubit/home_main_cubit.dart';
import 'package:qaz_tracker/features/presentation/home/main/ui/home_main_screen.dart';
import 'package:qaz_tracker/features/presentation/logs/ui/logs_screen.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_cubit.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/widgets/profile_exit_dialog_widget.dart';
import 'package:qaz_tracker/features/presentation/sensors/ui/sensors_screen.dart';
import 'package:qaz_tracker/features/presentation/settings/ui/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// main index route screen which controls all pages
class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  // ignore: unused_field
  int _currentIndex = 0;
  late HomeCubit _homeCubit;
  late ProfileCubit _profileCubit;
  late AddFarmCubit _addFarmCubit;
  late FilterCubit _filterCubit;
  late NavigationCubit _navigationCubit;
  AppBar? globalAppBar;
  ValueNotifier<bool> hideControlPanel = ValueNotifier<bool>(false);
  // late UserRole userRole;
  late User user;
  @override
  void initState() {
    hideControlPanel.addListener(() {
      setState(() {});
    });

    _homeCubit = HomeCubit();
    _profileCubit = ProfileCubit();
    _addFarmCubit = AddFarmCubit();
    _filterCubit = FilterCubit();
    _navigationCubit = NavigationCubit(
      filterCubit: _filterCubit,
      addFarmCubit: _addFarmCubit,
      profileCubit: _profileCubit,
    );

    _filterCubit.getAllFilterInfo();

    _filterCubit.getAllFarms();

    _filterCubit.getAllRegions();

    _profileCubit.getFarmProfileInfo();

    _addFarmCubit.initState();
    user = locator<User>();
    hideControlPanel.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  TextStyle unselectedStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle selectedStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0XFF3772FF),
  );

  Color selectedColor = const Color(0XFF3772FF);
  Color unselectedColor = const Color(0XFF1C202C);
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => _navigationCubit,
      child: BlocBuilder<NavigationCubit, TabScreen>(
          builder: (context, tabScreen) {
        return Scaffold(
          appBar: getGlobalAppBar(
            hideControlPanel: hideControlPanel,
            context: context,
            user:user,
            onTap: () {
              setState(() {
                context.read<NavigationCubit>().navigateToScreen(6);
              });
              setState(() {
                _currentIndex = 6;
              });
            },
          ),
          body: Row(
            children: [
              sliderPanel(context, _navigationCubit, tabScreen),
              Expanded(
                child: PageView(
                  children: [
                    _buildTabScreen(tabScreen),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Container sliderPanel(BuildContext context, NavigationCubit navigationCubit,
      TabScreen tabScreen) {
    return Container(
      width: hideControlPanel.value == true
          ? MediaQuery.of(context).size.width * 0.05
          : MediaQuery.of(context).size.width * 0.15,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0XFFE8E9EE)),
          right: BorderSide(color: Color(0XFFE8E9EE)),
          bottom: BorderSide(color: Color(0XFFE8E9EE)),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: tabScreen == TabScreen.home
                  ? const Color.fromARGB(25, 55, 114, 255)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                hideControlPanel.value == true ? "" : 'Главная страница',
                style: tabScreen == TabScreen.home
                    ? selectedStyle
                    : unselectedStyle,
              ),
              leading: Icon(
                Icons.speed,
                color: tabScreen == TabScreen.home
                    ? selectedColor
                    : unselectedColor,
              ),
              onTap: () {
                setState(() {
                  context.read<NavigationCubit>().navigateToScreen(0);
                });
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: tabScreen == TabScreen.farm
                  ? const Color.fromARGB(25, 55, 114, 255)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                hideControlPanel.value == true ? "" : 'Фермы',
                style: tabScreen == TabScreen.farm
                    ? selectedStyle
                    : unselectedStyle,
              ),
              leading: Icon(
                Icons.agriculture_outlined,
                color: tabScreen == TabScreen.farm
                    ? selectedColor
                    : unselectedColor,
              ),
              onTap: () {
                setState(() {
                  context.read<NavigationCubit>().navigateToScreen(1);
                });
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: tabScreen == TabScreen.sensors
                  ? const Color.fromARGB(25, 55, 114, 255)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                hideControlPanel.value == true ? "" : 'Трекеры',
                style: tabScreen == TabScreen.sensors
                    ? selectedStyle
                    : unselectedStyle,
              ),
              leading: Icon(
                Icons.cast,
                color: tabScreen == TabScreen.sensors
                    ? selectedColor
                    : unselectedColor,
              ),
              onTap: () {
                setState(() {
                  context.read<NavigationCubit>().navigateToScreen(2);
                });
              },
            ),
          ),
          user.role == UserRole.admin
              ? Container(
                  decoration: BoxDecoration(
                    color: tabScreen == TabScreen.database
                        ? const Color.fromARGB(25, 55, 114, 255)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      hideControlPanel.value == true ? "" : 'БД',
                      style: tabScreen == TabScreen.database
                          ? selectedStyle
                          : unselectedStyle,
                    ),
                    leading: Icon(
                      Icons.dns_outlined,
                      color: tabScreen == TabScreen.database
                          ? selectedColor
                          : unselectedColor,
                    ),
                    onTap: () {
                      setState(() {
                        context.read<NavigationCubit>().navigateToScreen(3);
                      });
                    },
                  ),
                )
              : const SizedBox(),
          user.role == UserRole.admin
              ? Container(
                  decoration: BoxDecoration(
                    color: tabScreen == TabScreen.settings
                        ? const Color.fromARGB(25, 55, 114, 255)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      hideControlPanel.value == true ? "" : 'Настройки',
                      style: tabScreen == TabScreen.settings
                          ? selectedStyle
                          : unselectedStyle,
                    ),
                    leading: Icon(
                      Icons.settings_outlined,
                      color: tabScreen == TabScreen.settings
                          ? selectedColor
                          : unselectedColor,
                    ),
                    onTap: () {
                      setState(() {
                        context.read<NavigationCubit>().navigateToScreen(4);
                      });
                    },
                  ),
                )
              : const SizedBox(),
          user.role == UserRole.admin
              ? Container(
                  decoration: BoxDecoration(
                    color: tabScreen == TabScreen.logs
                        ? const Color.fromARGB(25, 55, 114, 255)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      hideControlPanel.value == true ? "" : 'События',
                      style: tabScreen == TabScreen.logs
                          ? selectedStyle
                          : unselectedStyle,
                    ),
                    leading: Icon(
                      Icons.history,
                      color: tabScreen == TabScreen.logs
                          ? selectedColor
                          : unselectedColor,
                    ),
                    onTap: () {
                      setState(() {
                        context.read<NavigationCubit>().navigateToScreen(5);
                      });
                    },
                  ),
                )
              : const SizedBox(),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                hideControlPanel.value == true ? "" : 'Выйти',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.primaryRedColor,
                ),
              ),
              leading: const Icon(
                Icons.logout,
                color: AppColors.primaryRedColor,
              ),
              onTap: () {
                showExitCupertinoDialog(
                    context: context,
                    title: "Выход",
                    description: "Вы уверены что хотите выйти?",
                    actionText: "Подтвердить",
                    onExit: () {
                      ProfileLogoutUseCase().execute().then((value) {
                        Navigator.of(context, rootNavigator: true).pop();

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QazTrackerApp()),
                            (route) => true);
                      });
                    });
              },
            ),
          )
        ],
      ),
    );
  }

  // Widget _onTabIndexWidget(int index) {
  //   if (index == 1) {
  //     return MultiBlocProvider(
  //       providers: [
  //         // BlocProvider.value(value: _addFarmCubit),
  //         BlocProvider.value(value: _filterCubit),
  //       ],
  //       child: FarmScreen(),
  //     );
  //   } else if (index == 2) {
  //     return MultiBlocProvider(
  //       providers: [
  //         // BlocProvider.value(value: _addFarmCubit),
  //         BlocProvider.value(value: _filterCubit),
  //       ],
  //       child: SensorsScreen(),
  //     );
  //   } else if (index == 3) {
  //     return MultiBlocProvider(
  //       providers: [
  //         // BlocProvider.value(value: _addFarmCubit),
  //         BlocProvider.value(value: _filterCubit),
  //       ],
  //       child: DatabaseScreen(),
  //     );
  //   } else if (index == 4) {
  //     return const SettingsScreen();
  //   } else if (index == 5) {
  //     return const LogsScreen();
  //   } else if (index == 6) {
  //     return MultiBlocProvider(
  //         providers: [
  //           BlocProvider.value(value: _addFarmCubit),
  //           BlocProvider.value(value: _filterCubit),
  //         ],
  //         child: BlocProvider.value(
  //           value: _addFarmCubit,
  //           child: const AddFarmScreen(

  //           ),
  //         ));
  //   }
  //   return MultiBlocProvider(
  //     providers: [
  //       // BlocProvider.value(value: _addFarmCubit),
  //       BlocProvider.value(value: _filterCubit),
  //       BlocProvider.value(value: _profileCubit),
  //     ],
  //     child: BlocProvider.value(
  //       value: _homeCubit,
  //       child: const HomeMainScreen(),
  //     ),
  //   );
  // }

  Widget _buildTabScreen(TabScreen tabScreen) {
    switch (tabScreen) {
      case TabScreen.farm:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _filterCubit),
          ],
          child: FarmScreen(),
        );
      case TabScreen.sensors:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _filterCubit),
          ],
          child: SensorsScreen(),
        );
      case TabScreen.database:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _filterCubit),
          ],
          child: DatabaseScreen(),
        );
      case TabScreen.settings:
        return const SettingsScreen();
      case TabScreen.logs:
        return const LogsScreen();
      case TabScreen.addFarm:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _addFarmCubit),
            BlocProvider.value(value: _filterCubit),
          ],
          child: BlocProvider.value(
            value: _addFarmCubit,
            child: const AddFarmScreen(),
          ),
        );
      default:
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _filterCubit),
            BlocProvider.value(value: _profileCubit),
          ],
          child: BlocProvider.value(
            value: _homeCubit,
            child: const HomeMainScreen(),
          ),
        );
    }
  }
}

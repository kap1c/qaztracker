// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_base_state_widget.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/charts/ui/bar_chart.dart';
import 'package:qaz_tracker/common/widgets/drop_down_menu/app_dropdown_menu.dart';
import 'package:qaz_tracker/common/widgets/filter/cubit/filter_cubit.dart';
import 'package:qaz_tracker/common/widgets/filter/ui/filter_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/presentation/farm/ui/farm_screen.dart';
import 'package:qaz_tracker/features/presentation/home/main/cubit/home_main_cubit.dart';
import 'package:qaz_tracker/features/presentation/home/main/cubit/home_main_state.dart';
import 'package:qaz_tracker/features/presentation/home/mixin/home_data_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:qaz_tracker/features/presentation/home/widgets/information_card/information_card.dart';
import 'package:qaz_tracker/features/presentation/map/map_main/ui/map_screen.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_cubit.dart';

// class _ChartData {
//   _ChartData(this.x, this.y);
//   final String x;
//   final double y;
// }

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> with HomeDataMixin {
  late HomeCubit _homeCubit;
  late ProfileCubit _profileCubit;
  late FilterCubit _filterCubit;
  bool mapFullScreen = false;
  ValueNotifier<Map<String, dynamic>> queryParams =
      ValueNotifier<Map<String, dynamic>>({});

  ValueNotifier<bool> shouldNotify = ValueNotifier<bool>(false);
  final TextEditingController _trackersLowerBoundController =
      TextEditingController();
  final TextEditingController _trackersUpperBoundController =
      TextEditingController();
  late RangeValues _currentRangeValues;
  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();
    _profileCubit = context.read<ProfileCubit>();
    _filterCubit = context.read<FilterCubit>();

    _homeCubit.fetchHomeScreenData();

    _profileCubit.getFarmProfileInfo();

    super.initState();
  }

  @override
  void dispose() {
    _filterCubit.clearFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => _homeCubit, child: 
      BaseUpgradeBlocBuilder<Cubit<CoreState>, CoreState>(
        buildWhen: (prevState, curState) => curState is HomeState,
        builder: (context, state) {
          if (state is HomeState) {
            if (state.isLoading) {
              return const AppLoaderWidget();
            }
            return ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InformationCard(
                              iconPath: getHomeMainCategories[0].icon!,
                              title: getHomeMainCategories[0].title!,
                              bgColor: getHomeMainCategories[0].bgColor!,
                              amount: state.homeInfoData?.farms.total ?? 0,
                              changeValue:
                                  state.homeInfoData?.farms.percentage ?? 0,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            InformationCard(
                                iconPath: getHomeMainCategories[1].icon!,
                                changeValue: state.homeInfoData?.animals
                                        .farmAnimalKrs?.percentage ??
                                    0,
                                bgColor: getHomeMainCategories[1].bgColor!,
                                title: getHomeMainCategories[1].title!,
                                amount: state.homeInfoData?.animals
                                        .farmAnimalKrs?.total ??
                                    0),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InformationCard(
                              iconPath: getHomeMainCategories[2].icon!,
                              title: getHomeMainCategories[2].title!,
                              bgColor: getHomeMainCategories[2].bgColor!,
                              amount: state.homeInfoData?.animals
                                      .farmAnimalHorse?.total ??
                                  0,
                              changeValue: state.homeInfoData?.animals
                                      .farmAnimalHorse?.percentage ??
                                  0,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            InformationCard(
                              iconPath: getHomeMainCategories[3].icon!,
                              title: getHomeMainCategories[3].title!,
                              bgColor: getHomeMainCategories[3].bgColor!,
                              amount: state.homeInfoData?.animals.farmAnimalMrs
                                      ?.total ??
                                  0,
                              changeValue: state.homeInfoData?.animals
                                      .farmAnimalMrs?.percentage ??
                                  0,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: BarChartWidget(
                        isVertical: false,
                        information: state.homeInfoData?.trackers ?? [],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(
                        0XFFE8E9EE,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Карта",
                            style: TextStyle(
                              color: Color(0XFF1C202C),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          Provider(
                              create: (context) => _filterCubit,
                              child: BaseUpgradeBlocBuilder<FilterCubit,
                                      CoreState>(
                                  buildWhen: (previous, current) =>
                                      current is FilterState,
                                  builder: ((context, state) {
                                    if (state is FilterState) {
                                      _currentRangeValues = RangeValues(
                                          state.trackerLowerBound!.toDouble(),
                                          state.trackerUpperBound!.toDouble());
                                      return FilterWidget(
                                        shouldNotify: shouldNotify,
                                        content: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text('Тип скота',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .textGreyColor)),
                                                const SizedBox(height: 20),
                                                CheckboxWithTitleWidget(
                                                  isSelected: state
                                                      .getMapAnimalCategories![
                                                          0]
                                                      .isSelected,
                                                  title: state
                                                          .getMapAnimalCategories![
                                                              0]
                                                          .title ??
                                                      CoreConstant.empty,
                                                  onChanged: (isChanged) {
                                                    _filterCubit
                                                        .selectAnimalType(0);
                                                  },
                                                  onSelected: () => _filterCubit
                                                      .selectAnimalType(0),
                                                ),
                                                const SizedBox(height: 20),
                                                CheckboxWithTitleWidget(
                                                  isSelected: state
                                                      .getMapAnimalCategories![
                                                          1]
                                                      .isSelected,
                                                  title: state
                                                          .getMapAnimalCategories![
                                                              1]
                                                          .title ??
                                                      CoreConstant.empty,
                                                  onChanged: (isChanged) {
                                                    _filterCubit
                                                        .selectAnimalType(1);
                                                  },
                                                  onSelected: () => _filterCubit
                                                      .selectAnimalType(1),
                                                ),
                                                const SizedBox(height: 20),
                                                CheckboxWithTitleWidget(
                                                  isSelected: state
                                                      .getMapAnimalCategories![
                                                          2]
                                                      .isSelected,
                                                  title: state
                                                          .getMapAnimalCategories![
                                                              2]
                                                          .title ??
                                                      CoreConstant.empty,
                                                  onChanged: (isChanged) {
                                                    _filterCubit
                                                        .selectAnimalType(2);
                                                  },
                                                  onSelected: () => _filterCubit
                                                      .selectAnimalType(2),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            // OBLAST'

                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Область/Район",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                state.loadingRegions == true
                                                    ? const CircularProgressIndicator()
                                                    : AppDropDownMenu(
                                                        hintText: state
                                                                    .regionsDataList !=
                                                                null
                                                            ? state
                                                                .regionsDataList!
                                                                .items
                                                                .where(
                                                                    (element) {
                                                                  if (element
                                                                          .isSelected ==
                                                                      true) {
                                                                    return true;
                                                                  }
                                                                  return false;
                                                                })
                                                                .toList()
                                                                .toString()
                                                            : '',
                                                        items: state
                                                            .regionsDataList!
                                                            .items
                                                            .map((e) =>
                                                                DropDownItemModel(
                                                                    title:
                                                                        e.name,
                                                                    value: e.id,
                                                                    isSelected: state
                                                                        .selectedRegionIds!
                                                                        .contains(e
                                                                            .id),
                                                                    onSelected:
                                                                        () {
                                                                      _filterCubit
                                                                          .selectRegion(
                                                                              e.id);
                                                                      setState(
                                                                          () {});
                                                                    }))
                                                            .toList(),
                                                      ),
                                              ],
                                            ),
                                            // FERMA

                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Фермы",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                state.loadingFarms == true
                                                    ? const CircularProgressIndicator()
                                                    : AppDropDownMenu(
                                                        hintText: state
                                                            .farmDataList!
                                                            .where((element) {
                                                              if (element
                                                                      .isSelected ==
                                                                  true) {
                                                                return true;
                                                              }
                                                              return false;
                                                            })
                                                            .toList()
                                                            .toString(),
                                                        items: state
                                                            .farmDataList!
                                                            .map((e) =>
                                                                DropDownItemModel(
                                                                  title:
                                                                      e.name!,
                                                                  value: e.id,
                                                                  isSelected: state
                                                                      .selectedFarmIds!
                                                                      .contains(
                                                                          e.id),
                                                                  onSelected:
                                                                      () {
                                                                    _filterCubit
                                                                        .setFarm(
                                                                            e.id!);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                ))
                                                            .toList(),
                                                      ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 16,
                                            ),
                                            // BIN
                                            FilterTextInputWidget(
                                              title: "ID Tрекера",
                                              filterCubit: _filterCubit,
                                              onChanged: (trackerId) {
                                                _filterCubit
                                                    .setMapFilterIdTracker(
                                                        trackerId);
                                              },
                                            ),
                                            // TYPE

                                            //
                                            const SizedBox(
                                              height: 16.0,
                                            ),
                                            const Text(
                                              "Количество трекеров",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),

                                            StatefulBuilder(builder:
                                                (BuildContext context,
                                                    void Function(
                                                            void Function())
                                                        setState) {
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            FilterTextInputWidget(
                                                          title: "",
                                                          initialValue: state
                                                              .trackerLowerBound
                                                              ?.toString(),
                                                          filterCubit:
                                                              _filterCubit,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged:
                                                              (trackerLimit) {
                                                            setState(() {
                                                              if (int.tryParse(
                                                                          trackerLimit!)! >
                                                                      0 &&
                                                                  int.tryParse(
                                                                          trackerLimit)! <
                                                                      _currentRangeValues
                                                                          .end) {
                                                                _filterCubit.setTrackerLowerBound(
                                                                    double.tryParse(
                                                                        trackerLimit));
                                                                _currentRangeValues =
                                                                    RangeValues(
                                                                  double.tryParse(
                                                                          trackerLimit)!
                                                                      .roundToDouble(),
                                                                  _currentRangeValues
                                                                      .end,
                                                                );
                                                              }
                                                            });
                                                          },
                                                          controller:
                                                              _trackersLowerBoundController,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      Expanded(
                                                        child:
                                                            FilterTextInputWidget(
                                                          title: "",
                                                          initialValue: state
                                                              .trackerUpperBound
                                                              ?.toString(),
                                                          filterCubit:
                                                              _filterCubit,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged:
                                                              (trackerLimit) {
                                                            setState(() {
                                                              if (int.tryParse(
                                                                          trackerLimit!)! >
                                                                      0 &&
                                                                  int.tryParse(
                                                                          trackerLimit)! <
                                                                      2000 &&
                                                                  int.tryParse(
                                                                          trackerLimit)! >
                                                                      _currentRangeValues
                                                                          .start) {
                                                                _filterCubit.setTrackerUpperBound(
                                                                    double.tryParse(
                                                                        trackerLimit));

                                                                _currentRangeValues =
                                                                    RangeValues(
                                                                  _currentRangeValues
                                                                      .start,
                                                                  double.tryParse(
                                                                          trackerLimit)!
                                                                      .roundToDouble(),
                                                                );
                                                              }
                                                            });
                                                          },
                                                          controller:
                                                              _trackersUpperBoundController,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  RangeSlider(
                                                    min: 0,
                                                    max: 2000,
                                                    activeColor: AppColors
                                                        .primaryDeepBlueColor,
                                                    onChanged:
                                                        (RangeValues values) {
                                                      _filterCubit
                                                          .setTrackerUpperBound(
                                                              values.end);
                                                      _filterCubit
                                                          .setTrackerLowerBound(
                                                              values.start);
                                                      setState(() {
                                                        _currentRangeValues =
                                                            values;

                                                        _trackersLowerBoundController
                                                            .text = (values
                                                                .start
                                                                .round())
                                                            .toString();
                                                        _trackersUpperBoundController
                                                                .text =
                                                            values.end
                                                                .round()
                                                                .toString();
                                                      });
                                                    },
                                                    values: _currentRangeValues,
                                                  ),
                                                ],
                                              );
                                            }),
                                            const SizedBox(height: 10),
                                            AppMainButtonWidget(
                                              text: "Применить",
                                              textColor: Colors.white,
                                              bgColor: const Color(
                                                0XFF3772FF,
                                              ),
                                              onPressed: () {
                                                queryParams.value = _filterCubit
                                                    .returnQueryParams();
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })))
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Expanded(
                          child: MapScreen(
                        queryParams: queryParams,
                        filterIsOpened: shouldNotify,
                        isFullScreen: false,
                      ))
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        }));
  }
}

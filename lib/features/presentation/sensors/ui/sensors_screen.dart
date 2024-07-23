import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/table/ui/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_base_state_widget.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/app_text_field_widget.dart';
import 'package:qaz_tracker/common/widgets/drop_down_menu/app_dropdown_menu.dart';
import 'package:qaz_tracker/common/widgets/filter/cubit/filter_cubit.dart';
import 'package:qaz_tracker/common/widgets/filter/ui/filter_widget.dart';

import 'package:qaz_tracker/common/widgets/table/ui/table.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/data/farm/model/trackings_model.dart';
import 'package:qaz_tracker/features/presentation/farm/ui/farm_chart.dart';
import 'package:qaz_tracker/features/presentation/farm/ui/farm_screen.dart';
import 'package:qaz_tracker/features/presentation/sensors/ui/sensors_diagram.dart';

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key});

  @override
  State<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  late FilterCubit _filterCubit;
  ValueNotifier<Map<String, dynamic>> queryParams =
      ValueNotifier<Map<String, dynamic>>({});

  StreamController<List<FarmTracking>> stream =
      StreamController<List<FarmTracking>>();
  late RangeValues batteryValues;
  late RangeValues signalValues;
  TextEditingController _batteryLowerBoundController = TextEditingController();
  TextEditingController _batteryUpperBoundController = TextEditingController();
  TextEditingController _signalLowerBoundController = TextEditingController();
  TextEditingController _signalUpperBoundController = TextEditingController();
  @override
  void initState() {
    _filterCubit = context.read<FilterCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _filterCubit.clearFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      padding: const EdgeInsets.all(
        24,
      ),
      margin: const EdgeInsets.all(
        24,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  "Трекеры",
                  style: TextStyle(
                    color: AppColors.secondaryBlackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Provider(
                  create: (context) => _filterCubit,
                  child: BaseUpgradeBlocBuilder<FilterCubit, CoreState>(
                      buildWhen: (previous, current) => current is FilterState,
                      builder: ((context, state) {
                        if (state is FilterState) {
                          signalValues = RangeValues(
                              state.signalLowerBound!.toDouble(),
                              state.signalUpperBound!.toDouble());
                          batteryValues = RangeValues(
                              state.batteryLowerBound!.toDouble(),
                              state.batteryUpperBound!.toDouble());
                          return FilterWidget(
                            content: Container(
                              child: Column(
                                children: [
                                  // OBLAST'
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "За период",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                      state.loadingRegions == true
                                          ? const CircularProgressIndicator()
                                          : AppDropDownMenu(
                                              hintText: "",
                                              items: state.dateRange
                                                  .map((e) => DropDownItemModel(
                                                      title: e.values.first,
                                                      isSelected: state
                                                              .selectedDateRange
                                                              .values
                                                              .first ==
                                                          e.values.first,
                                                      value: e.keys.first,
                                                      onSelected: () =>
                                                          _filterCubit
                                                              .selectdDateRange(
                                                                  e)))
                                                  .toList(),
                                              isMultiSelect: false,
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
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
                                                  .regionsDataList!.items
                                                  .where((element) {
                                                    if (element.isSelected ==
                                                        true) return true;
                                                    return false;
                                                  })
                                                  .toList()
                                                  .toString(),
                                              items: state
                                                  .regionsDataList?.items
                                                  .map((e) => DropDownItemModel(
                                                      title: e.name,
                                                      isSelected: state
                                                          .selectedRegionIds!
                                                          .contains(e.id),
                                                      value: e.id,
                                                      onSelected: () {
                                                        _filterCubit
                                                            .selectRegion(e.id);
                                                        setState(() {});
                                                      }))
                                                  .toList(),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Ферма",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                      state.loadingFarms == true
                                          ? const CircularProgressIndicator()
                                          : AppDropDownMenu(
                                              hintText: state.farmDataList!
                                                  .where((element) {
                                                    if (element.isSelected ==
                                                        true) return true;
                                                    return false;
                                                  })
                                                  .toList()
                                                  .toString(),
                                              items: state.farmDataList!
                                                  .map((e) => DropDownItemModel(
                                                        title: e.name!,
                                                        value: e.id,
                                                        isSelected: state
                                                            .selectedFarmIds!
                                                            .contains(e.id),
                                                        onSelected: () {
                                                          _filterCubit
                                                              .setFarm(e.id!);
                                                          setState(() {});
                                                        },
                                                      ))
                                                  .toList(),
                                            ),
                                    ],
                                  ),

                                  // FERMA
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  // BIN

                                  FilterTextInputWidget(
                                    title: "БИН",
                                    filterCubit: _filterCubit,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    onChanged: (BIN) {
                                      _filterCubit.setBin(int.parse(BIN!));
                                    },
                                  ),
                                  // TYPE
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    "По уровню батареи",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),

                                  StatefulBuilder(builder: (BuildContext
                                          context,
                                      void Function(void Function()) setState) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: FilterTextInputWidget(
                                                title: "",
                                                initialValue: state
                                                    .batteryLowerBound
                                                    .toString(),
                                                filterCubit: _filterCubit,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (trackerLimit) {
                                                  _filterCubit
                                                      .setBatteryLowerBound(
                                                          double.tryParse(
                                                              trackerLimit!));

                                                  setState(() {
                                                    if (int.tryParse(
                                                                trackerLimit!)! >
                                                            0 &&
                                                        int.tryParse(
                                                                trackerLimit!)! <
                                                            100) {
                                                      batteryValues =
                                                          RangeValues(
                                                        double.tryParse(
                                                                trackerLimit!)!
                                                            .roundToDouble()!,
                                                        batteryValues.end,
                                                      );
                                                    }
                                                  });
                                                },
                                                controller:
                                                    _batteryLowerBoundController,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: FilterTextInputWidget(
                                                title: "",
                                                initialValue: state
                                                    .batteryUpperBound
                                                    .toString(),
                                                filterCubit: _filterCubit,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (trackerLimit) {
                                                  _filterCubit
                                                      .setBatteryUpperBound(
                                                          double.tryParse(
                                                              trackerLimit!));
                                                  setState(() {
                                                    if (int.tryParse(
                                                                trackerLimit!)! >
                                                            0 &&
                                                        int.tryParse(
                                                                trackerLimit!)! <=
                                                            100) {
                                                      batteryValues =
                                                          RangeValues(
                                                        batteryValues.start,
                                                        double.tryParse(
                                                                trackerLimit!)!
                                                            .roundToDouble()!,
                                                      );
                                                    }
                                                  });
                                                },
                                                controller:
                                                    _batteryUpperBoundController,
                                              ),
                                            ),
                                          ],
                                        ),
                                        RangeSlider(
                                            min: 0,
                                            max: 100,
                                            activeColor:
                                                AppColors.primaryDeepBlueColor,
                                            onChanged: (RangeValues values) {
                                              _filterCubit.setBatteryLowerBound(
                                                  values.start);
                                              _filterCubit.setBatteryUpperBound(
                                                  values.end);
                                              setState(() {
                                                batteryValues = values;
                                                _batteryLowerBoundController
                                                        .text =
                                                    values.start
                                                        .round()
                                                        .toString();
                                                _batteryUpperBoundController
                                                        .text =
                                                    values.end
                                                        .round()
                                                        .toString();
                                              });
                                            },
                                            values: batteryValues),
                                      ],
                                    );
                                  }),
                                  const SizedBox(
                                    height: 16,
                                  ),

                                  const Text(
                                    "По уровню сети",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),

                                  StatefulBuilder(builder: (BuildContext
                                          context,
                                      void Function(void Function()) setState) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: FilterTextInputWidget(
                                                title: "",
                                                initialValue:
                                                    signalValues.end.toString(),
                                                filterCubit: _filterCubit,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (trackerLimit) {
                                                  _filterCubit
                                                      .setSignalLowerBound(
                                                          double.tryParse(
                                                              trackerLimit!));
                                                  setState(() {
                                                    if (int.tryParse(
                                                                trackerLimit!)! >
                                                            0 &&
                                                        int.tryParse(
                                                                trackerLimit!)! <
                                                            100) {
                                                      signalValues =
                                                          RangeValues(
                                                        double.tryParse(
                                                                trackerLimit!)!
                                                            .roundToDouble()!,
                                                        signalValues.end,
                                                      );
                                                    }
                                                  });
                                                },
                                                controller:
                                                    _signalLowerBoundController,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: FilterTextInputWidget(
                                                title: "",
                                                initialValue:
                                                    signalValues.end.toString(),
                                                filterCubit: _filterCubit,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (trackerLimit) {
                                                  _filterCubit
                                                      .setBatteryUpperBound(
                                                          double.tryParse(
                                                              trackerLimit!));
                                                  setState(() {
                                                    if (int.tryParse(
                                                                trackerLimit!)! <
                                                            100 &&
                                                        int.tryParse(
                                                                trackerLimit)! >=
                                                            signalValues
                                                                .start) {}
                                                    signalValues = RangeValues(
                                                      signalValues.start,
                                                      double.tryParse(
                                                          trackerLimit!)!,
                                                    );
                                                  });
                                                },
                                                controller:
                                                    _signalUpperBoundController,
                                              ),
                                            ),
                                          ],
                                        ),
                                        RangeSlider(
                                          min: 0,
                                          max: 100,
                                          activeColor:
                                              AppColors.primaryDeepBlueColor,
                                          onChanged: (RangeValues values) {
                                            _filterCubit.setSignalLowerBound(
                                                values.start);
                                            _filterCubit.setSignalUpperBound(
                                                values.end);
                                            setState(() {
                                              signalValues = values;
                                              _signalLowerBoundController.text =
                                                  values.start
                                                      .toInt()
                                                      .toString();
                                              _signalUpperBoundController.text =
                                                  values.end.toInt().toString();
                                            });
                                          },
                                          values: signalValues,
                                        ),
                                      ],
                                    );
                                  }),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  AppMainButtonWidget(
                                    text: "Применить",
                                    textColor: Colors.white,
                                    bgColor: const Color(
                                      0XFF3772FF,
                                    ),
                                    onPressed: () {
                                      _filterCubit.setFarmIdToFetchTrackings(0);
                                      queryParams.value =
                                          _filterCubit.returnQueryParams();
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      })))
            ],
          ),
          SensorsChart(
            dataStream: stream.stream.asBroadcastStream(),
            queryParameter: queryParams,
          ),
          const SizedBox(
            height: 24,
          ),
          CustomTable(
            category: "sensors",
            queryParams: queryParams,
            stream: stream,
          ),
        ],
      ),
    );
  }
}

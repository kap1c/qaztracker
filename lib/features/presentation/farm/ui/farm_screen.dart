import 'dart:async';

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

class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  ValueNotifier<Map<String, dynamic>> queryParams =
      ValueNotifier<Map<String, dynamic>>({});

  late FilterCubit _filterCubit;

  ValueNotifier<dynamic> selectedFarms = ValueNotifier<dynamic>(null);
  StreamController<List<FarmTracking>> stream =
      StreamController<List<FarmTracking>>();

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
                  "Фермы",
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
                          return FilterWidget(
                            content: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                // OBLAST'
                                const SizedBox(
                                  height: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            hintText:
                                                state.regionsDataList!.items
                                                    .where((element) {
                                                      if (element.isSelected ==
                                                          true) return true;
                                                      return false;
                                                    })
                                                    .toList()
                                                    .toString(),
                                            items: state.regionsDataList?.items
                                                .map((e) => DropDownItemModel(
                                                    title: e.name,
                                                    value: e.id,
                                                    isSelected: state
                                                        .selectedRegionIds!
                                                        .contains(e.id),
                                                    onSelected: () {
                                                      _filterCubit
                                                          .selectRegion(e.id);
                                                      setState(() {});
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        .contains(e.id)!,
                                                    onSelected: () {
                                                      _filterCubit
                                                          .setFarm(e.id!);
                                                      setState(() {});
                                                    }))
                                                .toList(),
                                          ),
                                  ],
                                ),
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
                                    if (BIN != null)
                                      _filterCubit.setBin(int.parse(BIN));
                                  },
                                ),
                                // TYPE
                                const SizedBox(
                                  height: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text('Тип скота',
                                        style: TextStyle(
                                            color: AppColors.textGreyColor)),
                                    const SizedBox(height: 20),
                                    CheckboxWithTitleWidget(
                                      isSelected: state
                                          .getMapAnimalCategories![1]
                                          .isSelected,
                                      title: state.getMapAnimalCategories![1]
                                              .title ??
                                          CoreConstant.empty,
                                      onChanged: (isChanged) {
                                        _filterCubit.selectAnimalType(1);
                                      },
                                      onSelected: () =>
                                          _filterCubit.selectAnimalType(1),
                                    ),
                                    const SizedBox(height: 20),
                                    CheckboxWithTitleWidget(
                                      isSelected: state
                                          .getMapAnimalCategories![2]
                                          .isSelected,
                                      title: state.getMapAnimalCategories![2]
                                              .title ??
                                          CoreConstant.empty,
                                      onChanged: (isChanged) {
                                        _filterCubit.selectAnimalType(2);
                                      },
                                      onSelected: () =>
                                          _filterCubit.selectAnimalType(2),
                                    ),
                                    const SizedBox(height: 20),
                                    CheckboxWithTitleWidget(
                                      isSelected: state
                                          .getMapAnimalCategories![0]
                                          .isSelected,
                                      title: state.getMapAnimalCategories![0]
                                              .title ??
                                          CoreConstant.empty,
                                      onChanged: (isChanged) {
                                        _filterCubit.selectAnimalType(0);
                                      },
                                      onSelected: () =>
                                          _filterCubit.selectAnimalType(0),
                                    ),
                                  ],
                                ),
                                //
                                const SizedBox(
                                  height: 28.0,
                                ),

                                AppMainButtonWidget(
                                  text: "Применить",
                                  textColor: Colors.white,
                                  bgColor: const Color(
                                    0XFF3772FF,
                                  ),
                                  onPressed: () {
                                    queryParams.value =
                                        _filterCubit.returnQueryParams();
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
          FarmChart(
            dataStream: stream.stream.asBroadcastStream(),
          ),
          const SizedBox(
            height: 24.0,
          ),
          CustomTable(
            category: "farm",
            queryParams: queryParams,
            valueListenable: selectedFarms,
            stream: stream,
          ),
        ],
      ),
    );
  }
}

class FilterTextInputWidget extends StatelessWidget {
  String title;

  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;
  Function(String?)? onChanged;
  String? initialValue;
  bool? showMaxLength;
  TextEditingController? controller = TextEditingController();
  FilterTextInputWidget({
    super.key,
    required FilterCubit filterCubit,
    required this.title,
    this.inputFormatters,
    this.keyboardType,
    required this.onChanged,
    this.initialValue,
    this.showMaxLength,
    this.controller,
  }) : _filterCubit = filterCubit;

  final FilterCubit _filterCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          this.title,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
        AppTextFieldWidget(
          initialValue: initialValue,
          textEditingController: controller,
          onChanged: (BIN) {
            // _filterCubit.setBin(BIN!=""? int.parse(BIN!):0);
            onChanged!(BIN);
          },
          keyboardType: keyboardType,
          maxLength: showMaxLength != null ? 12 : null,
          inputFormatters: this.inputFormatters,
        ),
      ],
    );
  }
}

class CheckboxWithTitleWidget extends StatefulWidget {
  bool isSelected;
  final String title;
  final Function(bool) onChanged;
  final Function? onSelected;
  CheckboxWithTitleWidget({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.onChanged,
    this.onSelected,
  }) : super(key: key);

  @override
  _CheckboxWithTitleWidgetState createState() =>
      _CheckboxWithTitleWidgetState();
}

class _CheckboxWithTitleWidgetState extends State<CheckboxWithTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: widget.isSelected,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: Color(0XFF2A60F7),
          onChanged: (newValue) {
            if (widget.onSelected != null) {
              widget.onSelected!();
              setState(() {
                widget.isSelected = !widget.isSelected;
              });
            }
            widget.onChanged(widget.isSelected);
          },
        ),
        Text(
          widget.title,
          style: const TextStyle(
            color: Color(0XFF32384A),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

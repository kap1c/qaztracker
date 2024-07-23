import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_base_state_widget.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/app_text_field_widget.dart';
import 'package:qaz_tracker/common/widgets/drop_down_menu/app_dropdown_menu.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/add_farm/add_tracking_model.dart';
import 'package:qaz_tracker/features/presentation/add_farm/cubit/add_farm_cubit.dart';

class AddTrackerScreen extends StatefulWidget {
  bool isEdit = false;

  FarmAnimalModel? farmAnimalModel;
  ValueNotifier<Map<String, dynamic>> fetchAnimals;
  bool isLoading = false;

  AddTrackerScreen({
    super.key,
    this.isEdit = false,
    required this.fetchAnimals,
  });

  @override
  State<AddTrackerScreen> createState() => _AddTrackerScreenState();
}

class _AddTrackerScreenState extends State<AddTrackerScreen> {
  QazTrackerApiService _apiService = locator();
  late AddFarmCubit _addFarmCubit;
  bool isMale = false;
  bool isUpdating = false;
  @override
  void initState() {
    widget.isLoading = true;
    _addFarmCubit = context.read<AddFarmCubit>();
    _addFarmCubit.fetchAnimalBreedsAndTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BaseUpgradeBlocBuilder<AddFarmCubit, CoreState>(
        buildWhen: (previous, current) => current is AddFarmState,
        builder: (context, state) {
          if (state is AddFarmState) {
            return Container(
              margin: const EdgeInsets.all(24.0),
              width: MediaQuery.of(context).size.width * 0.4,
              child: state.isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.isEdit
                                  ? "Редактирование трекера"
                                  : "Добавить трекер",
                              style: const TextStyle(
                                color: Color(0XFF1C202C),
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color:
                                      AppColors.secondaryTextFieldBorderColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AppColors.secondaryBlackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        const Text("Имя"),
                        const SizedBox(height: 8.0),
                        AppTextFieldWidget(
                          initialValue: state.farmAnimalModel != null
                              ? state.farmAnimalModel!.name
                              : "",
                          onChanged: (value) {
                            _addFarmCubit.setTrackerName(value);
                          },
                        ),
                        const SizedBox(height: 8.0),
                        const Text("Вес"),
                        const SizedBox(height: 8.0),
                        AppTextFieldWidget(
                          initialValue: state.farmAnimalModel!.weight != null
                              ? state.farmAnimalModel!.weight.toString()
                              : "",
                          onChanged: (value) {
                            _addFarmCubit.setTrackerWeight(
                                double.tryParse(value ?? "0"));
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ], // maxLength: 12,
                        ),
                        const SizedBox(height: 8.0),
                        const Text("ID трекера"),
                        const SizedBox(height: 8.0),
                        AppTextFieldWidget(
                          initialValue: state.farmAnimalModel != null
                              ? state.farmAnimalModel!.trackerId
                              : "",
                          onChanged: (value) {
                            _addFarmCubit.setTrackerId(value);
                          },
                        ),
                        const SizedBox(height: 8.0),
                        const Text("Пол"),
                        const SizedBox(height: 8.0),
                        AppDropDownMenu(
                          hintText: "",
                          isMultiSelect: false,
                          items: [
                            DropDownItemModel(
                              title: "Мужской",
                              value: "M",
                              isSelected: state.farmAnimalModel != null &&
                                      (state.farmAnimalModel!.gender == "М" ||
                                          state.farmAnimalModel!.gender == "M")
                                  ? true
                                  : false,
                              onSelected: () =>
                                  _addFarmCubit.setTrackerGender("M"),
                            ),
                            DropDownItemModel(
                              title: "Женский",
                              value: "F",
                              isSelected: state.farmAnimalModel!.gender == "F"
                                  ? true
                                  : false,
                              onSelected: () =>
                                  _addFarmCubit.setTrackerGender("F"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        const Text("Возраст"),
                        const SizedBox(height: 8.0),
                        AppTextFieldWidget(
                          initialValue: state.farmAnimalModel != null &&
                                  state.farmAnimalModel!.age != null
                              ? state.farmAnimalModel!.age.toString()
                              : "",
                          onChanged: (value) {
                            _addFarmCubit
                                .setTrackerAge(double.tryParse(value ?? "0"));
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ], // maxLength: 12,
                        ),
                        const SizedBox(height: 8.0),
                        const Text("Тип животного"),
                        const SizedBox(height: 8.0),
                        AppDropDownMenu(
                          hintText: "",
                          isMultiSelect: false,
                          items: state.animalTypes.map((e) {
                            return DropDownItemModel(
                                title: e.name,
                                value: e.id,
                                isSelected:
                                    state.farmAnimalModel!.animalTypeId == e.id
                                        ? true
                                        : false,
                                onSelected: () =>
                                    _addFarmCubit.setTrackerAnimalType(e.id));
                          }).toList(),
                        ),
                        const SizedBox(height: 8.0),
                        const Text("Порода"),
                        const SizedBox(height: 8.0),
                        AppDropDownMenu(
                          hintText: "",
                          isMultiSelect: false,
                          items: state.animalBreeds.map((e) {
                            return DropDownItemModel(
                                title: e.name != null ? e.name! : "",
                                value: e.id,
                                isSelected:
                                    state.farmAnimalModel!.breedId == e.id
                                        ? true
                                        : false,
                                onSelected: () =>
                                    _addFarmCubit.setTrackerBreed(e.id));
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: AppMainButtonWidget(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                text: "Отмена",
                                bgColor: Colors.white,
                                textColor: AppColors.textGreyColor,
                                borderColor:
                                    AppColors.secondaryTextFieldBorderColor,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: AppMainButtonWidget(
                                onPressed: () {
                                  _addFarmCubit.addTrackerRequest(
                                      context, widget.fetchAnimals);
                                },
                                child: Text(
                                    widget.isEdit ? "Сохранить" : 'Добавить'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

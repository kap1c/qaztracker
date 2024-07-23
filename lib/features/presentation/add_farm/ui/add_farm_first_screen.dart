import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_base_state_widget.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/app_text_field_widget.dart';
import 'package:qaz_tracker/common/widgets/drop_down_menu/app_dropdown_menu.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/constants/app_global_regex_consts.dart';
import 'package:qaz_tracker/features/presentation/add_farm/cubit/add_farm_cubit.dart';

class AddFarmFirstScreen extends StatefulWidget {
  const AddFarmFirstScreen({super.key});

  @override
  State<AddFarmFirstScreen> createState() => _AddFarmFirstScreenState();
}

class _AddFarmFirstScreenState extends State<AddFarmFirstScreen> {
  final MaskTextInputFormatter _phoneController = MaskTextInputFormatter(
      mask: GlobalRegexConstants.phoneMask,
      filter: {"#": GlobalRegexConstants.digitRegex});
  late AddFarmCubit _addFarmCubit;

  bool isHidden = true;

  @override
  void initState() {
    _addFarmCubit = context.read<AddFarmCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _addFarmCubit,
      child: BaseUpgradeBlocBuilder<AddFarmCubit, CoreState>(
          buildWhen: (previous, current) => current is AddFarmState,
          builder: ((context, state) {
            if (state is AddFarmState) {
              return ListView(
                children: [
                  const Text(
                    "Название фермы",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppTextFieldWidget(
                    initialValue: state.farmModel!.name,
                    onChanged: (farmName) {
                      _addFarmCubit.setFarmName(farmName!);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "БИН",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppTextFieldWidget(
                    initialValue: state.farmModel!.bin,
                    onChanged: (bin) {
                      _addFarmCubit.setBin(int.parse(bin!));
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Количество трекеров",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppTextFieldWidget(
                    initialValue: state.farmModel!.headsCount != null
                        ? state.farmModel!.headsCount.toString() 
                        : "" 

                        ,
                    onChanged: (headsCount) {
                      _addFarmCubit
                          .setHeadsCount(int.tryParse(headsCount!)!);
                      
                    },
                    keyboardType: TextInputType.number,
                    // maxLength: 12,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(
                    height: 8,
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
                      state.isLoading == true
                          ? const CircularProgressIndicator()
                          : AppDropDownMenu(
                              hintText: state.regionsData!.items
                                  .where((element) {
                                    if (element.isSelected == true) return true;
                                    return false;
                                  })
                                  .toList()
                                  .toString(),
                              isMultiSelect: false,
                              items: state.regionsData?.items
                                  .map((e) => DropDownItemModel(
                                      title: e.name,
                                      value: e.id,
                                      isSelected:
                                          state.farmModel!.regionId == e.id,
                                      onSelected: () {
                                        _addFarmCubit.setRegion(e.id);
                                      }))
                                  .toList(),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "ФИО",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppTextFieldWidget(
                    initialValue: state.farmModel!.fio,
                    onChanged: (fio) {
                      _addFarmCubit.setUserName(fio!);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Площадь",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  AppTextFieldWidget(
                    initialValue: state.farmModel!.area != null
                        ? state.farmModel!.area.toString()
                        : "",
                    onChanged: (area) {
                      _addFarmCubit.setArea(double.parse(area!));
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Номер",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppTextFieldWidget(
                    initialValue: state.farmModel!.phone,
                    inputFormatters: [_phoneController],
                    keyboardType: TextInputType.phone,
                    hint: '+7',
                    onChanged: (phone) {
                      _addFarmCubit
                          .setPhoneNumber(_phoneController.getUnmaskedText());
                    },
                  ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // const Text(
                  //   "Пароль",
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 13,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // AppTextFieldWidget(
                  //   initialValue: state.farmModel!.password,
                  //   obscureText: isHidden,
                  //   maxLines: 1,
                  //   onChanged: (password) {
                  //     _addFarmCubit.setPassword(password!);
                  //   },
                  //   suffixIcon: IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           isHidden = !isHidden;
                  //         });
                  //       },
                  //       icon: isHidden
                  //           ? const Icon(CupertinoIcons.eye_fill)
                  //           : const Icon(CupertinoIcons.eye_slash_fill)),
                  // ),
                ],
              );
            } else {
              return const SizedBox();
            }
          })),
    );
  }
}

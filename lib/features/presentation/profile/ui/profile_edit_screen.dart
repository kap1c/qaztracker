// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_keyboard_hide_widget.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/app_snackbar_widget.dart';
import 'package:qaz_tracker/common/widgets/app_text_field_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/constants/app_global_regex_consts.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_cubit.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_state.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final MaskTextInputFormatter _phoneController = MaskTextInputFormatter(
      mask: GlobalRegexConstants.phoneMask,
      filter: {"#": GlobalRegexConstants.digitRegex});

  late ProfileCubit _profileCubit;

  @override
  void initState() {
    _profileCubit = context.read<ProfileCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppHideKeyBoardWidget(
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                },
                icon: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            width: 1,
                            color: AppColors.secondaryTextFieldBorderColor)),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: Colors.black))),
            title: const Text('Редактирование',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            elevation: 0,
            backgroundColor: Colors.white),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: CoreUpgradeBlocBuilder<ProfileCubit, CoreState>(
                listener: (context, state) {
                  if (state is ProfileState) {
                    if (state.isSuccess) {
                      showCustomFlashBar(
                          text: 'Успешно изменилось!',
                          color: Colors.green,
                          context: context);
                    }
                  }
                },
                buildWhen: (prevState, curState) => curState is ProfileState,
                builder: (context, state) {
                  if (state is ProfileState) {
                    if (state.isLoading) {
                      return const AppLoaderWidget();
                    }
                    final phone = _phoneController
                        .maskText(state.appCurrentUserEntity!.phone!);
                    return Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Наименование фермы',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400)),
                            const SizedBox(height: 5),
                            AppTextFieldWidget(
                                keyboardType: TextInputType.text,
                                hint: state.appCurrentUserEntity!.name ??
                                    CoreConstant.empty,
                                onChanged: (val) {
                                  _profileCubit.setTitleName(val);
                                }),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Фермер',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(height: 5),
                                  AppTextFieldWidget(
                                    keyboardType: TextInputType.text,
                                    hint: state.appCurrentUserEntity!.fio ??
                                        CoreConstant.empty,
                                    onChanged: (val) {
                                      _profileCubit.setFarmName(val);
                                    },
                                  ),
                                ])),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Номер телефона',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 5),
                              AppTextFieldWidget(
                                inputFormatters: [_phoneController],
                                keyboardType: TextInputType.phone,
                                hint: phone,
                              )
                            ]),
                        const SizedBox(height: 45),
                        Row(children: [
                          Expanded(
                            child: AppMainButtonWidget(
                              onPressed: () {
                                String phone =
                                    _phoneController.getUnmaskedText().trim();
                                _profileCubit.setPhone(phone);
                                HapticFeedback.mediumImpact();
                                // _profileCubit.updateProfile();
                                _profileCubit.updateFarmProfile();
                              },
                              text: 'Сохранить',
                            ),
                          )
                        ])
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                })),
      ),
    );
  }
}

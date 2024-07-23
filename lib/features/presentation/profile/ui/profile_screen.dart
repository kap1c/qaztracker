// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/app.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/constants/app_global_regex_consts.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_cubit.dart';
import 'package:qaz_tracker/features/presentation/profile/cubit/profile_state.dart';
import 'package:qaz_tracker/features/presentation/profile/mixin/profile_data_mixin.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/profile_edit_screen.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/widgets/profile_action_item_widget.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/widgets/profile_bottomsheet_widget.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/widgets/profile_exit_dialog_widget.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/widgets/profile_support_dialog_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with ProfileDataMixin {
  late ProfileCubit _profileCubit;

  final MaskTextInputFormatter _phoneController = MaskTextInputFormatter(
      mask: GlobalRegexConstants.phoneMask,
      filter: {"#": GlobalRegexConstants.digitRegex});

  @override
  void initState() {
    _profileCubit = context.read<ProfileCubit>();
    _profileCubit.getFarmProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _profileCubit,
      child: Scaffold(
        body: SafeArea(
            child: CoreUpgradeBlocBuilder<ProfileCubit, CoreState>(
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
                        Container(
                          decoration: const BoxDecoration(
                              color: AppColors.profileBgGreyColor),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ферма',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textGreyColor),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                      state.appCurrentUserEntity?.fio ?? '',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Text(phone,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400)),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 10),
                                  child: AppMainButtonWidget(
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider.value(
                                                        value: _profileCubit,
                                                        child:
                                                            const ProfileEditScreen())));
                                      },
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.edit_outlined),
                                            SizedBox(width: 10),
                                            Text('Редактировать')
                                          ])),
                                )
                              ],
                            ),
                          ),
                        ),
                        ListView.separated(
                          itemCount: getProfileActionOptions.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          separatorBuilder: (BuildContext context, int index) {
                            return ProfileActionOptionItemWidget(
                                tap: () {
                                  HapticFeedback.mediumImpact();
                                  if (index == 0) {
                                    showProfilePaymentBottomSheet(
                                        context, state.appCurrentUserEntity);
                                  } else if (index == 1) {
                                    showProfileSupportDialog(context);
                                  } else if (index == 2) {
                                    showExitCupertinoDialog(
                                        context: context,
                                        onExit: () {
                                          _profileCubit.logoutApp();
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const QazTrackerApp()),
                                              (route) => false);
                                        });
                                  }
                                },
                                title: getProfileActionOptions[index].title!,
                                child: getProfileActionOptions[index].icon);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            if (index > 0) {
                              return const Divider();
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
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

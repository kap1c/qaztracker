// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_bloc_builder.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/common/widgets/app_keyboard_hide_widget.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/app_snackbar_widget.dart';
import 'package:qaz_tracker/common/widgets/app_text_field_widget.dart';
import 'package:qaz_tracker/config/routes/app_route_list.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/constants/app_global_regex_consts.dart';
import 'package:qaz_tracker/features/presentation/auth/cubit/auth_login_cubit.dart';
import 'package:qaz_tracker/features/presentation/auth/cubit/auth_login_state.dart';
import 'package:sizer/sizer.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final MaskTextInputFormatter _phoneController = MaskTextInputFormatter(
      mask: GlobalRegexConstants.phoneMask,
      filter: {"#": GlobalRegexConstants.digitRegex});

  bool isHidden = true;
  late AuthLoginCubit _authLoginCubit;

  @override
  void initState() {
    _authLoginCubit = AuthLoginCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _authLoginCubit,
      child: AppHideKeyBoardWidget(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: SafeArea(
              child: CoreUpgradeBlocBuilder<AuthLoginCubit, CoreState>(
                  buildWhen: (prevState, curState) =>
                      curState is AuthLoginState,
                  listener: (context, state) {
                    if (state is AuthFillFieldsState) {
                      HapticFeedback.heavyImpact();
                      showCustomFlashBar(
                          text: 'Заполните все поля!',
                          color: AppColors.primaryRedColor,
                          context: context);
                    } else if (state is AuthLoginState) {
                      if (state.isSuccessfullyLogged) {
                        HapticFeedback.mediumImpact();
                        showCustomFlashBar(
                            text: 'Успешно авторизовались!',
                            color: AppColors.primaryGreenColor,
                            context: context);
                        Navigator.pushNamedAndRemoveUntil(context,
                            AppRoutes.appOnStartScreen, (Route route) => false);
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoginState) {
                      return IgnorePointer(
                        ignoring: state.isLoading,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(48),
                          height: 496,
                          width: 456,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Авторизация',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 12),
                              const Text('С возвращением!',
                                  style: TextStyle(
                                      color: AppColors.secondaryBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 23),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Номер телефона',
                                        style: TextStyle(
                                            color: AppColors.textGreyColor)),
                                    const SizedBox(height: 5),
                                    AppTextFieldWidget(
                                      inputFormatters: [_phoneController],
                                      keyboardType: TextInputType.phone,
                                      hint: '+7',
                                      onChanged: (val) {
                                        _authLoginCubit.setPhone(
                                            _phoneController.getUnmaskedText());
                                      },
                                    ),
                                  ]),
                              SizedBox(height: 2.0.h),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Пароль',
                                        style: TextStyle(
                                            color: AppColors.textGreyColor)),
                                    const SizedBox(height: 5),
                                    AppTextFieldWidget(
                                      obscureText: isHidden,
                                      maxLines: 1,
                                      onChanged: (val) {
                                        _authLoginCubit.setPassword(val);
                                      },
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isHidden = !isHidden;
                                            });
                                          },
                                          icon: isHidden
                                              ? const Icon(
                                                  CupertinoIcons.eye_fill)
                                              : const Icon(CupertinoIcons
                                                  .eye_slash_fill)),
                                    ),
                                  ]),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Expanded(
                                      child: AppMainButtonWidget(
                                          isLoading: state.isLoading,
                                          text: 'Войти',
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            _authLoginCubit.doLogin();
                                          })),
                                ],
                              ),
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Забыли пароль?',
                                      style: TextStyle(
                                          color: AppColors.primaryBlueColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

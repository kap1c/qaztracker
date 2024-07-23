import 'package:flutter/material.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/common/widgets/app_base_state_widget.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/app_snackbar_widget.dart';
import 'package:qaz_tracker/common/widgets/filter/cubit/filter_cubit.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/presentation/add_farm/cubit/add_farm_cubit.dart';
import 'package:qaz_tracker/features/presentation/add_farm/ui/add_farm_first_screen.dart';
import 'package:qaz_tracker/features/presentation/add_farm/ui/add_farm_second_screen.dart';
import 'package:provider/provider.dart';
import 'package:qaz_tracker/features/presentation/cubit/navigation_cubit.dart';

class AddFarmScreen extends StatefulWidget {
  const AddFarmScreen({super.key});

  @override
  State<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends State<AddFarmScreen> {
  late AddFarmCubit _addFarmCubit;
  late NavigationCubit _navigationCubit;
  final PageController _pageController = PageController(initialPage: 0);
  bool pageControllerIsAttached = false;
  int _currentPage = 0;
  @override
  initState() {
    _addFarmCubit = context.read<AddFarmCubit>();
    _navigationCubit = context.read<NavigationCubit>();
    _addFarmCubit.getFarmRequest(_pageController);
    _addFarmCubit.getAllRegions();
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    _pageController.dispose();
    _addFarmCubit.clearFarmData();
  }

  @override
  Widget build(BuildContext context) {
    return BaseUpgradeBlocBuilder<AddFarmCubit, CoreState>(
      buildWhen: (previous, current) => current is AddFarmState,
      builder: ((context, state) {
        if (state is AddFarmState) {
          return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(
                      0XFFE8E9EE,
                    ),
                  ),
                ),
                margin: const EdgeInsets.all(
                  24,
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        "Регистрация новой фермы",
                        style: TextStyle(
                          color: Color(0XFF1C202C),
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        children: const [
                          AddFarmFirstScreen(),
                          AddFarmSecondScreen()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _currentPage != 0
                        ? AppMainButtonWidget(
                            text: "Вернуться назад",
                            borderColor: AppColors.primaryBlueColor,
                            textColor: AppColors.primaryBlueColor,
                            bgColor: Colors.white,
                            verticalPadding: 10,
                            horizontalPadding: 22,
                            onPressed: () {
                              _pageController.previousPage(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.linear);
                            },
                          )
                        : const SizedBox(),
                    const SizedBox(
                      width: 24,
                    ),
                    state.creatingFarm == false
                        ? AppMainButtonWidget(
                            text:
                                _currentPage == 0 ? "Продолжить" : "Сохранить",
                            borderColor: Colors.white,
                            textColor: Colors.white,
                            verticalPadding: 10,
                            horizontalPadding: 22,
                            onPressed: () {
                              if (_pageController.page!.toInt() == 0) {
                                _addFarmCubit.addFarmRequest(
                                    _pageController, context);
                              } else {
                                _navigationCubit.navigateToPreviousScreen();

                                showCustomFlashBar(
                                    text: "Ферма создана успешно",
                                    color: AppColors.primaryGreenColor,
                                    context: context);
                              }
                            },
                          )
                        : const CircularProgressIndicator(),
                  ],
                ),
              )
              // : const SizedBox(),
              );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}

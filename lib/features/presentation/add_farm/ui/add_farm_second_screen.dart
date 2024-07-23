import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/app_snackbar_widget.dart';
import 'package:qaz_tracker/common/widgets/table/ui/table.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/add_farm/add_tracking_model.dart';
import 'package:qaz_tracker/features/data/farm/model/farm_model.dart';
import 'package:qaz_tracker/features/presentation/add_farm/cubit/add_farm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core/presentation/abstract/bloc/core_state.dart';
import 'package:qaz_tracker/common/widgets/app_base_state_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/presentation/add_farm/ui/add_tracker_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/widgets/profile_exit_dialog_widget.dart';

class AddFarmSecondScreen extends StatefulWidget {
  const AddFarmSecondScreen({super.key});

  @override
  State<AddFarmSecondScreen> createState() => _AddFarmSecondScreenState();
}

class _AddFarmSecondScreenState extends State<AddFarmSecondScreen> {
  late AddFarmCubit _addFarmCubit;
  ValueNotifier<dynamic> selectedValue = ValueNotifier<dynamic>(null);

  ValueNotifier<dynamic> valueListenable = ValueNotifier(null);
  ValueNotifier<Map<String, dynamic>> fetchAnimalTrackers = ValueNotifier({});
  // late UserRole userRole;
  late User user;
  @override
  void initState() {
    _addFarmCubit = context.read<AddFarmCubit>();
    
    user =  locator<User>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseUpgradeBlocBuilder<AddFarmCubit, CoreState>(
        buildWhen: (previous, current) => current is AddFarmState,
        builder: ((context, state) {
          if (state is AddFarmState) {
            return ListView(
              children: [
                FarmInformationWidget(
                  farmModel: state.farmModel!,
                ),
                const SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 200,
                    child: AppMainButtonWidget(
                      verticalPadding: 10,
                      horizontalPadding: 22,
                      text: "Добавить трекер",
                      onPressed: () {
                        _addFarmCubit.setSelectedFarm(FarmAnimalModel());
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BlocProvider.value(
                                value: _addFarmCubit,
                                child: AddTrackerScreen(
                                  fetchAnimals: fetchAnimalTrackers,
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTable(
                  category: user.role == UserRole.admin
                      ? "admin/farm/animal/${state.farmModel!.id}"
                      : "manager/farm/animal/${state.farmModel!.id}",
                  queryParams: fetchAnimalTrackers,
                  isEditable: true,
                  valueListenable: valueListenable,
                  callbackEdit: () {
                    _addFarmCubit.setSelectedFarm(valueListenable.value);
                    showDialog(
                        context: context,
                        builder: ((BuildContext context) {
                          return BlocProvider.value(
                            value: _addFarmCubit,
                            child: AddTrackerScreen(
                              fetchAnimals: fetchAnimalTrackers,
                              isEdit: true,
                            ),
                          );
                        }));
                  },
                  callbackDelete: () {
                    QazTrackerApiService _apiService = locator();
                    showExitCupertinoDialog(
                      context: context,
                      title: "Удаление Датчика",
                      description: "Вы уверены, что хотите удалить датчик? ",
                      actionText: "Удалить",
                      onExit: () {
                        safeApiCallWithError(
                            _apiService.deleteTracker(
                              trackerId: valueListenable.value.id,
                              farmId: state.farmModel!.id!,
                            ), (p0) {
                          fetchAnimalTrackers.value = {};
                          fetchAnimalTrackers.notifyListeners();
                          Navigator.of(context).pop();
                          showCustomFlashBar(
                              text: "Датчик удален",
                              color: AppColors.primaryGreenColor,
                              context: context);

                        }, (error, defaultError, code) {
                          // Navigator.of(context).pop();

                          showCustomFlashBar(
                              text: "Проблема при удалении датчика",
                              color: AppColors.primaryRedColor,
                              context: context);

                          return HttpExceptionData(
                              status: code, detail: error['message']);
                        });
                        // show bar that shpw that some params are empty
                      },
                    );
                  },
                ),
                const SizedBox(),
              ],
            );
          } else
            return const Placeholder();
        }));
  }
}

class FarmInformationWidget extends StatelessWidget {
  final FarmModel farmModel;
  const FarmInformationWidget({
    super.key,
    required this.farmModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(
          (255 * 0.2).toInt(),
          240,
          241,
          245,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0XFFE8E9EE),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(
        16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,

            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddFarmInformationItem(
                title: "Название фермы",
                value: farmModel.name!,
              ),
              const SizedBox(
                height: 24,
              ),
              AddFarmInformationItem(
                title: "Площадь",
                value: farmModel.area.toString(),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddFarmInformationItem(
                title: "БИН",
                value: farmModel.bin!,
              ),
              const SizedBox(
                height: 24,
              ),
              AddFarmInformationItem(
                title: "Номер",
                value: farmModel.phone!,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,

            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddFarmInformationItem(
                title: "Область/Район",
                value:
                    farmModel.regionName != null ? farmModel.regionName! : "",
              ),
              const SizedBox(
                height: 24,
              ),
              const AddFarmInformationItem(
                title: "Пароль",
                value: "Aa1234567",
              ),
            ],
          ),
          AddFarmInformationItem(
            title: "ФИО",
            value: farmModel.fio!,
          ),
        ],
      ),
    );
  }
}

class AddFarmInformationItem extends StatelessWidget {
  final String title;
  final String value;
  const AddFarmInformationItem({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Color(
                0XFF667085,
              ),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: const TextStyle(
              color: Color(
                0XFF1C202C,
              ),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

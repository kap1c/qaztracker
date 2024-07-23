import 'dart:developer';

import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core/utils/http_call_util.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/common/widgets/app_snackbar_widget.dart';
import 'package:qaz_tracker/common/widgets/app_text_field_widget.dart';
import 'package:qaz_tracker/common/widgets/drop_down_menu/app_dropdown_menu.dart';
import 'package:qaz_tracker/common/widgets/table/ui/table.dart';
import 'package:qaz_tracker/config/network/exception/global_app_exception.dart';
import 'package:qaz_tracker/config/network/repository/network_service_repository.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/constants/app_global_regex_consts.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/data/auth/model/manager_model.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';
import 'package:qaz_tracker/features/presentation/profile/ui/widgets/profile_exit_dialog_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ValueNotifier<dynamic> selectedValue = ValueNotifier<dynamic>(null);
  QazTrackerApiService _apiService = locator();

  ValueNotifier<Map<String, dynamic>> fetchProfiles = ValueNotifier({});
  ValueNotifier<Map<String, dynamic>> fetchRegions = ValueNotifier({});
  ValueNotifier<Map<String, dynamic>> fetchAnimalTypes = ValueNotifier({});

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _tabController!.addListener(() {
      setState(() {});
    });
    selectedValue.addListener(() {
      log("selected value value is: ${selectedValue.value}");
    });
    super.initState();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              children: [
                const Text(
                  "Настройки",
                  style: TextStyle(
                    color: AppColors.secondaryBlackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                _tabController!.index == 0
                    ? Material(
                        child: AppMainButtonWidget(
                          verticalPadding: 10,
                          horizontalPadding: 16,
                          text: "Создать менеджера",
                          textColor: Colors.white,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CreateUserDialog(
                                  isEdit: false,
                                  fetchManagers: fetchProfiles,
                                );
                              },
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          TabBar(
            indicatorColor: const Color(0XFF3772FF),
            labelStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Color(
                0XFF3772FF,
              ),
            ), //For Selected tab
            unselectedLabelStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Color(
                0XFF667085,
              ),
            ),
            isScrollable: true,
            tabs: [
              Tab(
                child: Text("Пользователи",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: _tabController!.index == 0
                          ? const Color(0XFF3772FF)
                          : const Color(
                              0XFF667085,
                            ),
                    )),
              ),
              Tab(
                child: Text("Справочники",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: _tabController!.index == 1
                          ? const Color(0XFF3772FF)
                          : const Color(
                              0XFF667085,
                            ),
                    )),
              ),
            ],
            controller: _tabController,
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CustomTable(
                  category: "manager",
                  isEditable: true,
                  valueListenable: selectedValue,
                  queryParams: fetchProfiles,
                  callbackEdit: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateUserDialog(
                          isEdit: true,
                          managerModel: selectedValue.value,
                          fetchManagers: fetchProfiles,
                        );
                      },
                    );
                  },
                  callbackDelete: () {
                    showExitCupertinoDialog(
                      context: context,
                      title: "Удаление менеджера",
                      description: "Вы уверены, что хотите удалить менеджера? ",
                      actionText: "Удалить",
                      onExit: () {
                        safeApiCallWithError(
                            _apiService.deleteManager(
                                managerId: selectedValue.value.id), (p0) {
                          fetchProfiles.value = {};
                          fetchProfiles.notifyListeners();
                          Navigator.of(context).pop();
                        }, (error, defaultError, code) {
                          showCustomFlashBar(
                              text: error["message"],
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
                ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CreateRegionDialog(
                                        isEdit: false,
                                        fetchRegions: fetchRegions,
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "Добавить область",
                                  style: TextStyle(
                                      color: Color(0XFF3772FF),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              // ValueListenableBuilder<dynamic>(
                              //     valueListenable: selectedValue,
                              //     builder: (BuildContext context, dynamic value,
                              //         Widget? child) {
                              //       return
                              CustomTable(
                                category: "regions",
                                isEditable: true,
                                valueListenable: selectedValue,
                                queryParams: fetchRegions,
                                callbackEdit: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CreateRegionDialog(
                                        isEdit: true,
                                        regionName: selectedValue.value.name,
                                        regionId: selectedValue.value.id,
                                        fetchRegions: fetchRegions,
                                      );
                                    },
                                  );
                                },
                                callbackDelete: () {
                                  showExitCupertinoDialog(
                                      context: context,
                                      title: "Удаление области",
                                      description:
                                          "Вы уверены, что хотите удалить область? ",
                                      actionText: "Удалить",
                                      onExit: () {
                                        safeApiCallWithError(
                                            _apiService.deleteRegion(
                                                regionId: selectedValue
                                                    .value.id), (p0) {
                                          fetchRegions.value = {};
                                          Navigator.of(context).pop();
                                          showCustomFlashBar(
                                            context: context,
                                            text: "Область удалена",
                                            color: AppColors.primaryGreenColor,
                                          );
                                        }, (error, defaultError, code) {
                                          Navigator.of(context).pop();

                                          showCustomFlashBar(
                                              text: error["message"],
                                              color: AppColors.primaryRedColor,
                                              context: context);
                                          return HttpExceptionData(
                                              status: code,
                                              detail: error['message']);
                                        });

                                        // show bar that shpw that some params are empty
                                      });
                                },
                              )
                              // }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CreateBreedDialog(
                                          fetchAnimalTypes: fetchAnimalTypes,
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Добавить породу",
                                    style: TextStyle(
                                        color: Color(0XFF3772FF),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                              const SizedBox(
                                height: 16,
                              ),
                              ValueListenableBuilder<dynamic>(
                                  valueListenable: selectedValue,
                                  builder: (BuildContext context, dynamic value,
                                      Widget? child) {
                                    return CustomTable(
                                      category: "breeds",
                                      isEditable: true,
                                      queryParams: fetchAnimalTypes,
                                      valueListenable: selectedValue,
                                      callbackEdit: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CreateBreedDialog(
                                              isEdit: true,
                                              breedModel: selectedValue.value,
                                              fetchAnimalTypes:
                                                  fetchAnimalTypes,
                                            );
                                          },
                                        );
                                      },
                                      callbackDelete: () {
                                        showExitCupertinoDialog(
                                            context: context,
                                            title: "Удаление породы",
                                            description:
                                                "Вы уверены, что хотите удалить породу? ",
                                            actionText: "Удалить",
                                            onExit: () {
                                              safeApiCallWithError(
                                                  _apiService.deleteAnimalBreed(
                                                      breedId: selectedValue
                                                          .value.id), (p0) {
                                                // fetch breed list
                                                fetchAnimalTypes.value = {};
                                                fetchAnimalTypes
                                                    .notifyListeners();
                                                Navigator.of(context).pop();
                                              }, (error, defaultError, code) {
                                                return HttpExceptionData(
                                                    status: code,
                                                    detail: error['message']);
                                              });

                                              // show bar that shpw that some params are empty
                                            });
                                      },
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreateUserDialog extends StatefulWidget {
  String? managerName;
  String? managerSurname;
  String? managerPhone;
  String? managerPassword;

  ManagerModel? managerModel;

  bool isEdit;
  ValueNotifier<Map<String, dynamic>> fetchManagers;
  CreateUserDialog({
    super.key,
    this.managerName,
    this.managerSurname,
    this.managerPhone,
    this.managerPassword,
    this.isEdit = false,
    required this.fetchManagers,
    this.managerModel,
  });

  @override
  _CreateUserDialogState createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  QazTrackerApiService? _apiService;

  final MaskTextInputFormatter _phoneController = MaskTextInputFormatter(
      mask: GlobalRegexConstants.phoneMask,
      filter: {"#": GlobalRegexConstants.digitRegex});
  bool selectedManager = false;
  @override
  void initState() {
    _apiService = locator<QazTrackerApiService>();
    if (widget.managerModel != null) {
      widget.managerName = widget.managerModel!.fio;
      widget.managerSurname = widget.managerModel!.fio;
      widget.managerPhone = widget.managerModel!.phone;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  widget.isEdit
                      ? "Редактирование менеджера"
                      : "Добавление менеджера",
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
                      color: AppColors.secondaryTextFieldBorderColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 16, color: AppColors.secondaryBlackColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Имя"),
                      const SizedBox(height: 8.0),
                      AppTextFieldWidget(
                        initialValue: widget.managerName,
                        onChanged: (value) {
                          setState(
                            () {
                              widget.managerName = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Фамилия"),
                      const SizedBox(height: 8.0),
                      AppTextFieldWidget(
                        initialValue: widget.managerSurname,
                        onChanged: (value) {
                          setState(() {
                            widget.managerSurname = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Телефон"),
                      const SizedBox(height: 8.0),
                      AppTextFieldWidget(
                        onChanged: (value) {
                          setState(() {
                            final phoneNumber =
                                _phoneController.getUnmaskedText();
                            widget.managerPhone = phoneNumber;
                          });
                        },
                        initialValue: widget.managerPhone,
                        keyboardType: TextInputType.number,
                        hint: "+7",
                        inputFormatters: [_phoneController],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Пароль"),
                      const SizedBox(height: 8.0),
                      AppTextFieldWidget(
                        initialValue: widget.managerPassword,
                        onChanged: (value) {
                          setState(() {
                            widget.managerPassword = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            widget.isEdit == false
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      const Text("Роль"),
                      const SizedBox(height: 8.0),
                      AppDropDownMenu(
                        isMultiSelect: false,
                        hintText: "",
                        items: [
                          // DropDownItemModel(title: "Админ", value: "admin"),
                          DropDownItemModel(
                              isSelected: selectedManager,
                              title: "Менеджер",
                              value: "manager",
                              onSelected: () {
                                selectedManager = !selectedManager;
                              }),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
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
                    borderColor: AppColors.secondaryTextFieldBorderColor,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: AppMainButtonWidget(
                    onPressed: () {
                      if (widget.isEdit == false &&
                          (widget.managerName != null &&
                              widget.managerSurname != null &&
                              widget.managerPhone != null &&
                              widget.managerPassword != null)) {
                        String phone = removePlusSeven(widget.managerPhone!);
                        safeApiCallWithError(
                            _apiService!.createNewUser(
                              fio: widget.managerName!,
                              phone: "+7${(phone)}",
                              password: widget.managerPassword!,
                            ), (response) {
                          widget.fetchManagers.value = {};
                          Navigator.of(context).pop();
                          showCustomFlashBar(
                              text: 'Пользователь успешно добавлен!',
                              color: AppColors.primaryGreenColor,
                              context: context);
                        }, (error, defaultError, code) {
                          showCustomFlashBar(
                              text: error['message'],
                              color: AppColors.primaryRedColor,
                              context: context);
                          // Navigator.of(context).pop();

                          return HttpExceptionData(
                              status: code, detail: error['message']);
                        });
                      } else if (widget.isEdit == true) {
                        AppCurrentUserEntity user = AppCurrentUserEntity(
                          fio: widget.managerName,
                          phone: widget.managerPhone,
                          newPassword: widget.managerPassword,
                        );

                        safeApiCallWithError(
                            _apiService!.updateManager(
                              appCurrentUserData: user,
                              managerId: widget.managerModel!.id!,
                            ), (response) {
                          Navigator.of(context).pop();
                          widget.fetchManagers.value = {};

                          showCustomFlashBar(
                              text: 'Пользователь успешно обновлен!',
                              color: AppColors.primaryGreenColor,
                              context: context);
                        }, (error, defaultError, code) {
                          return HttpExceptionData(
                              status: code, detail: error['message']);
                        });
                      }
                    },
                    child: Text(widget.isEdit ? 'Сохранить' : "Добавить"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateBreedDialog extends StatefulWidget {
  bool isEdit = false;
  Breed? breedModel;
  // String? breedName;
  // int? selectedAnimalType = 1;
  bool isLoading = false;
  ValueNotifier<Map<String, dynamic>> fetchAnimalTypes;

  CreateBreedDialog({
    super.key,
    this.isEdit = false,
    // this.breedName,
    this.breedModel,
    required this.fetchAnimalTypes,
    // this.selectedAnimalType,
  });

  @override
  State<CreateBreedDialog> createState() => _CreateBreedDialogState();
}

class _CreateBreedDialogState extends State<CreateBreedDialog> {
  QazTrackerApiService _apiService = locator();
  List<Breed> animalBreedList = [];

  @override
  void initState() {
    if (widget.breedModel == null) {
      widget.breedModel = Breed(
        name: "",
        animalTypeId: 0,
        id: 0,
      );
    }

    widget.isLoading = true;
    safeApiCallWithError(_apiService.getKRSTypes(1, 100), (response) {
      List<Breed> _animalBreedsFromJson = [];
      response["items"].forEach((element) {
        _animalBreedsFromJson.add(Breed.fromJson(element));
      });

      setState(() {
        widget.isLoading = false;
        animalBreedList = _animalBreedsFromJson;
      });
    }, (error, defaultError, code) {
      setState(() {
        widget.isLoading = false;
      });
      return HttpExceptionData(status: code, detail: error['message']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        width: MediaQuery.of(context).size.width * 0.5,
        child: widget.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Добавление породы",
                        style: TextStyle(
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
                            color: AppColors.secondaryTextFieldBorderColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 16, color: AppColors.secondaryBlackColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  const Text("Порода"),
                  const SizedBox(height: 8.0),
                  AppTextFieldWidget(
                    initialValue: widget.breedModel!.name,
                    onChanged: (value) {
                      widget.breedModel!.name = value;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  widget.isEdit == false ? const Text("Тип") : const SizedBox(),
                  widget.isEdit == false
                      ? const SizedBox(height: 8.0)
                      : const SizedBox(),
                  widget.isEdit == false
                      ? AppDropDownMenu(
                          hintText: "",
                          isMultiSelect: false,
                          items: animalBreedList.map((e) {
                            return DropDownItemModel(
                                title: e.name!,
                                value: e.id,
                                isSelected: e.isSelected!,
                                onSelected: () => {
                                      setState(() {
                                        widget.breedModel!.animalTypeId = e.id;
                                        widget.breedModel!.isSelected = true;
                                      })
                                    });
                          }).toList(),
                        )
                      : const SizedBox(),
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
                          borderColor: AppColors.secondaryTextFieldBorderColor,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: AppMainButtonWidget(
                          onPressed: () {
                            if (widget.breedModel!.name != null &&
                                widget.breedModel!.animalTypeId != null) {
                              safeApiCallWithError(
                                  _apiService.createAnimalBreed(
                                      name: widget.breedModel!.name,
                                      animalType: widget
                                          .breedModel!.animalTypeId), (p0) {
                                // fetch breed list
                                Navigator.of(context).pop();
                                widget.fetchAnimalTypes.value = {};
                                showCustomFlashBar(
                                    text: 'Порода успешно добавленa!',
                                    color: AppColors.primaryGreenColor,
                                    context: context);
                              }, (error, defaultError, code) {
                                Navigator.of(context).pop();

                                showCustomFlashBar(
                                    text: 'Ошибка при добавлении породы!',
                                    color: AppColors.primaryRedColor,
                                    context: context);
                                return HttpExceptionData(
                                    status: code, detail: error['message']);
                              });
                            } else if (widget.isEdit) {
                              safeApiCallWithError(
                                  _apiService.updateAnimalBreed(
                                    name: widget.breedModel!.name!,
                                    animalTypeId: widget
                                        .breedModel!.animalTypeIdFromTable,
                                    breedId: widget.breedModel!.id!,
                                  ), (p0) {
                                // fetch breed list
                                Navigator.of(context).pop();
                                widget.fetchAnimalTypes.value = {};
                                showCustomFlashBar(
                                    text: 'Порода успешно обновлена!',
                                    color: AppColors.primaryGreenColor,
                                    context: context);
                              }, (error, defaultError, code) {
                                Navigator.of(context).pop();

                                showCustomFlashBar(
                                    text: 'Ошибка при обновлении породы!',
                                    color: AppColors.primaryRedColor,
                                    context: context);
                                return HttpExceptionData(
                                    status: code, detail: error['message']);
                              });
                            }
                            // show bar that shpw that some params are empty
                          },
                          child: Text(widget.isEdit ? "Сохранить" : 'Добавить'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class CreateRegionDialog extends StatefulWidget {
  String? regionName;
  bool? isEdit;
  int? regionId;
  ValueNotifier<Map<String, dynamic>> fetchRegions;

  CreateRegionDialog(
      {super.key,
      this.regionName,
      this.isEdit = false,
      this.regionId,
      required this.fetchRegions});

  @override
  State<CreateRegionDialog> createState() => _CreateRegionDialogState();
}

class _CreateRegionDialogState extends State<CreateRegionDialog> {
  QazTrackerApiService _apiService = locator();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.isEdit == false
                      ? "Добавление Региона"
                      : "Редактирование Региона",
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
                      color: AppColors.secondaryTextFieldBorderColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 16, color: AppColors.secondaryBlackColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text("Название Региона"),
            const SizedBox(height: 8.0),
            AppTextFieldWidget(
              initialValue: widget.regionName,
              onChanged: (value) {
                setState(() {
                  widget.regionName = value;
                });
              },
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
                    borderColor: AppColors.secondaryTextFieldBorderColor,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: AppMainButtonWidget(
                    onPressed: () {
                      if (widget.isEdit == true) {
                        safeApiCallWithError(
                            _apiService.updateRegion(
                              newRegionName: widget.regionName,
                              regionId: widget.regionId!,
                            ), (p0) {
                          widget.fetchRegions.value = {};
                          Navigator.of(context).pop();
                          showCustomFlashBar(
                              text: 'Область успешно отредактирована!',
                              color: AppColors.primaryGreenColor,
                              context: context);

                          // fetch breed list
                        }, (error, defaultError, code) {
                          Navigator.of(context).pop();

                          showCustomFlashBar(
                              text: 'Ошибка при добавлении обновлении региона!',
                              color: AppColors.primaryRedColor,
                              context: context);
                          return HttpExceptionData(
                              status: code, detail: error['message']);
                        });
                        return;
                      } else {
                        if (widget.regionName != null) {
                          safeApiCallWithError(
                              _apiService.createRegion(
                                regionName: widget.regionName,
                              ), (p0) {
                            // fetch breed list
                            widget.fetchRegions.value = {};
                            Navigator.of(context).pop();
                            showCustomFlashBar(
                                text: 'Область успешно добавлена!',
                                color: AppColors.primaryGreenColor,
                                context: context);
                          }, (error, defaultError, code) {
                            Navigator.of(context).pop();

                            showCustomFlashBar(
                                text: 'Ошибка при добавлении региона!',
                                color: AppColors.primaryRedColor,
                                context: context);
                            return HttpExceptionData(
                                status: code, detail: error['message']);
                          });
                        }
                        // show bar that shpw that some params are empty
                      }
                    },
                    child: Text(widget.isEdit! ? "Сохранить" : 'Добавить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}

String removePlusSeven(String input) {
  RegExp regex = RegExp(r'\+7');
  return input.replaceAll(regex, '');
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/presentation/farm/ui/farm_screen.dart';

class DropDownItemModel {
  final String title;
  final dynamic value;
  final bool isSelected;
  final Function? onSelected;

  DropDownItemModel(
      {required this.title,
      required this.value,
      this.onSelected,
      required this.isSelected});
}

class AppDropDownMenu extends StatefulWidget {
  List<DropDownItemModel>? items = [];
  String hintText;
  bool isMultiSelect;
  AppDropDownMenu(
      {Key? key,
      required this.items,
      required this.hintText,
      this.isMultiSelect = true})
      : super(key: key);

  @override
  State<AppDropDownMenu> createState() => _AppDropDownMenuState();
}

class _AppDropDownMenuState extends State<AppDropDownMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ValueNotifier<List<DropDownItemModel>> selectedItems = ValueNotifier([]);
  bool isListVisible = false;

  @override
  void initState() {
    super.initState();
    for (var element in widget.items!) {
      log("element.isSelected ${element.isSelected}");
      if (element.isSelected) {
        selectedItems.value.add(element);
      }
    }
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // _controller.dispose();
    // selectedItems.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DropDownItemModel>(
      child: InputDecorator(
        decoration: InputDecoration(
          isDense: true,
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.secondaryBlackColor,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: AppColors.secondaryTextFieldBorderColor,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.primaryBlueColor),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0XFFE8E9EE),
              width: 1,
            ),
            gapPadding: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                selectedItems.value.isEmpty
                    ? ""
                    : selectedItems.value.map((e) => e.title).join(', '),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (BuildContext context) {
        return widget.items!.map((e) {
          return PopupMenuItem<DropDownItemModel>(
              padding: EdgeInsets.zero,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateLocal) {
                bool isSelected = selectedItems.value.contains(e);
                selectedItems.addListener(() {
                  if (mounted) {
                    setStateLocal(() {
                      isSelected = selectedItems.value.contains(e);
                    });
                    setState(() {
                      isSelected = selectedItems.value.contains(e);
                    });
                  }
                });
                return InkWell(
                  onTap: () {
                    if (mounted) {
                      if (widget.isMultiSelect == true) {
                        setState(() {
                          if (selectedItems.value.contains(e)) {
                            selectedItems.value.remove(e);
                          } else {
                            selectedItems.value.add(e);
                          }
                        });
                        setStateLocal(() {
                          // if (selectedItems.value.contains(e)) {
                          //   selectedItems.value.remove(e);
                          // } else {
                          //   selectedItems.value.add(e);
                          // }
                        });
                      } else {
                        setState(() {
                          selectedItems.value.clear();
                          selectedItems.value.add(e);
                        });
                        setStateLocal(() {
                          // if (selectedItems.value.contains(e)) {
                          //   selectedItems.value.remove(e);
                          // } else {
                          //   selectedItems.value.add(e);
                          // }
                        });
                      }
                      e.onSelected != null ? e.onSelected!() : print("");
                      selectedItems.notifyListeners();
                      // setStateLocal(() {});
                    }
                  },
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: isSelected,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          activeColor: const Color(0XFF2A60F7),
                          
                          onChanged: (newValue) {
                            if (mounted) {
                              if (widget.isMultiSelect == true) {
                                setState(() {
                                  if (selectedItems.value.contains(e)) {
                                    selectedItems.value.remove(e);
                                  } else {
                                    selectedItems.value.add(e);
                                  }
                                });
                                setStateLocal(() {
                                  // if (selectedItems.value.contains(e)) {
                                  //   selectedItems.value.remove(e);
                                  // } else {
                                  //   selectedItems.value.add(e);
                                  // }
                                });
                              } else {
                                setState(() {
                                  selectedItems.value.clear();
                                  selectedItems.value.add(e);
                                });
                                setStateLocal(() {
                                  // if (selectedItems.value.contains(e)) {
                                  //   selectedItems.value.remove(e);
                                  // } else {
                                  //   selectedItems.value.add(e);
                                  // }
                                });
                              }
                              e.onSelected != null
                                  ? e.onSelected!()
                                  : print("");
                              selectedItems.notifyListeners();
                              // setStateLocal(() {});
                            }
                          },
                        ),
                        Text(
                          e.title,
                          style: const TextStyle(
                            color: Color(0XFF32384A),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }));
        }).toList();
      },
    );
  }
}

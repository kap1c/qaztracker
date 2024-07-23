import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class FilterWidget extends StatefulWidget {
  final Widget content;
  ValueNotifier<bool>? shouldNotify;
  FilterWidget({Key? key, required this.content, this.shouldNotify})
      : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onOpened: () {
        if (widget.shouldNotify != null) {
          widget.shouldNotify!.value = true;
          widget.shouldNotify!.notifyListeners();
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      onSelected: (value) {},
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          CustomPopupMenuItem(
            value: 'option1',
            context: context,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      const Text(
                        "Фильтр",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0XFF1C202C),
                          fontWeight: FontWeight.w500,
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
                ),
                const Divider(
                  color: AppColors.secondaryTextFieldBorderColor,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: widget.content,
                ),
              ],
            ),
          ),
        ];
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0XFFE8E9EE),
          ),
        ),
        height: 32,
        width: 32,
        child: const Icon(
          Icons.filter_list_outlined,
          size: 15,
          color: Color(0XFF32384A),
        ),
      ),
    );
  }
}

class CustomPopupMenuItem<T> extends PopupMenuEntry<T> {
  final T value;
  final Widget child;
  final BuildContext context;
  const CustomPopupMenuItem({
    required this.value,
    required this.child,
    required this.context,
  });

  @override
  double get height => MediaQuery.of(context).size.height * 0.7;

  @override
  bool represents(T? value) => value == this.value;

  @override
  CustomPopupMenuItem<T> copyWith(
      {T? newValue, Widget? newChild, BuildContext? context}) {
    return CustomPopupMenuItem<T>(
      value: newValue ?? value,
      context: context ?? this.context,
      child: newChild ?? child,
    );
  }

  @override
  State<CustomPopupMenuItem<T>> createState() => _CustomPopupMenuItemState<T>();
}

class _CustomPopupMenuItemState<T> extends State<CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: widget.child,
    );
  }
}

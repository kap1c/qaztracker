import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qaz_tracker/common/widgets/app_main_button_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

void showExitCupertinoDialog(
    {BuildContext? context,
    Function()? onExit,
    String? title,
    String? description,
    String? actionText}) {
  showCupertinoDialog<void>(
      context: context!,
      builder: (BuildContext context) => CustomAlertDialog(
          actionText: actionText,
          title: title!,
          description: description!,
          onExit: () {
            onExit?.call();
          }));
}

class CustomAlertDialog extends StatelessWidget {
  final Function()? onExit;
  final String? actionText;

  final String? title;
  final String description;

  final Widget? childContent;
  const CustomAlertDialog({
    Key? key,
    this.onExit,
    this.title = '',
    this.description = '',
    this.childContent,
    this.actionText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.profileBgGreyColor,
          ),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(
        24,
      ),
      child: AlertDialog(
          title: Column(
            children: [
              Text(
                title!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0XFF1C202C),
                  fontFamily: "Roboto",
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0XFF1C202C,
                  ),
                  fontFamily: "Roboto",
                ),
              ),
            ],
          ),
          content: childContent,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            AppMainButtonWidget(
              bgColor: Colors.white,
              textColor: AppColors.textGreyColor,
              text: "Отмена",
              borderColor: AppColors.secondaryTextFieldBorderColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              width: 8,
            ),
            AppMainButtonWidget(
              bgColor: AppColors.primaryRedColor,
              borderColor: AppColors.primaryRedColor,
              textColor: Colors.white,
              text: "Подтвердить",
              onPressed: () {
                onExit?.call();
              },
            ),
          ]),
    );
  }
}

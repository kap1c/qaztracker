import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/common/widgets/notification/ui/notification_button.dart';
import 'package:qaz_tracker/di/di_locator.dart';
import 'package:qaz_tracker/features/domain/profile/entity/profile_info_entity.dart';

AppBar getGlobalAppBar({
  AppCurrentUserEntity? userEntity,
  VoidCallback? onTap,
  required ValueNotifier hideControlPanel,
  required BuildContext context,
  required User user
}) {

  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    shape: const Border(
      bottom: BorderSide(
        color: Color(0XFFE8E9EE),
        width: 1,
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () {
          hideControlPanel.value = !hideControlPanel.value;
          hideControlPanel.notifyListeners();
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: hideControlPanel.value == true
                ? MediaQuery.of(context).size.width * 0.05
                : MediaQuery.of(context).size.width * 0.15,
          ),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Color(0XFFE8E9EE),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 8),
            child: Image.asset("assets/images/slider_icon.png"),
          ),
        ),
      ),
      const Spacer(),
      const NotificationWidget(),
      Padding(
        padding: const EdgeInsets.only(right: 44.0, left: 24),
        child: Center(
          child: Text(
            user.role == UserRole.admin ? "Админ" : (user.name!=null?user.name!:""),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        child: Container(
          padding: const EdgeInsets.only(
            left: 26,
            right: 26,
          ),
          margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
          decoration: const BoxDecoration(
            color: Color(0XFF3772FF),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            children: const [
              Icon(Icons.add),
              Text("Новая ферма"),
            ],
          ),
        ),
      ),
    ],
    leading: Container(
      margin: const EdgeInsets.only(
        left: 24,
      ),
      child: Image.asset(
        "assets/images/logo.png",
      ),
    ),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

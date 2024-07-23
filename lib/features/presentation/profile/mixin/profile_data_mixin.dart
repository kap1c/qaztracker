import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

mixin ProfileDataMixin {
  final getProfileActionOptions = [
    ProfileActionData(
        title: 'Оплата',
        icon: const Icon(
          Icons.account_balance_wallet_outlined,
          color: AppColors.secondaryBlackColor,
        )),
    ProfileActionData(
        title: 'Помощь',
        icon: const Icon(
          Icons.help_outline_rounded,
          color: AppColors.secondaryBlackColor,
        )),
    ProfileActionData(
        title: 'Выйти из системы',
        icon: const Icon(Icons.logout_rounded, color: Colors.red)),
    ProfileActionData(
        title: 'Помощь',
        icon: const Icon(
          Icons.help_outline_rounded,
          color: AppColors.secondaryBlackColor,
        )),
  ];
}

class ProfileActionData {
  final Icon? icon;
  final String? title;
  ProfileActionData({this.icon, this.title});
}

import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

mixin HomeDataMixin {
  final getHomeMainCategories = [
    HomeCategoryData(
        icon: "assets/images/farm.png",
        title: 'Фермы',
        amount: 0,
        bgColor: AppColors.secondaryBrownColor),
    HomeCategoryData(
        icon: "assets/images/cow_white.png",
        title: 'КРС',
        amount: 0,
        bgColor: AppColors.secondaryGreenColor),
    HomeCategoryData(
        icon: "assets/images/horse_white.png",
        title: 'Лошадей',
        amount: 0,
        bgColor: AppColors.secondaryOrangeColor),
    HomeCategoryData(
        icon: 'assets/images/goat_white.png',
        title: 'МРС',
        amount: 0,
        bgColor: AppColors.secondaryRedColor),
  ];

  final getHomeStatisticsFilter = [
    HomeCategoryData(
        icon: AppSvgImages.homeGoatIcon,
        title: 'Шаги',
        code: 'steps',
        amount: 0,
        bgColor: AppColors.secondaryRedColor),
    HomeCategoryData(
        icon: AppSvgImages.homeCowIcon,
        title: 'Расстояние',
        amount: 0,
        code: 'gps_range',
        bgColor: AppColors.secondaryGreenColor),
    HomeCategoryData(
        icon: AppSvgImages.homeHorseIcon,
        title: 'Батарея',
        amount: 0,
        code: 'battery',
        bgColor: AppColors.secondaryOrangeColor),
    HomeCategoryData(
        icon: AppSvgImages.homeWifiIcon,
        title: 'Сеть',
        code: 'network',
        amount: 0,
        bgColor: AppColors.secondaryBrownColor),
  ];

  Map<String, String> getHomeFilterRange = {
    'week': 'За неделю',
    'month': 'За месяц',
    'all': 'За весь период',
  };
}

class HomeCategoryData {
  final String? icon;
  final String? title;
  final String? code;
  final int? amount;
  final Color? bgColor;
  HomeCategoryData(
      {this.title, this.code, this.amount, this.icon, this.bgColor});
}

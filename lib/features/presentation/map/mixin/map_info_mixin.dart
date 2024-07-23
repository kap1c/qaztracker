import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/data/map/model/map_item_model.dart';

mixin MapDataMixin {
  final getAnimalCategories = [
    MapDataClass(
        id: 3,
        icon: AppSvgImages.homeGoatIcon,
        title: 'МРС',
        amount: 0,
        code: 'mrs',
        bgColor: AppColors.secondaryRedColor),
    MapDataClass(
        id: 1,
        icon: AppSvgImages.homeCowIcon,
        title: 'КРС',
        amount: 0,
        code: 'krs',
        bgColor: AppColors.secondaryGreenColor),
    MapDataClass(
        id: 2,
        icon: AppSvgImages.homeHorseIcon,
        title: 'Лошадь',
        code: 'horse',
        amount: 0,
        bgColor: AppColors.secondaryOrangeColor),
  ];
}

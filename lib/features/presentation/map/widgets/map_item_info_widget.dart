// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_core/core/abstarct/constant/core_common_contant.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class MapItemInfoWidget extends StatelessWidget {
  const MapItemInfoWidget(
      {super.key, this.title, this.subTitle, this.colorTxt = Colors.black});
  final String? title;
  final String? subTitle;
  final Color colorTxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.bgSecondaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title ?? CoreConstant.empty,
            style:
                const TextStyle(color: AppColors.textGreyColor, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(subTitle ?? CoreConstant.empty,
              style: TextStyle(
                  color: colorTxt, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

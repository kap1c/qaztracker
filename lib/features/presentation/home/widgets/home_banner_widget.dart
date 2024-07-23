import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class HomeBannerWidget extends StatelessWidget {
  const HomeBannerWidget(
      {super.key,
      this.bgColor = AppColors.secondaryRedColor,
      this.amount = 0,
      this.title,
      this.onTap,
      this.iconPath = AppSvgImages.homeGoatIcon});
  final Color? bgColor;
  final String? iconPath;
  final String? title;
  final int? amount;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
                padding: const EdgeInsets.only(left: 1, bottom: 1),
                child: Ink(
                    height: 145,
                    width: 145,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: bgColor),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 17, top: 17),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title!,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            const SizedBox(height: 5),
                            Text(amount?.toString() ?? '0',
                                style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))
                          ]),
                    )))),
        Positioned(
            bottom: 0,
            left: 0,
            child: Container(
                width: 65,
                height: 65,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                        topLeft: Radius.circular(90),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(90)),
                    color: Colors.white),
                child: SvgPicture.asset(iconPath!)))
      ],
    );
  }
}

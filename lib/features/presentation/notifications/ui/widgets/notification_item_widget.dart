// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/features/data/notification/model/notification_model.dart';

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({super.key, this.notificationItemData});
  final NotificationItemData? notificationItemData;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), color: Colors.red),
            child: SvgPicture.asset(AppSvgImages.warningWhiteIc)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(notificationItemData!.message,
                style: const TextStyle(color: Colors.black, fontSize: 16)),
            const SizedBox(height: 5),
            Text(notificationItemData!.createdAt,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        )
      ],
    );
  }
}

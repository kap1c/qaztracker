import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

void showListRegionsBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                width: 100,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                    color: AppColors.secondaryTextFieldBorderColor)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Область',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.all(0),
                    iconSize: 35,
                    icon: const Icon(Icons.cancel_rounded, color: Colors.grey))
              ],
            ),
            ListView.separated(
              itemCount: 5,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1,
                          color: AppColors.secondaryTextFieldBorderColor)),
                  child: Text(
                    'data $index',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 7);
              },
            ),
          ],
        );
      });
}

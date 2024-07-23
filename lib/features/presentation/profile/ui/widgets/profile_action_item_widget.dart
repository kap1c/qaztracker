import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class ProfileActionOptionItemWidget extends StatelessWidget {
  const ProfileActionOptionItemWidget(
      {super.key, this.title, this.child, this.tap});
  final Widget? child;
  final String? title;
  final Function()? tap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: tap,
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: AppColors.textGreyColor.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(8)),
                child: child),
            Padding(
                padding: const EdgeInsets.only(left: 16), child: Text(title!))
          ],
        ));
  }
}

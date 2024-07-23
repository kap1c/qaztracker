import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';
import 'package:qaz_tracker/constants/app_global_consts.dart';
import 'package:qaz_tracker/util/link_launcher_util.dart';

void showProfileSupportDialog(BuildContext context) {
  showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 250),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 350,
          margin: const EdgeInsets.only(bottom: 50, left: 12, right: 12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40)),
          child: Material(
            borderRadius: BorderRadius.circular(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 100,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                        color: AppColors.secondaryTextFieldBorderColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: const EdgeInsets.only(right: 7),
                        iconSize: 35,
                        icon: const Icon(Icons.cancel_rounded,
                            color: Colors.grey))
                  ],
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: AppColors.profileBgGreyColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: const Center(
                      child: Text('☎️', style: TextStyle(fontSize: 32))),
                ),
                const SizedBox(height: 20),
                const Text('Возникли вопросы?',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Мы постараемся решить ваш вопрос',
                    style: TextStyle(fontSize: 16)),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        openExternalLink(AppGlobalConsts.clientPhoneCallLink);
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border:
                                Border.all(width: 1, color: Colors.grey[300]!)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 25),
                        child: const Text('Позвонить в техподдержку',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child);
    },
  );
}

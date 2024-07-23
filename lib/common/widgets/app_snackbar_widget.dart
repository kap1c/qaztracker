import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

/// this is a main method to show notification
void showCustomFlashBar(
    {@required String? text,
    @required Color? color,
    @required BuildContext? context,
    int seconds = 2}) async {
  Flushbar(
          flushbarStyle: FlushbarStyle.GROUNDED,
          icon: const Icon(Icons.info_outline_rounded,
              color: Colors.white, size: 30),
          // reverseAnimationCurve: Curves.easeIn,
          // forwardAnimationCurve: Curves.easeIn,
          backgroundColor: color ?? AppColors.primaryBlueColor,
          flushbarPosition: FlushbarPosition.TOP,
          duration: Duration(seconds: seconds),
          // animationDuration: const Duration(seconds: 3),
          // mainButton:IconButton(onPressed: (){
          //   res.
          // }, icon:const Icon(Icons.close_rounded,color:Colors.white)),
          messageText: Text(text!,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)))
      .show(context!);
}

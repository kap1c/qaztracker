import 'package:flutter/material.dart';
import 'package:qaz_tracker/common/widgets/app_loading_widget.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class AppMainButtonWidget extends StatelessWidget {
  final String? text;
  final Function()? onPressed;
  final Color? bgColor;
  final Color? textColor;
  final Color borderColor;
  final bool isLoading;
  final Widget? child;
  final double? fontSize;
  final double verticalPadding;
  final double horizontalPadding;
  final FontWeight? fontWeight;
  const AppMainButtonWidget(
      {Key? key,
      this.text,
      this.onPressed,
      this.bgColor,
      this.fontSize,
      this.textColor = Colors.white,
      this.borderColor = AppColors.primaryBlueColor,
      this.isLoading = false,
      this.child,
      this.verticalPadding = 10,
      this.fontWeight = FontWeight.w600,
      this.horizontalPadding = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(
            BorderSide(color: borderColor, width: 1,)),
        backgroundColor:
            MaterialStateProperty.all(bgColor ?? AppColors.primaryBlueColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        elevation: MaterialStateProperty.all(0),
        textStyle:
            MaterialStateProperty.all<TextStyle>(TextStyle(color: textColor)),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          child: isLoading
              ? const Center(child: AppLoaderWidget(color: Colors.white))
              : child ??
                  Text(text ?? '',
                      style: TextStyle(
                          fontSize: fontSize ?? 15,
                          color: textColor,
                          fontWeight: fontWeight,
                          overflow: TextOverflow.ellipsis))),
    );
  }
}

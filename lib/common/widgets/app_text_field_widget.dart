// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:qaz_tracker/config/style/app_global_style.dart';

// class AppTextFieldWidget extends StatelessWidget {
//   TextEditingController? textEditingController;
//   final TextInputType? keyboardType;
//   final Function(String?)? onChanged;
//   final String? label;
//   final String? initialValue;
//   final String? hint;
//   final String? helperText;
//   final int? maxLines;
//   final int? maxLength;
//   final String? errorText;
//   final bool readOnly;
//   final Function()? onTap;
//   final Widget? suffixIcon;
//   final bool? isSelected;
//   final List<TextInputFormatter>? inputFormatters;
//   final bool obscureText;
//   final EdgeInsets? contentPadding;
//   AppTextFieldWidget({
//     Key? key,
//     this.textEditingController,
//     this.onChanged,
//     this.keyboardType,
//     this.label,
//     this.hint,
//     this.helperText,
//     this.maxLines,
//     this.maxLength,
//     this.errorText,
//     this.readOnly = false,
//     this.onTap,
//     this.suffixIcon,
//     this.isSelected = false,
//     this.inputFormatters,
//     this.obscureText = false,
//     this.contentPadding =
//         const EdgeInsets.symmetric(vertical: 8, horizontal: 15.0),
//     this.initialValue = '',
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (initialValue != null) {
//       textEditingController = TextEditingController();
//       textEditingController!.text = initialValue!;
//     }
//     return TextField(
//       onTap: onTap,
//       controller: textEditingController,
//       maxLines: maxLines,
//       cursorWidth: 3,
//       cursorRadius: const Radius.circular(3),
//       keyboardType: keyboardType ?? TextInputType.emailAddress,
//       maxLength: maxLength,
//       onChanged: onChanged,
//       obscureText: obscureText,
//       readOnly: readOnly,
//       cursorColor: AppColors.primaryBlueColor,
//       inputFormatters: inputFormatters ?? [],
//       decoration: InputDecoration(
//         enabledBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8)),
//             borderSide:
//                 BorderSide(color: AppColors.secondaryTextFieldBorderColor)),
//         errorBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           borderSide: BorderSide(color: Colors.red),
//         ),
//         disabledBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           borderSide: BorderSide(color: AppColors.primaryBlueColor),
//         ),
//         focusedErrorBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(8)),
//           borderSide: BorderSide(color: Colors.red),
//         ),
//         border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8)),
//             borderSide: BorderSide(color: Colors.teal)),
//         errorText: errorText,
//         hintText: hint,
//         helperText: helperText,
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.grey),
//         helperStyle: const TextStyle(
//           color: Colors.grey,
//           fontWeight: FontWeight.w400,
//           fontSize: 13,
//         ),
//         counterStyle: const TextStyle(color: Colors.grey),
//         hintStyle: const TextStyle(color: Colors.grey),
//         suffixIcon: suffixIcon,
//         contentPadding: contentPadding,
//       ),
//       obscuringCharacter: '*',
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qaz_tracker/config/style/app_global_style.dart';

class AppTextFieldWidget extends StatefulWidget {
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final Function(String?)? onChanged;
  final String? label;
  final String? initialValue;
  final String? hint;
  final String? helperText;
  final int? maxLines;
  final int? maxLength;
  final String? errorText;
  final bool readOnly;
  final Function()? onTap;
  final Widget? suffixIcon;
  final bool? isSelected;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final EdgeInsets? contentPadding;

  const AppTextFieldWidget({
    Key? key,
    this.textEditingController,
    this.onChanged,
    this.keyboardType,
    this.label,
    this.hint,
    this.helperText,
    this.maxLines,
    this.maxLength,
    this.errorText,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.isSelected = false,
    this.inputFormatters,
    this.obscureText = false,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 15.0),
    this.initialValue = '',
  }) : super(key: key);

  @override
  _AppTextFieldWidgetState createState() => _AppTextFieldWidgetState();
}

class _AppTextFieldWidgetState extends State<AppTextFieldWidget> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.textEditingController ??
        TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: widget.onTap,
      controller: _textEditingController,
      maxLines: widget.maxLines,
      cursorWidth: 3,
      cursorRadius: const Radius.circular(3),
      keyboardType: widget.keyboardType ?? TextInputType.emailAddress,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      cursorColor: AppColors.primaryBlueColor,
      inputFormatters: widget.inputFormatters ?? [],
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.secondaryTextFieldBorderColor),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primaryBlueColor),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.teal),
        ),
        errorText: widget.errorText,
        hintText: widget.hint,
        helperText: widget.helperText,
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.grey),
        helperStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        counterStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: widget.suffixIcon,
        contentPadding: widget.contentPadding,
      ),
      
      obscuringCharacter: '*',
    );
  }
}

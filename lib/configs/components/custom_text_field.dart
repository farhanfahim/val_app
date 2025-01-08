import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../color/colors.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  String? hint;
  TextInputType textInputType = TextInputType.none;
  TextInputAction textInputAction = TextInputAction.done;
  TextEditingController? txtController; // = TextEditingController();
  final FormFieldValidator? validatorFtn;
  final Function? onEditComplete;
  final Function(String)? onFieldSubmit;
  final String Function(String?)? onChangeFtn;
  String value = "";
  String? prefixText;
  double? width;
  double? hintFontSize;
  int? maxLength;
  FocusNode? node;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffixIcon2;
  final String? errorText;
  bool isPass = false;
  bool isCentered = false;
  bool readOnly = false;
  Color focusColor;
  Color? fillColor;
  Function()? onTap;
  Color? hintColor = const Color(0xFFFFFFFF).withOpacity(0.5);
  int? maxLines = 1;
  List<TextInputFormatter>? inputFormat;
  Function()? onTapPass;
  String? initialValue;
  final bool? enabled;
  final bool obscure;
  double padding;
  double borderRadius;
  Color textFieldColor;
  AutovalidateMode autoValidateMode;
  int minLines;
  Widget? suffixWidget;
  Color? cursorColor;
  String? counterText;
  bool showMaxLength;
  EdgeInsetsGeometry? contentPadding;
  Color? enableBorderColor;
  VoidCallback? onSend;
  double? suffixPadding;
  bool autofocus;
  CustomTextField({
    super.key,
    this.hint,
    this.onSend,
    this.node,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIcon2,
    this.hintFontSize = 12,
    this.textFieldColor = AppColors.blackColor,
    this.readOnly = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.isPass = false,
    this.obscure = false,
    this.onEditComplete,
    this.enabled,
    this.width = double.infinity,
    this.maxLines = 1,
    this.padding = 15,
    this.prefixText,
    this.maxLength = 1000,
    this.borderRadius = 9,
    this.errorText,
    this.onFieldSubmit,
    this.onTapPass,
    this.txtController,
    this.validatorFtn,
    this.onChangeFtn,
    this.inputFormat,
    this.focusColor = AppColors.primaryColor,
    this.fillColor,
    this.onTap,
    this.hintColor,
    this.initialValue,
    this.minLines = 1,
    this.suffixWidget,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.cursorColor = AppColors.blackColor,
    this.counterText = '',
    this.showMaxLength = false,
    this.contentPadding,
    this.enableBorderColor,
    this.suffixPadding,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.black,
        ),
        child: TextFormField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          minLines: minLines,
          maxLines: maxLines,
          textCapitalization: TextCapitalization.sentences,
          onTap: onTap,
          maxLength: maxLength!,
          onFieldSubmitted: onFieldSubmit,
          // onEditingComplete: onEditComplete,
          autovalidateMode: autoValidateMode,
          cursorColor: cursorColor,
          enabled: enabled ?? true,
          scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          initialValue: initialValue,
          controller: txtController,
          autofocus: autofocus ?? false,
          obscureText: obscure,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          autocorrect: true,
          focusNode: node,
          inputFormatters: inputFormat ?? const [],
          style: TextStyle(
            fontSize: 13,
            color: textFieldColor,
            fontWeight: FontWeight.normal,
            fontFamily: "Manrope",
          ),
          decoration: InputDecoration(
            counterText: showMaxLength ? null : counterText,
            counterStyle: TextStyle(
              fontFamily: "Manrope",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.grey2.withOpacity(0.8),
            ),
            contentPadding: contentPadding ?? EdgeInsets.all(padding),
            errorText: errorText,
            errorMaxLines: 2,
            prefixText: prefixText,
            prefixStyle: const TextStyle(
              fontFamily: "Manrope",
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
            ),
            suffixIcon: suffixIcon2 ??
                Padding(
                  padding: EdgeInsets.all(suffixPadding ?? 14.0),
                  child: SizedBox(height: 20, width: 20, child: suffixIcon),
                ),
            prefixIcon: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SizedBox(height: 20, width: 20, child: prefixIcon),
                  ),
            filled: true,
            hintText: hint,
            focusColor: focusColor,
            fillColor: fillColor,
            hintStyle: TextStyle(
              fontSize: hintFontSize ?? 14,
              fontWeight: FontWeight.w500,
              fontFamily: "Manrope",
              color: hintColor == null ? AppColors.blackColor.withOpacity(0.5) : hintColor!,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                width: 1,
                color: enableBorderColor ?? AppColors.borderColor.withOpacity(0.4),
                // style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: focusColor,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: Color(0xFFF7F7F7),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: Color(0xFFF7F7F7),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                width: 1,
                color: AppColors.borderColor.withOpacity(0.4),
                style: BorderStyle.none,
              ),
            ),
          ),
          validator: validatorFtn,
          onChanged: onChangeFtn,
          readOnly: readOnly,
        ),
      ),
    );
  }
}

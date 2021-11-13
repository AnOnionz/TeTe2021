import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

@immutable
// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final Function(String)? onSubmit;
  final String? subText;
  final bool? enable;
  final String? hint;
  final FocusNode? thisFocus;
  final FocusNode? nextFocus;
  final TextInputAction? action;
  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final TextInputType? inputType;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatter;
  final Function(String)? onChanged;

  const InputField({Key? key, this.onChanged, this.enable = true, this.onSubmit, this.subText,  this.textAlign , this.controller, this.hint,this.action, this.textCapitalization, this.inputType, this.thisFocus, this.nextFocus, this.inputFormatter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable,
      focusNode: thisFocus,
      textInputAction: action,
      textAlign: textAlign ?? TextAlign.start,
      autofocus: false,
      onFieldSubmitted: nextFocus != null ?  (v) {
        FocusScope.of(context).requestFocus(nextFocus!);
      } : onSubmit,
      controller: controller,
      onChanged: onChanged,
      style: textInput,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      keyboardType: inputType,
      inputFormatters: inputFormatter,
      decoration: InputDecoration(
        suffixText: subText,
        suffixStyle: const TextStyle(color: Colors.black),
        hintText: hint,
        hintStyle: hintText,
        contentPadding: const EdgeInsets.all(15.0),
        filled: true,
        fillColor: enable!= null && enable == false ? const Color(0xFFF0F0F0) : Colors.white,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFC5C5C5), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Color(0xFFC5C5C5), width: 1),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Color(0xFFC5C5C5), width: 1),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gapPadding: double.infinity,
        ),
      ),
    );
  }
}

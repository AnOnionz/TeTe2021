import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/common/constants.dart';
import '../../../../core/common/textfield.dart';

class FormItem extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool? enable;
  final FocusNode? thisFocus;
  final FocusNode? nextFocus;
  final TextInputAction? action;
  final TextInputType? inputType;
  final List<TextInputFormatter> ? inputFormatter;
  final Widget? labelRequired;
  final Function(String)? onChanged;
  final TextEditingController controller;
  const FormItem({Key? key, this.label, this.labelRequired, required this.controller, this.thisFocus, this.nextFocus, this.inputFormatter, this.inputType, this.onChanged, this.action, this.hint, this.enable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        label != null ? Text(label!, style: kStyleBlack16,) : labelRequired ?? const SizedBox(),
        const SizedBox(height: 8,),
        SizedBox(
          height: 40,
          child: InputField(
            enable: enable,
            action: action,
            hint: hint,
            thisFocus: thisFocus,
            nextFocus: nextFocus,
            onChanged: onChanged,
            inputType: inputType,
            textAlign: TextAlign.start,
            inputFormatter: inputFormatter,
            controller: controller,
          ),
        )
      ],
    );
  }
}


// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../constants.dart';

class TimeField extends StatefulWidget {
  final double width;
  final VoidCallback onTap;
  final TextEditingController controller;

  const TimeField({Key? key,  required this.width, required this.onTap, required this.controller})
      : super(key: key);

  @override
  _TimeFieldState createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 44,
        width: widget.width,
        child: TextFormField(
          readOnly: true,
          style: const TextStyle(
              fontSize: 16
          ),
          controller: widget.controller,
          onTap: widget.onTap,
          decoration: InputDecoration(
            filled: true,
            fillColor:  Colors.white,
            contentPadding: const EdgeInsets.all(15),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: kGreyColor.withOpacity(0.3),
                  width: 1,
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: kGreyColor,
                  width: 1,
                )
            ),
            errorBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1,
                )
            ),
          ),
        ),
      ),
    ]);
  }
}

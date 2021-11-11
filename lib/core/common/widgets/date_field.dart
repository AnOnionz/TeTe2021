// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../constants.dart';

class DateField extends StatefulWidget {
  final double width;
  final VoidCallback onTap;
  final TextEditingController controller;

  const DateField({Key? key,  required this.width, required this.onTap, required this.controller})
      : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              suffixIcon: const Icon(Icons.date_range_outlined, size: 25, color: Colors.black45,),
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
      ]),
    );
  }
}

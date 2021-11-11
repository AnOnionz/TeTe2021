import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';


class DropdownField extends StatefulWidget {
  final List<dynamic> items;
  final Function(String value) onSelected;
  final int? initIndex;

  const DropdownField({Key? key, required this.items, required this.onSelected, this.initIndex}) : super(key: key);


  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {

  late List dropdownItemList;

  @override
  void initState() {
    super.initState();
    dropdownItemList = widget.items.map((e) => {'label': e['label'], 'value': e['value']}).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 35,
        child: CoolDropdown(
          dropdownWidth: double.infinity,
          dropdownBoxWidth: 230,
          dropdownItemHeight: 35,
          dropdownBoxHeight: 90,
          triangleWidth: 15,
          triangleHeight: 15,
          gap: 15,
          dropdownTS: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          selectedItemTS: const TextStyle(color: Color(0xFF6FCC76), fontSize: 16, fontWeight: FontWeight.w600),
          unselectedItemTS: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          dropdownBD: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: kGreyColor.withOpacity(0.8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          dropdownList: dropdownItemList,
          dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.black38,),
          onChange: (value){
            widget.onSelected(value['value']);
          },
          defaultValue: widget.initIndex != null ? dropdownItemList[widget.initIndex!] : null,
        ),
      )
    ]);
  }
}
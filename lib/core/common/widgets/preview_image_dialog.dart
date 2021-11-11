import 'dart:io';

import 'package:flutter/material.dart';
class PreviewImageDialog extends StatefulWidget {
  final File image;
  final VoidCallback onTap;
  final String textButton;

  const PreviewImageDialog({Key? key, required this.image,required this.onTap, required this.textButton}) : super(key: key);

  @override
  _PreviewImageDialogState createState() => _PreviewImageDialogState();
}

class _PreviewImageDialogState extends State<PreviewImageDialog> {
  File get _image => widget.image;
  VoidCallback get _event => widget.onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(5),
      children: <Widget>[
        Image.file(
          _image,
          height: MediaQuery.of(context).size.height*.8,
          fit: BoxFit.cover,
        ),
        Row(
          children: <Widget>[
            TextButton(
              child: Text(
                widget.textButton,
                style: const TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
              onPressed: _event,
            ),
            const Spacer(),
            TextButton(
              child: const Text(
                'Đóng',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
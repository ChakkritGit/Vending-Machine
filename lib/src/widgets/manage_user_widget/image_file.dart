import 'dart:io';
import 'package:flutter/material.dart';

class ImageFile extends StatelessWidget {
  final String? file;

  const ImageFile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.file(
        File(file!),
        scale: 1.0,
        width: 100.0,
        height: 100.0,
        fit: BoxFit.contain,
      ),
    );
  }
}

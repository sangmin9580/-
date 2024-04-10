import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/constants/sizes.dart';

class Avatar extends ConsumerWidget {
  const Avatar({super.key});

  static bool _isPickerActive = false;

  Future<void> _onAvatarTap() async {
    if (_isPickerActive) {
      return;
    }
    _isPickerActive = true;

    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );

    _isPickerActive = false;
    if (xFile != null) {
      final file = File(xFile.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _onAvatarTap,
          child: const CircleAvatar(
            radius: 40,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const FaIcon(
              FontAwesomeIcons.camera,
              size: Sizes.size16,
            ),
          ),
        ),
      ],
    );
  }
}

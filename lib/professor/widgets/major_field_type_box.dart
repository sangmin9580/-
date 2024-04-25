import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class MajorFieldTypeBox extends StatelessWidget {
  const MajorFieldTypeBox({
    super.key,
    required this.icon,
    required this.text,
  });
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(
          icon,
          size: Sizes.size16,
        ),
        Gaps.v10,
        Text(
          text,
          style: const TextStyle(
            fontSize: Sizes.size12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

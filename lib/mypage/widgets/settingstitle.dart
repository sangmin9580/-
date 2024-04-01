import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class Settingstile extends StatelessWidget {
  const Settingstile({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
        ),
        Gaps.h14,
        const FaIcon(
          FontAwesomeIcons.chevronRight,
          size: Sizes.size12,
        )
      ],
    );
  }
}

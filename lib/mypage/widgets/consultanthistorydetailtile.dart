import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class ConsultantHistoryDetailTile extends StatelessWidget {
  const ConsultantHistoryDetailTile({
    super.key,
    required this.text,
    required this.count,
  });

  final String text;
  final int count;

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
        Row(
          children: [
            Text(
              "$count",
              style: const TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.h14,
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size12,
            )
          ],
        )
      ],
    );
  }
}

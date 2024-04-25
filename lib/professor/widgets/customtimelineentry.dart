import 'package:flutter/material.dart';
import 'package:project/constants/sizes.dart';

class CustomTimelineEntry extends StatelessWidget {
  final String timeline;
  final String description;

  const CustomTimelineEntry({
    super.key,
    required this.timeline,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size6,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              timeline,
              style: const TextStyle(
                fontSize: Sizes.size12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const VerticalDivider(
              color: Colors.black87,
              thickness: 2,
              indent: 4,
              endIndent: 5,
              width: 20,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: Sizes.size12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

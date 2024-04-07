
import 'package:flutter/material.dart';

class PricelistContent extends StatelessWidget {
  const PricelistContent({
    super.key,
    this.subject = "",
    required this.content,
    required this.price,
  });

  final String subject;
  final String content;

  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subject,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
          ),
        ),
      ],
    );
  }
}

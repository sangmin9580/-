import 'package:flutter/material.dart';

class CharacterRequirementText extends StatelessWidget {
  final int characterCount;
  final Color starColor;

  const CharacterRequirementText({
    Key? key,
    required this.characterCount,
    this.starColor = const Color(0xFFC78D20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "($characterCount자 이상",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
          TextSpan(
            text: "*",
            style: TextStyle(
              fontSize: 20,
              color: starColor,
            ),
          ),
          TextSpan(
            text: ")",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

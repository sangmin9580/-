import 'package:flutter/material.dart';
import 'package:project/constants/sizes.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.disabled,
  });

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 300,
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: Sizes.size60,
      decoration: BoxDecoration(
        color: disabled ? Colors.grey.shade300 : const Color(0xFFC78D20),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Text(
        "다음",
        style: TextStyle(
          color: disabled ? Colors.grey.shade400 : Colors.white,
          fontSize: Sizes.size16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

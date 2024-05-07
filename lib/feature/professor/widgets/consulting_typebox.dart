import 'package:flutter/material.dart';

class ConsultingTypeBox extends StatelessWidget {
  final String type;
  final String selectedType;
  final VoidCallback onTap;

  const ConsultingTypeBox({
    super.key,
    required this.type,
    required this.selectedType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, // 적절한 너비 설정
      height: 30,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: selectedType == type ? Colors.blue : Colors.white,
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: selectedType == type ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

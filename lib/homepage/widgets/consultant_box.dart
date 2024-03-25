import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/gaps.dart';

class ConsultantBox extends ConsumerWidget {
  const ConsultantBox({
    super.key,
    required this.consultantclass,
    required this.title,
    required this.name,
    required this.count,
  });

  final String consultantclass;
  final String title;
  final String name;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 1, // Divider의 너비를 지정합니다. 실제로는 구분선의 좌우 패딩을 포함한 전체 너비입니다.
            thickness: 0.3, // 구분선의 두께를 지정합니다.
            color: Colors.grey.shade300,
            indent: 5,
            endIndent: 10, // 구분선의 색상을 지정합니다.
          ),
          Gaps.v5,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                consultantclass,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(
                    0xFFC78D20,
                  ),
                ),
              ),
              Gaps.h5,
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          Gaps.v5,
          Text(
            "$name 전문가 등 답변 $count개",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          Gaps.v10,
        ],
      ),
    );
  }
}

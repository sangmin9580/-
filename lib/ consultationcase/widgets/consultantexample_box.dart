import 'package:flutter/material.dart';
import 'package:project/constants/gaps.dart';

class ConsultantExampleBox extends StatelessWidget {
  const ConsultantExampleBox({
    super.key,
    required this.consultantclass,
    required this.title,
    required this.name,
    required this.detail,
    required this.count,
    required this.time,
    required this.views,
    required this.onTap,
  });

  final String consultantclass;
  final String title;
  final String name;
  final String detail;
  final int views;
  final int count;
  final int time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v5,
          Text(
            consultantclass,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
          ),
          Gaps.v10,
          Text(
            title,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize),
          ),
          Gaps.v10,
          Row(
            children: [
              const Text(
                "답변",
                style: TextStyle(
                  color: Color(
                    0xFFC78D20,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.h5,
              Text(
                "$name 전문가",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Gaps.v5,
          Text(
            detail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Gaps.v7,
          Text(
            "다른 전문가 답변 $count개",
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          Gaps.v20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  children: [
                    const TextSpan(text: "조회수 "),
                    TextSpan(
                      text: "$views",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                "$time분 전 답변 작성됨",
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          Gaps.v20,
        ],
      ),
    );
  }
}

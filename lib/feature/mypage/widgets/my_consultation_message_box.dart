import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';

class MyConsultationMessageBox extends StatelessWidget {
  const MyConsultationMessageBox({
    super.key,
    required this.consultantclass,
    required this.title,
    required this.detail,
    required this.count,
    required this.time,
    required this.views,
    required this.onTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  final String consultantclass;
  final String title;

  final String detail;
  final int views;
  final int count;
  final String time;
  final VoidCallback onTap;
  final VoidCallback onEditTap, onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                consultantclass,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEditTap,
                    child: Text(
                      "수정하기",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                      ),
                    ),
                  ),
                  Gaps.h10,
                  GestureDetector(
                    onTap: onDeleteTap,
                    child: Text(
                      "삭제하기",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Gaps.v10,
          Text(
            title,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize),
          ),
          Gaps.v10,
          Text(
            detail,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Gaps.v7,
          Text(
            "전문가 $count명이 답변하였습니다.",
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
                "$time 질문 작성됨",
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          Gaps.v20,
          defaultVericalDivider,
        ],
      ),
    );
  }
}

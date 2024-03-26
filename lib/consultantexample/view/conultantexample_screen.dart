import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/consultantexample/widgets/consultantexample_box.dart';

class ConsultantExampleScreen extends ConsumerWidget {
  const ConsultantExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v20,
                Text(
                  "나와 비슷한 문제에 대한",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "해결책을 알아보세요",
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v32,
              ],
            ),
          ),
          Divider(
            height: 2,
            thickness: 5,
            indent: 0,
            endIndent: 0,
            color: Colors.grey.shade300,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Row(
              children: [
                Text("최신 답변순"),
                Gaps.h10,
                Text("최신 질문순"),
                Gaps.h10,
                Text("조회순"),
              ],
            ),
          ),
          defaultVericalDivider,
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: ListView.builder(
              shrinkWrap: true, // 여기를 추가하세요
              physics: const NeverScrollableScrollPhysics(), // 그리고 여기도 추가하세요
              itemCount: 10,
              itemBuilder: (context, index) => const ConsultantExampleBox(
                consultantclass: "고소/소송절차",
                title: "항소재판 변호사 선임과 징역형 상담",
                name: "윤상민",
                detail:
                    "1. 항소심에서 적극적으로 양형사유를 개진하고, 성실한 자세로 재판에 임하여 집행유예를 목표로 집중해야할 것으로 사람잉머리ㅓㅣㅏㅓㄴ",
                count: 3,
                time: 30,
                views: 16,
              ),
            ),
          ),
          defaultVericalDivider,
        ],
      ),
    );
  }
}

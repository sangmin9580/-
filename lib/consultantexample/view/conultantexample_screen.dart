import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v5,
                Text(
                  "고소/소송절차",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  ),
                ),
                Gaps.v10,
                Text(
                  "항소재판 변호사 선임과 징역형 상담",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize),
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
                      "윤상민 전문가",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Gaps.v5,
                const Text(
                  "1. 항소심에서 적극적으로 양형사유를 개진하고, 성실한 자세로 재판에 임하여 집행유예를 목표로 집중해야할 것으로 사람잉머리ㅓㅣㅏㅓㄴ",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.v7,
                Text(
                  "다른 전문가 답변 3개",
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
                            text: "16",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "30분 전 답변 작성됨",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Gaps.v20,
              ],
            ),
          ),
          defaultVericalDivider,
        ],
      ),
    );
  }
}

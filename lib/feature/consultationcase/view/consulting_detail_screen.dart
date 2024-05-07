import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/feature/consultationcase/viewmodel/consultingexample_vm.dart';

import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class ConsultingDetailScreen extends ConsumerWidget {
  const ConsultingDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(ref.read(screenProvider.notifier).state);
    final List<String> answers = ["1"]; // 전문가들의 답변 목록

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          ref.read(screenProvider.notifier).state = false; // 상태를 false로 업데이트
          return true; // 시스템에 의해 화면이 종료될 수 있도록 허용
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                height: 2,
                thickness: 5,
                indent: 0,
                endIndent: 0,
                color: Colors.grey.shade300,
              ),
              defaultVericalDivider,
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: ListView.builder(
                  shrinkWrap: true, // 여기를 추가하세요
                  physics:
                      const NeverScrollableScrollPhysics(), // 그리고 여기도 추가하세요
                  itemCount: answers.length + 1, // 질문 1개 + 답변 개수
                  itemBuilder: (context, index) {
                    // 첫 번째 항목으로 질문을 표시
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref.read(screenProvider.notifier).state = false;
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.chevronLeft,
                                    size: Sizes.size16,
                                  ),
                                  Gaps.h10,
                                  Text(
                                    "뒤로가기",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gaps.v20,
                          Text(
                            "consultantclass",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .fontSize,
                            ),
                          ),
                          Gaps.v10,
                          Text(
                            "title",
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize,
                            ),
                          ),
                          Gaps.v10,
                          Gaps.v5,
                          const Text(
                            "detail",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gaps.v40,
                          Row(
                            children: [
                              Text(
                                "time분 전 작성됨 /",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .fontSize,
                                ),
                              ),
                              Gaps.h5,
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .fontSize,
                                  ),
                                  children: [
                                    const TextSpan(text: "조회수 "),
                                    TextSpan(
                                      text: "views",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .fontSize,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gaps.v60,
                          defaultVericalDivider,
                          Gaps.v20,
                        ],
                      );
                    }
                    // 이후 항목으로 답변을 표시
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: Sizes.size80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade200,
                            ),
                            color: Colors.grey.shade50,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                    ),
                                    Gaps.h20,
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "법무법인 오른",
                                          style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .fontSize,
                                          ),
                                        ),
                                        Gaps.v5,
                                        const Text("백창협 변호사"),
                                      ],
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      color: Colors.red,
                                    ),
                                    height: Sizes.size44,
                                    width: Sizes.size80,
                                    child: const Text(
                                      "상담 예약",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Gaps.v20,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("답변"),
                            Gaps.v40,
                            Text(
                              "time분 전 작성됨",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .fontSize,
                              ),
                            ),
                            Gaps.v60,
                            defaultVericalDivider,
                            Gaps.v20,
                          ],
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

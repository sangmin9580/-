import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/homepage/widgets/apply_button.dart';
import 'package:project/feature/homepage/widgets/consultant_box.dart';

class HomepageScreen extends ConsumerWidget {
  const HomepageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size18,
        vertical: Sizes.size20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              ref
                  .read(mainNavigationViewModelProvider.notifier)
                  .setNavigationBarSelectedIndex(1);

              return;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size10,
                horizontal: Sizes.size10,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 1,
                  color: const Color(0xFFE6C483),
                ),
              ),
              child: const Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Color(0xFFE6C483),
                  ),
                  Gaps.h20,
                  Text(
                    "도움이 필요하신가요?",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: Sizes.size16,
                    ),
                  )
                ],
              ),
            ),
          ),
          // TextField(
          //   decoration: InputDecoration(
          //     fillColor: Colors.white,
          //     prefixIcon: const Padding(
          //       padding: EdgeInsets.symmetric(
          //         vertical: Sizes.size14,
          //         horizontal: Sizes.size10,
          //       ),
          //       child: FaIcon(
          //         FontAwesomeIcons.magnifyingGlass,
          //         color: Color(0xFFE6C483),
          //       ),
          //     ),
          //     contentPadding: const EdgeInsets.symmetric(
          //       vertical: Sizes.size14,
          //       horizontal: Sizes.size10,
          //     ),
          //     hintText: "도움이 필요하신가요?",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(
          //         20,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: const BorderSide(
          //           color: Color(
          //             0xFFC78D20,
          //           ),
          //           width: 2.0),
          //       borderRadius: BorderRadius.circular(22),
          //     ),
          //     // 입력 필드가 활성화되었을 때(선택되었을 때)의 테두리 스타일을 설정할 수 있습니다.
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: const BorderSide(
          //           color: Color(
          //             0xFFE6C483,
          //           ),
          //           width: 1.0),
          //       borderRadius: BorderRadius.circular(22),
          //     ),
          //   ),
          // ),
          Gaps.v20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  ref
                      .read(mainNavigationViewModelProvider.notifier)
                      .setTabBarSelectedIndex(2);
                  print("903");
                },
                child: const ApplyButton(
                  text: "상담예약",
                  icon: FontAwesomeIcons.calendarCheck,
                ),
              ),
              GestureDetector(
                onTap: () => ref
                    .read(mainNavigationViewModelProvider.notifier)
                    .setNavigationBarSelectedIndex(2),
                child: const ApplyButton(
                  text: "상담글 작성",
                  icon: FontAwesomeIcons.filePen,
                ),
              ),
            ],
          ),
          Gaps.v32,
          Row(
            children: [
              Text(
                "최신 상담글",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.h5,
              FaIcon(
                FontAwesomeIcons.chevronRight,
                size: Theme.of(context).textTheme.titleMedium!.fontSize,
              ),
            ],
          ),
          Gaps.v10,
          const ConsultantBox(
            consultantclass: "기본 훈련",
            title: "포메라니안 배변 훈련에 대한 기본 문의",
            name: "윤상민",
            count: 5,
          ),
          const ConsultantBox(
            consultantclass: "극기 훈련",
            title: "강아지 대회에 앞선 극기 훈련 스케줄표",
            name: "김상민",
            count: 2,
          ),
          const ConsultantBox(
            consultantclass: "복종 훈련",
            title: "진돗개 복종 훈련에 대한 기본 문의",
            name: "최상민",
            count: 11,
          ),
          const ConsultantBox(
            consultantclass: "피지컬 훈련",
            title: "롤 훈련에 대한 기본 문의",
            name: "백상민",
            count: 5,
          ),
          Gaps.v20,
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                ref
                    .read(mainNavigationViewModelProvider.notifier)
                    .setTabBarSelectedIndex(1);
              },
              child: Container(
                alignment: Alignment.center,
                height: size.width * 0.15,
                width: size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
                child: Text(
                  "최신 상담글 더 보기",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

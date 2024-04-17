import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:project/constants/default.dart';

import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/mypage/view/pet_navigation_screen.dart';
import 'package:project/mypage/view/setting_screen.dart';
import 'package:project/mypage/viewmodel/mypage_vm.dart';
import 'package:project/mypage/widgets/consultanthistorydetailtile.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  static const routeURL = "/mypage";
  static const routeName = 'mypage';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  void _onSettingTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingScreen(),
      ),
    );
  }

  void onEditPetTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetNavigationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: ref.read(mypageViewModelProvider.notifier).gotoHomeScreen,
              child: const SizedBox(
                width: Sizes.size32,
                child: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  size: Sizes.size20,
                ),
              ),
            ),
            const Text(
              "마이페이지",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Text(
                "내 정보 수정",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  color: Colors.grey.shade500,
                ),
              ),
              Gaps.h10,
              GestureDetector(
                onTap: _onSettingTap,
                child: FaIcon(
                  FontAwesomeIcons.gear,
                  size: Sizes.size20,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          Gaps.h20,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: Sizes.size24,
                    ),
                    Gaps.h10,
                    Text("닉네임"),
                  ],
                ),
                GestureDetector(
                  onTap: onEditPetTap,
                  child: Text(
                    "우리집 댕댕이 정보 편집",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
            Gaps.v32,
            const Text(
              "내 상담내역",
              style: TextStyle(
                fontSize: Sizes.size18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v20,
            const ConsultantHistoryDetailTile(
              text: "10분 전화상담",
              count: 0,
            ),
            Gaps.v20,
            const ConsultantHistoryDetailTile(
              text: "고객직접 30분 방문상담",
              count: 0,
            ),
            Gaps.v20,
            const ConsultantHistoryDetailTile(
              text: "전문가 30분 방문상담",
              count: 0,
            ),
            Gaps.v20,
            const ConsultantHistoryDetailTile(
              text: "작성한 온라인 상담글",
              count: 0,
            ),
            Gaps.v32,
          ],
        ),
      ),
    );
  }
}

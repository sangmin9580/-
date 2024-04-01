import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/mypage/view/notification_screen.dart';
import 'package:project/mypage/widgets/settingstitle.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  void _notificationTap(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationScreen(),
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "설정",
          style: TextStyle(
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          FaIcon(
            FontAwesomeIcons.house,
            size: Sizes.size20,
          ),
          Gaps.h20,
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "앱 설정",
                style: TextStyle(
                  fontSize: Sizes.size18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v20,
              GestureDetector(
                onTap: () => showAboutDialog(
                    context: context,
                    applicationVersion: "Application version 1.0",
                    applicationLegalese:
                        "All rights reseverd. Please dont copy me."),
                child: const Settingstile(
                  text: "앱 정보",
                ),
              ),
              Gaps.v20,
              const Settingstile(
                text: "이용약관",
              ),
              Gaps.v20,
              GestureDetector(
                onTap: () => _notificationTap(context),
                child: const Settingstile(
                  text: "알림 및 이용 설정",
                ),
              ),
              Gaps.v20,
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        "로그아웃하시겠습니까?",
                        style: TextStyle(
                          fontSize: Sizes.size20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("아니오"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("로그아웃"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Settingstile(
                  text: "로그아웃",
                ),
              ),
              Gaps.v20,
              defaultVericalDivider,
              Gaps.v20,
              const Text(
                "고객센터",
                style: TextStyle(
                  fontSize: Sizes.size18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v32,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  color: const Color(
                    0xFFBCBCA8,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.4,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "고객센터 안내사항",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.size16,
                        ),
                      ),
                      Gaps.v14,
                      Padding(
                        padding: EdgeInsets.only(
                          left: Sizes.size2,
                        ),
                        child: Text(
                          "현재 카카오톡 채널을 통해서만 문의를 받고 있습니다. 불편을 드려 죄송합니다.",
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Gaps.v14,
                      DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("카카오톡 채널"),
                                Text(
                                  "이동하기",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

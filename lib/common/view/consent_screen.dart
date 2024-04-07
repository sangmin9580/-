import 'package:flutter/material.dart';
import 'package:project/common/view/main_navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConsentScreen extends ConsumerWidget {
  const ConsentScreen({Key? key}) : super(key: key);

  static const routerURL = "/consent";
  static const routerName = "consent";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consent')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('앱 사용을 위해 다음 사항에 동의해주세요.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 사용자가 동의했다는 것을 SharedPreferences에 저장
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('firstRun', false);

                // GoRouter를 사용하여 앱의 메인 화면으로 이동
                context.goNamed(
                  MainNavigationScreen.routeName,
                ); // 메인 화면의 경로로 설정해야 합니다.
              },
              child: const Text('동의하기'),
            ),
          ],
        ),
      ),
    );
  }
}

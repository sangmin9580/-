import 'package:flutter/material.dart';
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
                try {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('firstRun', false);
                  context.go("/home");
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e')));
                }
              },
              child: const Text('동의하기'),
            ),
          ],
        ),
      ),
    );
  }
}

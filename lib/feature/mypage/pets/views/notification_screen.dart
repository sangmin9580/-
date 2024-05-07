import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/mypage/pets/viewmodel/notification_vm.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "알림 및 이용설정",
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
      body: ListView(
        children: [
          SwitchListTile(
            value: notificationSettings.push,
            onChanged: (value) => ref
                .read(notificationViewModelProvider.notifier)
                .updatePush(value),
            title: const Text("푸시 알림"),
          ),
          SwitchListTile(
            value: notificationSettings.marketing,
            onChanged: (value) => ref
                .read(notificationViewModelProvider.notifier)
                .updateMarketing(value),
            title: const Text("마케팅 정보 알림"),
          ),
          SwitchListTile(
            value: notificationSettings.privacy,
            onChanged: (value) => ref
                .read(notificationViewModelProvider.notifier)
                .updatePrivacy(value),
            title: const Text("개인정보 수집 이용 동의"),
            subtitle: const Text("오직 더 나은 서비스를 위해서만 사용됩니다."),
          ),
        ],
      ),
    );
  }
}

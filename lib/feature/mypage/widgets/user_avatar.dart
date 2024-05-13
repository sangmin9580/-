import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/mypage/users/viewmodel/user_avatar_vm.dart';

class UserAvatar extends ConsumerWidget {
  final bool hasAvatar;
  final String uid;

  const UserAvatar({
    super.key,
    required this.hasAvatar,
    required this.uid,
  });

  static bool _isPickerActive = false;

  Future<void> _onAvatarTap(WidgetRef ref) async {
    print("Tapbadlfjldjfljsdlfj");
    if (_isPickerActive) {
      return;
    }
    _isPickerActive = true;

    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );

    _isPickerActive = false;
    if (xFile != null) {
      final file = File(xFile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return Stack(
      children: [
        GestureDetector(
          onTap: isLoading ? null : () => _onAvatarTap(ref),
          child: isLoading
              ? Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const CircularProgressIndicator(),
                )
              : CircleAvatar(
                  radius: 40,
                  foregroundImage: hasAvatar
                      ? NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-abc-xyz.appspot.com/o/avatars%2F$uid?alt=media&haha=${DateTime.now().toString()}")
                      : null,
                  child: const Text("멍선생"),
                ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const FaIcon(
              FontAwesomeIcons.camera,
              size: Sizes.size16,
            ),
          ),
        ),
      ],
    );
  }
}

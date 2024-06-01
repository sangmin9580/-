import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ?? "Something wen't wrong.",
      ),
    ),
  );
}

String formatRelativeTime(DateTime timestamp) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(timestamp);

  if (difference.inMinutes < 1) {
    return '방금 전';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else if (difference.inDays < 30) {
    return '${difference.inDays}일 전';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()}달 전';
  } else {
    return '${(difference.inDays / 365).floor()}년 전';
  }
}

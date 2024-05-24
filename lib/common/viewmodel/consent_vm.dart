import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsentSomething extends Notifier<void> {
  @override
  void build() {}

  void showAutoCloseDialog(
      {required BuildContext context,
      required String title,
      required String content}) {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 대화상자 외부를 터치해도 닫히지 않도록 설정
      builder: (BuildContext context) {
        // 2초 후에 대화상자 자동 닫기
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true); // 대화상자 닫기
        });

        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}

final consentProvider = NotifierProvider<ConsentSomething, void>(
  () => ConsentSomething(),
);

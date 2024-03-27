import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';

class ConsultationWritingScreen extends ConsumerStatefulWidget {
  const ConsultationWritingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConsultationWritingScreenState();
}

class _ConsultationWritingScreenState
    extends ConsumerState<ConsultationWritingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("상담글 작성"),
        actions: const [Text("등록하기")],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text("제목"),
                Gaps.h5,
                Text("(10자 이상"),
                Text("*"),
                Text(")")
              ],
            ),
          ],
        ),
      ),
    );
  }
}

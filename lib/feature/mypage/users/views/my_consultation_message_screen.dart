import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/default.dart';

import 'package:project/constants/sizes.dart';
import 'package:project/feature/authentication/user/repo/authentication_repo.dart';
import 'package:project/feature/consultationcase/view/edit_consultingwriting_screen.dart';
import 'package:project/feature/mypage/users/viewmodel/my_consultation_messages_vm.dart';
import 'package:project/feature/mypage/users/viewmodel/user_vm.dart';
import 'package:project/feature/mypage/widgets/my_consultation_message_box.dart';
import 'package:project/utils.dart';

class MyConsultationMessages extends ConsumerStatefulWidget {
  const MyConsultationMessages({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyConsultationMessagesState();
}

class _MyConsultationMessagesState
    extends ConsumerState<MyConsultationMessages> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !ref.read(myConsultationListProvider).isLoading &&
        ref.read(myConsultationListProvider.notifier).hasMoreData) {
      ref.read(myConsultationListProvider.notifier).fetchNextPage();
    }
  }

  void _onDeleteTap(String userId, String consultationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("상담 내역 삭제"),
          content: const Text("상담 내역을 삭제하시겠습니까? 삭제된 내역은 복구할 수 없습니다."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 창 닫기
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () async {
                final user = ref.read(authRepo).user;
                if (user != null) {
                  await ref
                      .read(myConsultationListProvider.notifier)
                      .deleteConsultation(user.uid, consultationId, context);
                }
                Navigator.of(context).pop(); // 모달 창 닫기
              },
              child: const Text("삭제"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final myConsultationList = ref.watch(myConsultationListProvider);
    final userProfile = ref.read(usersProvider).value;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "작성한 온라인 상담글",
          style: TextStyle(
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: myConsultationList.when(
        data: (consultations) {
          if (consultations.isEmpty) {
            return const Center(
              child: Text("작성한 상담글이 없습니다.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: consultations.length + 1,
            itemBuilder: (context, index) {
              if (index == consultations.length) {
                return ref.read(myConsultationListProvider).isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }

              final consultation = consultations[index];
              String timeAgo = formatRelativeTime(consultation.timestamp);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: MyConsultationMessageBox(
                  consultantclass: consultation.consultationTopic,
                  title: consultation.title,
                  detail: consultation.description,
                  count: 1,
                  time: timeAgo,
                  views: 1,
                  onTap: () {},
                  onEditTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ConsultationEditScreen(consultation: consultation),
                      ),
                    );
                  },
                  onDeleteTap: () {
                    _onDeleteTap(userProfile!.uid, consultation.consultationId);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(myConsultationListProvider.notifier).refresh(context),
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(
          bottom: Sizes.size12,
          top: Sizes.size12,
        ),
        child: Text(
          "전문가가 답변을 남긴 경우, 수정 및 삭제가 불가능합니다.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

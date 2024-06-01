import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';
import 'package:project/feature/consultationcase/viewmodel/consultingexample_vm.dart';
import 'package:project/feature/consultationcase/widgets/consultantexample_box.dart';
import 'package:project/feature/consultationcase/view/consulting_detail_screen.dart';
import 'package:project/feature/search/viewmodel/search_vm.dart';

class ConsultantExampleScreen extends ConsumerWidget {
  const ConsultantExampleScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultationListState = ref.watch(consultationListProvider);
    final searchState = ref.watch(searchViewModelProvider);

    List<ConsultationWritingModel> consultations = [];

    if (searchState is AsyncData &&
        searchState.value != null &&
        searchState.value!.isNotEmpty) {
      consultations = searchState.value!;
    } else if (consultationListState is AsyncData &&
        consultationListState.value != null) {
      consultations = consultationListState.value!;
    }

    return consultationListState.when(
      data: (consultationData) {
        if (consultations.isEmpty) {
          return const Center(child: Text("작성된 상담글이 없습니다."));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v20,
                    Text(
                      "나와 비슷한 문제에 대한",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "해결책을 알아보세요",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.v32,
                  ],
                ),
              ),
              Divider(
                height: 2,
                thickness: 5,
                indent: 0,
                endIndent: 0,
                color: Colors.grey.shade300,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: Row(
                  children: [
                    Text("최신 답변순"),
                    Gaps.h10,
                    Text("최신 질문순"),
                    Gaps.h10,
                    Text("조회순"),
                  ],
                ),
              ),
              defaultVericalDivider,
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: consultations.length,
                  itemBuilder: (context, index) {
                    final consultation = consultations[index];
                    return ConsultantExampleBox(
                      consultantclass: consultation.consultationTopic,
                      title: consultation.title,
                      name: "윤상민", // 이름은 예시로 작성, 실제 데이터로 변경 필요
                      detail: consultation.description,
                      count: 0,
                      time: 22,
                      views: 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultingDetailScreen(
                              consultantclass: consultation.consultationTopic,
                              title: consultation.title,
                              detail: consultation.description,
                              time: 2,
                              views: 0,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              defaultVericalDivider,
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("오류: $error")),
    );
  }
}

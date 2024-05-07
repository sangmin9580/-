import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';

import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/consultationcase/viewmodel/consultingexample_vm.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';
import 'package:project/feature/mypage/pets/views/addpet_name_screen.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_select_vm.dart';
import 'package:project/feature/mypage/widgets/nextbutton.dart';
import 'package:project/feature/mypage/widgets/petinformationbox.dart';

class PetEditScreen extends ConsumerWidget {
  const PetEditScreen({super.key});

  void onPetAddTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPetNameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petList = ref.watch(petNavigationProvider); // 전체 반려동물 리스트
    final selectedPetIndex = ref.watch(petEditViewModelProvider); // 선택된 반려동물
    bool isPetSelected =
        selectedPetIndex != -1; // Assuming -1 indicates no selection
    final consultationProcessStarted =
        ref.read(consultationProcessStartedProvider);

    return petList.when(
      data: (data) {
        return WillPopScope(
          onWillPop: () async {
            final expertType = ref.read(expertTypeProvider);
            final consultationTopic = ref.read(consultationTopicProvider);

            // 전문가 유형 또는 상담 주제가 선택되지 않았다면 홈 화면으로 돌아감
            if (expertType == null ||
                consultationTopic == null ||
                !consultationProcessStarted) {
              // 홈 화면으로 이동하는 로직
              ref
                  .read(mainNavigationViewModelProvider.notifier)
                  .goToHomePage(context);
              return false; // 기본 뒤로 가기 동작 방지
            }

            // 기본 뒤로 가기 동작 수행
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "반려동물 선택",
                style: appbarTitleStyle,
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Gaps.v20,
                const Text(
                  "어떤 강아지에 대해",
                  style: appbarTitleStyle,
                ),
                const Text(
                  "상담을 받으실 건가요?",
                  style: appbarTitleStyle,
                ),
                Gaps.v20,
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final pet = data[index];
                      return ListTile(
                        leading: Radio<int>(
                          value: index,
                          groupValue: selectedPetIndex,
                          onChanged: (int? value) {
                            if (value != null) {
                              ref
                                  .read(petEditViewModelProvider.notifier)
                                  .selectPet(value);
                            }
                          },
                        ),
                        title: PetInformationBox(
                          name: pet.name,
                          age: pet.getAge(),
                          breed: pet.breed,
                          bio: pet.gender,
                          weight: pet.weight,
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => onPetAddTap(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes.size20,
                    ),
                    child: Text(
                      "추가하기",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      final selectedPetIndex =
                          ref.read(petEditViewModelProvider);

                      if (selectedPetIndex != -1) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        ref
                            .read(mainNavigationViewModelProvider.notifier)
                            .goToConsultingPage();
                        // 상담글 작성 과정 시작
                        ref
                            .read(consultationProcessStartedProvider.notifier)
                            .state = true;
                      }
                    },
                    child: NextButton(
                      disabled: !isPetSelected,
                      text: "강아지 선택하기",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

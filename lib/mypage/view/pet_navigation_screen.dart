import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/mypage/view/addpet_name_screen.dart';
import 'package:project/mypage/viewmodel/pet_navigation_vm.dart';

import 'package:project/mypage/widgets/petinformationbox.dart';

class PetNavigationScreen extends ConsumerWidget {
  const PetNavigationScreen({super.key});

  void onPetInfoTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPetNameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(editModeProvider);
    final selectedItems = ref.read(selectedItemsProvider.notifier).state;
    final petList = ref.watch(petListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "우리집 댕댕이",
          style: appbarTitleStyle,
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newEditMode = !isEditMode;
              final editMode = ref.read(editModeProvider.notifier).state;
              ref.read(editModeProvider.notifier).state = !editMode;
              if (!newEditMode) {
                // 편집 모드를 종료할 때, 선택된 항목들을 초기화합니다.
                ref.read(selectedItemsProvider.notifier).state = [];
              }
            },
            child: Text(
              ref.watch(editModeProvider) ? "완료" : "편집",
              style: appbarActionStyle,
            ),
          ),
          Gaps.h10,
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final isSelected =
                    ref.watch(selectedItemsProvider).contains(index);
                final pet = petList[index];
                return ListTile(
                  onTap: isEditMode
                      ? () {
                          final selectedItems =
                              ref.read(selectedItemsProvider.notifier).state;
                          if (isSelected) {
                            selectedItems.remove(index);
                          } else {
                            selectedItems.add(index);
                          }
                          ref.read(selectedItemsProvider.notifier).state = [
                            ...selectedItems
                          ];
                        }
                      : null,
                  leading: isEditMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value == true) {
                              selectedItems.add(index);
                            } else {
                              selectedItems.remove(index);
                            }
                            ref.read(selectedItemsProvider.notifier).state = [
                              ...selectedItems
                            ];
                          },
                        )
                      : null,
                  title: PetInformationBox(
                    name: pet.name,
                    age: pet.age,
                    kind: pet.kind,
                    bio: pet.bio,
                    weight: pet.weight,
                  ),
                );
              },
              itemCount: petList.length,
            ),
          ),
          GestureDetector(
            onTap: () => onPetInfoTap(context),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: isEditMode && selectedItems.isNotEmpty
                  ? TextButton(
                      onPressed: () {
                        // "삭제하기" 로직 구현
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('삭제를 하시겠습니까?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('예'),
                                  onPressed: () {
                                    // 선택된 항목의 인덱스를 기반으로 실제 항목을 리스트에서 제거
                                    final selectedItems =
                                        ref.read(selectedItemsProvider);
                                    final currentPets = ref
                                        .read(petListProvider.notifier)
                                        .state;
                                    ref.read(petListProvider.notifier).state =
                                        currentPets
                                            .where((pet) =>
                                                !selectedItems.contains(
                                                    currentPets.indexOf(pet)))
                                            .toList();
                                    ref
                                        .read(selectedItemsProvider.notifier)
                                        .state = []; // 선택된 항목 초기화

                                    ref.read(editModeProvider.notifier).state =
                                        false; // 편집 모드 종료
                                    Navigator.of(context).pop(); // 대화 상자 닫기
                                  },
                                ),
                                TextButton(
                                  child: const Text('아니오'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        "삭제하기",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  : isEditMode
                      ? null
                      : const Text(
                          "추가하기",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
            ),
          )
        ],
      ),
    );
  }
}
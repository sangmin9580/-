import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/feature/mypage/pets/model/pet_model.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';

class MypageMoveViewModel extends Notifier<void> {
  @override
  void build() {
    return;
  }

  void gotoHomeScreen() {
    final tabindex = ref.read(mainNavigationViewModelProvider.notifier);
    tabindex.setNavigationBarSelectedIndex(0);
    print("9");
  }

  void goToMyPage(BuildContext context) {
    ref.read(mainNavigationViewModelProvider.notifier).goToMyPage();
    Navigator.of(context).popUntil((route) => route.isFirst);
    resetState();
  }

  void resetState() {
    state = AsyncValue.data(PetModel.empty()); // 초기 상태로 리셋
  }

  void onTapHomeIcon(BuildContext context) {
    final petProfile = ref.read(petCreateForm.notifier).state;
    // MainNavigationViewModel에 접근

    // 입력 중인 상태 확인 (name, breed 등 중 하나라도 값이 있는지 확인)
    bool isInputInProgress = petProfile['name'].isNotEmpty ||
        petProfile['breed'].isNotEmpty; // 더 많은 조건 추가 가능

    if (isInputInProgress) {
      // 모달 창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("알림"),
          content: const Text("지금까지의 내용은 저장되지 않습니다. 계속하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("예"),
              onPressed: () {
                Navigator.of(context).pop(); // 대화상자 닫기
                goToMyPage(context);
                print("1"); // 인덱스 3으로 이동
              },
            ),
            TextButton(
              child: const Text("아니오"),
              onPressed: () => Navigator.of(context).pop(), // 대화상자 닫기
            ),
          ],
        ),
      );
    } else {
      // 입력 중인 상태가 아니라면 바로 인덱스 3으로 이동
      goToMyPage(context);

      print("2");
    }
  }
}

final mypageMoveProvider =
    NotifierProvider<MypageMoveViewModel, void>(() => MypageMoveViewModel());

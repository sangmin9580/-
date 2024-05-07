import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';

class PetSelectViewModel extends Notifier<int> {
  @override
  int build() {
    // 초기에 선택된 반려동물이 없으므로 -1로 설정합니다.
    return -1;
  }

  void selectPet(int index) {
    state = index;
  }

  void petSelect(BuildContext context) {
    ref.read(mainNavigationViewModelProvider.notifier).goToConsultingPage();
    Navigator.of(context).popUntil((route) => route.isFirst);
    ref.read(petSelectionStateProvider.notifier).state = true;
  }
}

final petEditViewModelProvider = NotifierProvider<PetSelectViewModel, int>(
  () {
    return PetSelectViewModel();
  },
);
final petSelectionStateProvider = StateProvider<bool>((ref) => false);

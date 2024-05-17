import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/main_navigation_model.dart';
import 'package:project/common/model/navigation_history_state.dart';
import 'package:project/common/viewmodel/navigation_history_state_vm.dart';

class MainNavigationViewModel extends Notifier<MainNavigationModel> {
  @override
  MainNavigationModel build() {
    return MainNavigationModel();
  }

  void setTabBarSelectedIndex(int index,
      {bool isFromPop = false, bool isInitialSetup = false}) {
    final navHistory = ref.read(navigationHistoryProvider.notifier);
    print(
        "settabBarSelectedIndex called with index: $index, isFromPop: $isFromPop, isInitialSetup: $isInitialSetup");
    if (!isFromPop && !isInitialSetup && state.tabBarSelectedIndex != index) {
      print("isSetUp true인데 호출되냐?");
      navHistory.pushState(NavigationHistyoryStateModel(
          tabIndex: index, navBarIndex: state.navigationBarSelectedIndex));
    }
    state = state.copyWith(tabBarSelectedIndex: index);
    // 탭 컨트롤러의 인덱스 업데이트 로직 통합
    ref.read(tabControllerIndexProvider.notifier).state = index;
    wasProfessorTabPreviouslySelected = (index == 2);
  }

  void setNavigationBarSelectedIndex(int index,
      {bool isFromPop = false, bool isInitialSetup = false}) {
    final navHistory = ref.read(navigationHistoryProvider.notifier);
    print(
        "setNavigationBarSelectedIndex called with index: $index, isFromPop: $isFromPop, isInitialSetup: $isInitialSetup");
    if (state.navigationBarSelectedIndex != index) {
      state = state.copyWith(navigationBarSelectedIndex: index);
    }
    if (!isFromPop && !isInitialSetup) {
      print("isSetUp true인데 호출되냐?");

      navHistory.pushState(NavigationHistyoryStateModel(
          tabIndex: state.tabBarSelectedIndex, navBarIndex: index));
      final navHistoryNewState = ref.read(navigationHistoryProvider);
      print("_navigationHistory nav : $navHistoryNewState");
      print("index : $index, statetab : ${state.tabBarSelectedIndex}");
      print("_navigationHistory nav : ${navHistoryNewState.last.toJson()}");
    }
  }

  bool wasProfessorTabPreviouslySelected = false;

  void setTabFromRoute(
    String tab,
  ) {
    bool isInitialSetup = ref.read(isInitialSetupProvder);
    // 뒤로 가기 상황에서는 특정 로직을 실행하지 않음
    isInitialSetup = true;
    switch (tab) {
      case 'home':
        setTabBarSelectedIndex(0, isInitialSetup: true);
        setNavigationBarSelectedIndex(0, isInitialSetup: true);

        break;
      case 'search':
        setTabBarSelectedIndex(1, isInitialSetup: true);

        break;
      case 'consult':
        setTabBarSelectedIndex(2, isInitialSetup: true);

        break;
      case 'mypage':
        setTabBarSelectedIndex(3, isInitialSetup: true);

        break;
      default:
        setTabBarSelectedIndex(0, isInitialSetup: true);
        print("10");
    }
  }

  void goToHomePage(BuildContext context) {
    setNavigationBarSelectedIndex(0);
    print("5");

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void goToConsultingPage() {
    setNavigationBarSelectedIndex(2);
  }

  void goToMyPage() {
    setNavigationBarSelectedIndex(3); // MyPage의 인덱스를 3으로 설정
  }
}

final mainNavigationViewModelProvider =
    NotifierProvider<MainNavigationViewModel, MainNavigationModel>(
  () => MainNavigationViewModel(),
);

final currentScreenProvider = StateProvider<int>((ref) => 0); // 기본값은 0 (첫 번째 탭)
final tabControllerIndexProvider = StateProvider<int>((ref) => 0);
final isInitialSetupProvder = StateProvider<bool>((ref) => false);

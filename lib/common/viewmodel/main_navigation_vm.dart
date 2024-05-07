import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/main_navigation_model.dart';

class MainNavigationViewModel extends Notifier<MainNavigationModel> {
  @override
  MainNavigationModel build() {
    return MainNavigationModel();
  }

  bool wasProfessorTabPreviouslySelected = false;
  void setTabFromRoute(String tab) {
    print('Received tab parameter: $tab');
    switch (tab) {
      case 'home':
        setTabBarSelectedIndex(0);
        setNavigationBarSelectedIndex(0);
        break;
      case 'search':
        setTabBarSelectedIndex(1);
        break;
      case 'consult':
        setTabBarSelectedIndex(2);
        break;
      case 'mypage':
        setTabBarSelectedIndex(3);
        break;
      default:
        setTabBarSelectedIndex(0);
    }
  }

  void goToHomePage(BuildContext context) {
    setNavigationBarSelectedIndex(0);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void goToConsultingPage() {
    setNavigationBarSelectedIndex(2);
  }

  void goToMyPage() {
    setNavigationBarSelectedIndex(3); // MyPage의 인덱스를 3으로 설정
  }

  void setTabBarSelectedIndex(int index) {
    state = state.copyWith(tabBarSelectedIndex: index);
    // '전문가' 탭 선택 시, wasProfessorTabPreviouslySelected 상태 업데이트
    wasProfessorTabPreviouslySelected = (index == 2);
  }

  void setNavigationBarSelectedIndex(int index) {
    state = state.copyWith(navigationBarSelectedIndex: index);
  }
}

final mainNavigationViewModelProvider =
    NotifierProvider<MainNavigationViewModel, MainNavigationModel>(
  () => MainNavigationViewModel(),
);

final bottomNavigationBarVisibleProvider = StateProvider<bool>((ref) => true);
final currentScreenProvider = StateProvider<int>((ref) => 0); // 기본값은 0 (첫 번째 탭)
final tabControllerIndexProvider = StateProvider<int>((ref) => 0);

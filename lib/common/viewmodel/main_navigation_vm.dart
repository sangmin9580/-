import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/main_navigation_model.dart';

class MainNavigationViewModel extends Notifier<MainNavigationModel> {
  final List<int> _tabHistory = [];
  final List<int> _navigationBarHistory = [];

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
    if (state.tabBarSelectedIndex != index) {
      _tabHistory.add(state.tabBarSelectedIndex); // 이전 인덱스 저장
    }
    state = state.copyWith(tabBarSelectedIndex: index);
    wasProfessorTabPreviouslySelected = (index == 2);
    print(_tabHistory);
  }

  void setNavigationBarSelectedIndex(int index) {
    if (state.navigationBarSelectedIndex != index) {
      _navigationBarHistory.add(state.navigationBarSelectedIndex); // 이전 인덱스 저장
    }
    state = state.copyWith(navigationBarSelectedIndex: index);
    print(_navigationBarHistory);
  }

  int getPreviousTabIndex() {
    if (_tabHistory.isNotEmpty) {
      return _tabHistory.removeLast();
    }
    return -1;
  }

  int getPreviousNavigationBarIndex() {
    if (_navigationBarHistory.isNotEmpty) {
      return _navigationBarHistory.removeLast();
    }
    return -1;
  }
}

final mainNavigationViewModelProvider =
    NotifierProvider<MainNavigationViewModel, MainNavigationModel>(
  () => MainNavigationViewModel(),
);

final bottomNavigationBarVisibleProvider = StateProvider<bool>((ref) => true);
final currentScreenProvider = StateProvider<int>((ref) => 0); // 기본값은 0 (첫 번째 탭)
final tabControllerIndexProvider = StateProvider<int>((ref) => 0);

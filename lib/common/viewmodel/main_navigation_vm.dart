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
    state = state.copyWith(tabBarSelectedIndex: index);
    // '전문가' 탭 선택 시, wasProfessorTabPreviouslySelected 상태 업데이트
    wasProfessorTabPreviouslySelected = (index == 2);
    if (state.tabBarSelectedIndex != index) {
      _tabHistory.add(state.tabBarSelectedIndex); // 이전 인덱스 저장
    }
  }

  void setNavigationBarSelectedIndex(int index) {
    state = state.copyWith(navigationBarSelectedIndex: index);
    if (state.navigationBarSelectedIndex != index) {
      _navigationBarHistory.add(state.navigationBarSelectedIndex); // 이전 인덱스 저장
    }
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

  Future<bool> onWillPop(BuildContext context) async {
    int previousTabIndex = getPreviousTabIndex();
    int previousNavigationBarIndex = getPreviousNavigationBarIndex();

    if (previousTabIndex != -1 || previousNavigationBarIndex != -1) {
      if (previousTabIndex != -1) {
        setTabBarSelectedIndex(previousTabIndex);
      }
      if (previousNavigationBarIndex != -1) {
        setNavigationBarSelectedIndex(previousNavigationBarIndex);
      }
      return false;
    }

    // 앱 종료 여부를 묻는 다이얼로그 표시
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('앱 종료'),
            content: const Text('앱을 종료하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('아니요'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('예'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

final mainNavigationViewModelProvider =
    NotifierProvider<MainNavigationViewModel, MainNavigationModel>(
  () => MainNavigationViewModel(),
);

final bottomNavigationBarVisibleProvider = StateProvider<bool>((ref) => true);
final currentScreenProvider = StateProvider<int>((ref) => 0); // 기본값은 0 (첫 번째 탭)
final tabControllerIndexProvider = StateProvider<int>((ref) => 0);

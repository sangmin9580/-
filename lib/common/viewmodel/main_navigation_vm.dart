import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/main_navigation_model.dart';

class MainNavigationViewModel extends Notifier<MainNavigationModel> {
  final List<int> _tabHistory = [];
  final List<int> _navigationBarHistory = [];

  @override
  MainNavigationModel build() {
    return MainNavigationModel();
  }

  void addTabToHistory(int index) {
    if (_tabHistory.isEmpty || _tabHistory.last != index) {
      _tabHistory.add(index);
    }
  }

  void addNavigationBarToHistory(int index) {
    if (_navigationBarHistory.isEmpty || _navigationBarHistory.last != index) {
      _navigationBarHistory.add(index);
    }
  }

  bool get canPop => _tabHistory.isNotEmpty || _navigationBarHistory.isNotEmpty;
  List<int> get tabHistory => _tabHistory;
  List<int> get navigationBarHistory => _navigationBarHistory;

  int popTabHistory() {
    return _tabHistory.isNotEmpty ? _tabHistory.removeLast() : -1;
  }

  int popNavigationBarHistory() {
    return _navigationBarHistory.isNotEmpty
        ? _navigationBarHistory.removeLast()
        : -1;
  }

  void handlePopScope(bool didPop, BuildContext context) {
    if (!didPop) {
      int previousTabIndex = popTabHistory();
      int previousNavigationBarIndex = popNavigationBarHistory();
      if (previousTabIndex != -1) {
        setTabBarSelectedIndex(previousTabIndex, isFromPop: true);
      }
      if (previousNavigationBarIndex != -1) {
        setNavigationBarSelectedIndex(previousNavigationBarIndex,
            isFromPop: true);
      }
      if (previousTabIndex == -1 && previousNavigationBarIndex == -1) {
        showDialog(
          context: context, // context를 적절히 처리해야 합니다.
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Exit"),
              content: const Text("Do you really want to exit the app?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                )
              ],
            );
          },
        );
      }
    } else {
      // didPop이 true일 때 필요한 로직 추가 (예: 상태 업데이트, 로깅 등)
    }
  }

  bool wasProfessorTabPreviouslySelected = false;
  void setTabFromRoute(String tab) {
    print('Received tab parameter: $tab');
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

  void setTabBarSelectedIndex(int index,
      {bool isFromPop = false, bool isInitialSetup = false}) {
    if (!isFromPop && !isInitialSetup) {
      addTabToHistory(state.tabBarSelectedIndex);
    }
    state = state.copyWith(tabBarSelectedIndex: index);
    wasProfessorTabPreviouslySelected = (index == 2);
  }

  void setNavigationBarSelectedIndex(int index,
      {bool isFromPop = false, bool isInitialSetup = false}) {
    if (!isFromPop && !isInitialSetup) {
      addNavigationBarToHistory(state.navigationBarSelectedIndex);
    }
    state = state.copyWith(navigationBarSelectedIndex: index);
  }
}

final mainNavigationViewModelProvider =
    NotifierProvider<MainNavigationViewModel, MainNavigationModel>(
  () => MainNavigationViewModel(),
);

final currentScreenProvider = StateProvider<int>((ref) => 0); // 기본값은 0 (첫 번째 탭)
final tabControllerIndexProvider = StateProvider<int>((ref) => 0);

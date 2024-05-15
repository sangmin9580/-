import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/main_navigation_model.dart';
import 'package:project/common/widgets/navigation_state.dart';

class MainNavigationViewModel extends Notifier<MainNavigationModel> {
  final List<NavigationState> _navigationHistory = [];
  @override
  MainNavigationModel build() {
    _navigationHistory.add(NavigationState(0, 0));
    return MainNavigationModel();
  }

  void pushNavigationState(int tabIndex, int navBarIndex) {
    _navigationHistory.add(NavigationState(tabIndex, navBarIndex));
  }

  NavigationState popNavigationState() {
    if (_navigationHistory.isNotEmpty) {
      return _navigationHistory.removeLast();
    }
    // 로직에 따라 기본 상태 혹은 오류 처리 반환
    return NavigationState(0, 0); // 안전한 기본 상태 반환
  }

  List<NavigationState> get navigationHistory => _navigationHistory;

  void handlePopScope(bool didPop, BuildContext context) {
    if (_navigationHistory.isNotEmpty) {
      NavigationState previousState = popNavigationState();

      setTabBarSelectedIndex(previousState.tabIndex, isFromPop: true);
      setNavigationBarSelectedIndex(previousState.navBarIndex, isFromPop: true);
    } else {
      // 뒤로 갈 이력이 없을 때의 처리, 예: 앱 종료 확인

      showDialog(
        context: context,
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
  }

  void setTabBarSelectedIndex(int index,
      {bool isFromPop = false, bool isInitialSetup = false}) {
    //print(
    //  "Setting tab index to $index, current index: ${state.tabBarSelectedIndex}");
    if (!isFromPop && !isInitialSetup && state.tabBarSelectedIndex != index) {
      pushNavigationState(index, state.navigationBarSelectedIndex);
      print("index : $index, statenav : ${state.navigationBarSelectedIndex}");
    }
    state = state.copyWith(tabBarSelectedIndex: index);
    // 탭 컨트롤러의 인덱스 업데이트 로직 통합
    ref.read(tabControllerIndexProvider.notifier).state = index;
    wasProfessorTabPreviouslySelected = (index == 2);
  }

  void setNavigationBarSelectedIndex(int index,
      {bool isFromPop = false, bool isInitialSetup = false}) {
    if (!isFromPop && !isInitialSetup) {
      pushNavigationState(state.tabBarSelectedIndex, index);
      print("index : $index, statetab : ${state.tabBarSelectedIndex}");
    }
    state = state.copyWith(navigationBarSelectedIndex: index);
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
}

final mainNavigationViewModelProvider =
    NotifierProvider<MainNavigationViewModel, MainNavigationModel>(
  () => MainNavigationViewModel(),
);

final currentScreenProvider = StateProvider<int>((ref) => 0); // 기본값은 0 (첫 번째 탭)
final tabControllerIndexProvider = StateProvider<int>((ref) => 0);

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/main_navigation_model.dart';
import 'package:project/common/model/navigation_history_state.dart';
import 'package:project/common/viewmodel/navigation_history_state_vm.dart';

class MainNavigationViewModel extends Notifier<MainNavigationModel> {
  late TabController _tabController;

  @override
  MainNavigationModel build() {
    return MainNavigationModel();
  }

  void setTabController(TabController tabController) {
    _tabController = tabController;
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _handleTabIndexChange(_tabController.index);
      }
    });
  }

  void _handleTabIndexChange(int index,
      {bool isFromPop = false, bool isInitialSetup = false}) {
    final navHistory = ref.read(navigationHistoryProvider.notifier);
    if (!isFromPop && !isInitialSetup && state.tabBarSelectedIndex != index) {
      navHistory.pushState(NavigationHistoryStateModel(
          tabIndex: index, navBarIndex: state.navigationBarSelectedIndex));
    }

    print(
        "navHistory : ${ref.read(navigationHistoryProvider).map((e) => e.toJson()).toList()}");
    state = state.copyWith(tabBarSelectedIndex: index);
    wasProfessorTabPreviouslySelected = (index == 2);
  }

  void setTabBarSelectedIndex(int index) {
    print("setTabBarSelectedIndex called with index: $index");
    _tabController.animateTo(index);
    _handleTabIndexChange(index);
  }

  void setTabBarSelectedIndexFromPop(int index) {
    print("setTabBarSelectedIndexFromPop called with index: $index");
    _handleTabIndexChange(index, isFromPop: true);
  }

  void setNavigationBarSelectedIndex(int index,
      {bool isFromPop = false, bool isInitialSetup = false}) {
    print("setNavigationBarSelectedIndex called with index: $index");
    final navHistory = ref.read(navigationHistoryProvider.notifier);
    if (state.navigationBarSelectedIndex != index) {
      state = state.copyWith(navigationBarSelectedIndex: index);
    }
    if (!isFromPop && !isInitialSetup) {
      navHistory.pushState(NavigationHistoryStateModel(
          tabIndex: state.tabBarSelectedIndex, navBarIndex: index));
    }
    ref.read(currentScreenProvider.notifier).state = index;
    print(
        "navHistory : ${ref.read(navigationHistoryProvider).map((e) => e.toJson()).toList()}");
  }

  void handlePop(BuildContext context) {
    final navHistory = ref.read(navigationHistoryProvider.notifier);
    final navHistoryState = ref.read(navigationHistoryProvider);

    ref.read(isPopNavigationMainProvider.notifier).state = true;

    if (navHistoryState.length > 1) {
      final previousState = navHistoryState[navHistoryState.length - 2];
      navHistory.popState();
      print(
        "previousState.tabIndex : ${previousState.tabIndex}, previousState.navBarIndex :${previousState.navBarIndex} ",
      );

      print("Before animateTo in handlePop, index: ${previousState.tabIndex}");
      _tabController.animateTo(previousState.tabIndex);
      print("After animateTo in handlePop, index: ${_tabController.index}");
      setTabBarSelectedIndexFromPop(previousState.tabIndex);
      setNavigationBarSelectedIndex(previousState.navBarIndex, isFromPop: true);

      _tabController.animation!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (ref.read(isPopNavigationMainProvider)) {
            ref.read(isPopNavigationMainProvider.notifier).state = false;
            print(
                "TabController index after animation: ${_tabController.index}");
            print(
                "Current Screen Index: ${ref.read(currentScreenProvider.notifier).state}");
          }
        }
      });
    } else {
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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(isPopNavigationMainProvider.notifier).state = false;
    });
  }

  bool wasProfessorTabPreviouslySelected = false;

  void setTabFromRoute(String tab) {
    if (!ref.read(isInitialSetupProvider)) {
      return;
    }

    ref.read(isInitialSetupProvider.notifier).state = true;

    switch (tab) {
      case 'home':
        print("setTabFromRoute called with tab: home");
        if (ref.read(currentScreenProvider.notifier).state != 2) {
          setTabBarSelectedIndex(0);
          setNavigationBarSelectedIndex(0, isInitialSetup: true);
        }
        break;
      case 'search':
        print("setTabFromRoute called with tab: search");
        setTabBarSelectedIndex(1);
        break;
      case 'consult':
        print("setTabFromRoute called with tab: consult");
        setTabBarSelectedIndex(2);
        break;
      case 'mypage':
        print("setTabFromRoute called with tab: mypage");
        setTabBarSelectedIndex(3);
        break;
      default:
        print("setTabFromRoute called with default tab");
        setTabBarSelectedIndex(0);
    }
  }

  void goToHomePage(BuildContext context) {
    print("goToHomePage called");
    setNavigationBarSelectedIndex(0, isFromPop: true);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void goToConsultingPage() {
    print("goToConsultingPage called");
    setNavigationBarSelectedIndex(2);
  }

  void goToMyPage() {
    print("goToMyPage called");
    setNavigationBarSelectedIndex(3);
  }
}

final mainNavigationViewModelProvider =
    NotifierProvider<MainNavigationViewModel, MainNavigationModel>(
  () => MainNavigationViewModel(),
);

final currentScreenProvider = StateProvider<int>((ref) => 0);
final tabControllerIndexProvider = StateProvider<int>((ref) => 0);
final isInitialSetupProvider = StateProvider<bool>((ref) => false);
final isPopNavigationMainProvider = StateProvider<bool>((ref) => false);
final tabControllerProvider = Provider<TabController>((ref) {
  throw UnimplementedError(
      'TabControllerProvider must be overridden in the widget tree');
});

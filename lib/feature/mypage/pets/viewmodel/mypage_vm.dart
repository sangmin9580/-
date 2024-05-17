import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';

class MypageViewModel extends Notifier<void> {
  @override
  void build() {
    return;
  }

  void gotoHomeScreen() {
    final tabindex = ref.read(mainNavigationViewModelProvider.notifier);
    tabindex.setNavigationBarSelectedIndex(0);
    print("10");
  }
}

final mypageViewModelProvider =
    NotifierProvider<MypageViewModel, void>(() => MypageViewModel());

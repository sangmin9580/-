import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/mypage/model/mypage_model.dart';

class MypageViewModel extends Notifier<MypageModel> {
  @override
  MypageModel build() {
    return MypageModel();
  }

  void gotoHomeScreen() {
    final tabindex = ref.read(mainNavigationViewModelProvider.notifier);
    tabindex.setNavigationBarSelectedIndex(0);
  }
}

final mypageViewModelProvider =
    NotifierProvider<MypageViewModel, MypageModel>(() => MypageViewModel());

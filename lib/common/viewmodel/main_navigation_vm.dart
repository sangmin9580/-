import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/main_navigation_model.dart';

class MainNavigationViewModel extends Notifier<MainNavigationModel> {
  @override
  MainNavigationModel build() {
    return MainNavigationModel();
  }

  void setTabBarSelectedIndex(int index) {
    state = state.copyWith(tabBarSelectedIndex: index);
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

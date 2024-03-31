import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/widgets/model/main_navigation_model.dart';

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

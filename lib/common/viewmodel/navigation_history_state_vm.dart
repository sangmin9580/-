import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/navigation_history_state.dart';

class NavigationHistoryNotifier
    extends Notifier<List<NavigationHistoryStateModel>> {
  @override
  List<NavigationHistoryStateModel> build() {
    // 초기 상태로 NavigationState의 리스트 반환
    return [
      NavigationHistoryStateModel(tabIndex: 0, navBarIndex: 0)
    ]; // 초기 상태 설정
  }

  void pushState(NavigationHistoryStateModel newState) {
    state = [...state, newState];
  }

  void setState(List<NavigationHistoryStateModel> newState) {
    state = List.from(newState);
  }

  NavigationHistoryStateModel popState() {
    if (state.length > 1) {
      var lastState = state.last;
      state = state.sublist(0, state.length - 1);
      return lastState;
    }
    return state.last;
  }

  void removeLastState() {
    if (state.length > 1) {
      state = state.sublist(0, state.length - 1);
    }
  }

  void updateState() {
    state = [...state];
  }
}

// Provider 선언
final navigationHistoryProvider = NotifierProvider<NavigationHistoryNotifier,
    List<NavigationHistoryStateModel>>(
  NavigationHistoryNotifier.new,
);

final isPopNavigationHistoryProvider = StateProvider<bool>((ref) => false);

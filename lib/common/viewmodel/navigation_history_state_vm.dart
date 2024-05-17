import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/navigation_history_state.dart';

class NavigationHistoryNotifier
    extends Notifier<List<NavigationHistyoryStateModel>> {
  @override
  List<NavigationHistyoryStateModel> build() {
    // 초기 상태로 NavigationState의 리스트 반환
    return [
      NavigationHistyoryStateModel(tabIndex: 0, navBarIndex: 0)
    ]; // 초기 상태 설정
  }

  void pushState(NavigationHistyoryStateModel newState) {
    state = [...state, newState];
  }

  void setState(List<NavigationHistyoryStateModel> newState) {
    state = List.from(newState);
  }

  NavigationHistyoryStateModel popState() {
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
    // 마지막 항목이 하나만 남았을 경우 아무것도 하지 않음
  }

  // 상태 업데이트 메서드 추가
  void updateState() {
    state = [...state];
  }
}

// Provider 선언
final navigationHistoryProvider = NotifierProvider<NavigationHistoryNotifier,
    List<NavigationHistyoryStateModel>>(
  NavigationHistoryNotifier.new,
);

final isPopNavigationProvider = StateProvider<bool>((ref) => false);

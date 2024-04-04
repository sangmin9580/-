import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/common/model/search_model.dart';

class SearchViewModel extends Notifier<SearchModel> {
  @override
  SearchModel build() {
    return SearchModel();
  }

  void addSearchTerm(String term) {
    // 새 검색어를 추가하고 상태를 업데이트합니다.
    if (!state.recentSearches.contains(term)) {
      state.recentSearches.insert(0, term);
      state = SearchModel()..recentSearches = List.from(state.recentSearches);
      //SearchModel()는 SearchModel 클래스의 새 인스턴스를 생성합니다.
//..recentSearches = List.from(state.recentSearches)는
//새롭게 생성된 SearchModel 인스턴스의 recentSearches 필드를 설정합니다.
//이때, List.from(state.recentSearches)를 사용하여 기존 상태의 recentSearches
// 리스트를 복사하여 새 리스트를 생성합니다. 이렇게 복사를 하는 이유는 Dart에서
//리스트와 같은 컬렉션은 참조 타입이기 때문에, 단순히 할당(=)을 사용하면 두 변수가 같은 객체를 참조하게 됩니다.
// 즉, 원본 데이터의 불변성을 보장하기 위해 새로운 리스트를 생성하는 것입니다.
    }
  }

  void removeSearchTerm(String term) {
    // 검색어를 삭제하고 상태를 업데이트합니다.
    state.recentSearches.remove(term);
    state = SearchModel()..recentSearches = List.from(state.recentSearches);
  }

  void clearSearchTerms() {
    // 모든 검색어를 삭제하고 상태를 업데이트합니다.
    state = SearchModel()..recentSearches = [];
  }
}

final searchViewModelProvider = NotifierProvider<SearchViewModel, SearchModel>(
  () {
    return SearchViewModel();
  },
);

//final searchFocusNodeProvider = StateProvider<FocusNode?>((ref) => null);
final autoDisposeSearchFocusNodeProvider =
    StateProvider.autoDispose<FocusNode>((ref) {
  return FocusNode();
});

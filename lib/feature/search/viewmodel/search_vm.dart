import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';
import 'package:project/feature/search/repo/search_repo.dart';

class SearchViewModel extends AsyncNotifier<List<ConsultationWritingModel>> {
  late final SearchRepository _repository;
  List<String> recentSearches = [];

  @override
  Future<List<ConsultationWritingModel>> build() async {
    _repository = ref.read(searchRepo);
    return [];
  }

  Future<void> searchConsultations(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final results = _repository.searchConsultations(query);
      return results;
    });
  }

  void addSearchTerm(String term) {
    if (!recentSearches.contains(term)) {
      recentSearches.add(term);
    }
  }

  void removeSearchTerm(String term) {
    recentSearches.remove(term);
  }

  void clearSearchTerms() {
    recentSearches.clear();
  }
}

final searchViewModelProvider =
    AsyncNotifierProvider<SearchViewModel, List<ConsultationWritingModel>>(
  () => SearchViewModel(),
);

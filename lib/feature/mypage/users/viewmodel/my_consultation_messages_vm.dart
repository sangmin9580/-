import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';
import 'package:project/feature/consultationcase/repo/consultation_repo.dart';
import 'package:project/utils.dart';

class MyConsultationListViewModel
    extends AsyncNotifier<List<ConsultationWritingModel>> {
  late final ConsultationRepository _repository;
  List<ConsultationWritingModel> _list = [];
  bool hasMoreData = true; // 데이터가 더 있는지 여부를 표시
  bool isLoading = false;

  Future<List<ConsultationWritingModel>> _fetchConsultations({
    DateTime? lastTimestamp,
  }) async {
    final List<ConsultationWritingModel> consultations =
        await _repository.getConsultations(
      lastTimestamp: lastTimestamp,
    );
    if (consultations.isEmpty) {
      hasMoreData = false;
    }

    return consultations;
  }

  @override
  Future<List<ConsultationWritingModel>> build() async {
    _repository = ref.read(consultationRepo);
    _list = await _fetchConsultations(lastTimestamp: null);
    return _list;
  }

  Future<void> fetchNextPage() async {
    if (_list.isEmpty || !hasMoreData || isLoading) return;

    isLoading = true;
    state = await AsyncValue.guard(() async {
      final nextPage =
          await _fetchConsultations(lastTimestamp: _list.last.timestamp);
      _list.addAll(nextPage);
      return _list;
    });
    isLoading = false;
  }

  Future<void> refresh(BuildContext context) async {
    hasMoreData = true;
    _list = [];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final consultations = await _fetchConsultations(lastTimestamp: null);
      _list = consultations;
      return _list;
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    }
  }

  Future<void> deleteConsultation(
      String userId, String consultationId, BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteConsultation(userId, consultationId);
      _list.removeWhere((c) => c.consultationId == consultationId);
      return _list;
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상담 내역이 삭제되었습니다.')),
      );
    }
  }
}

final myConsultationListProvider = AsyncNotifierProvider<
    MyConsultationListViewModel, List<ConsultationWritingModel>>(
  () => MyConsultationListViewModel(),
);

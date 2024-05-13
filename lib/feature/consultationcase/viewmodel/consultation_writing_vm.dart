import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';
import 'package:project/feature/consultationcase/repo/consultation_repo.dart';

class ConsultationWritingViewModel
    extends AsyncNotifier<ConsultationWritingModel> {
  final ConsultationRepository _repository = ConsultationRepository();

  @override
  FutureOr<ConsultationWritingModel> build() async {
    // 유저가 새로운 상담글을 작성하기 위한 초기 상태
    return ConsultationWritingModel.empty();
  }

// 상태 업데이트 메서드
  void updatePetId(String petId) {
    final currentModel = state.value ?? ConsultationWritingModel.empty();
    state = AsyncValue.data(currentModel.copyWith(petId: petId));
  }

  void updateSpecialty(String specialty) {
    final currentModel = state.value ?? ConsultationWritingModel.empty();
    state = AsyncValue.data(currentModel.copyWith(specialty: specialty));
  }

  void updateTitle(String title) {
    final currentModel = state.value ?? ConsultationWritingModel.empty();
    state = AsyncValue.data(currentModel.copyWith(title: title));
  }

  void updateDescription(String description) {
    final currentModel = state.value ?? ConsultationWritingModel.empty();
    state = AsyncValue.data(currentModel.copyWith(description: description));
  }

  void updatePhotos(List<String> photos) {
    final currentModel = state.value ?? ConsultationWritingModel.empty();
    state = AsyncValue.data(currentModel.copyWith(photos: photos));
  }

  void updateTimestamp(DateTime timestamp) {
    final currentModel = state.value ?? ConsultationWritingModel.empty();
    state = AsyncValue.data(currentModel.copyWith(timestamp: timestamp));
  }

  // 최종 제출 메서드
  Future<void> submitConsultation() async {
    final consultation = state.value ?? ConsultationWritingModel.empty();

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _repository.addConsultation(consultation);
      return ConsultationWritingModel.empty();
    });
  }
}

final consultationProvider = AsyncNotifierProvider<ConsultationWritingViewModel,
    ConsultationWritingModel>(
  () => ConsultationWritingViewModel(),
);

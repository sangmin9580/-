import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/feature/authentication/repo/authentication_repo.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';
import 'package:project/feature/consultationcase/repo/consultation_repo.dart';
import 'package:project/utils.dart';

class ConsultationWritingViewModel extends AsyncNotifier<void> {
  late final ConsultationRepository _repository;

  @override
  FutureOr<void> build() async {
    // 유저가 새로운 상담글을 작성하기 위한 초기 상태
    _repository = ref.read(consultationRepo);
  }

// 상태 업데이트 메서드

  Future<void> submitConsultationWithImages(List<File> images,
      ConsultationWritingModel model, BuildContext context) async {
    final user = ref.read(authRepo).user;
    if (user != null) {
      state = const AsyncValue.loading();

      // 모든 이미지 업로드 및 URL 얻기
      var imageUploadTasks = images.map((image) async {
        String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}";
        return await _repository.uploadImage(image, fileName);
      }).toList();

      // 모든 이미지 업로드 작업 완료 기다림
      state = await AsyncValue.guard(() async {
        List<String> imageUrls =
            await Future.wait(imageUploadTasks); // 모든 이미지 URL을 리스트에 저장

        // 상담글 모델에 이미지 URL 리스트 추가
        var updatedModel = model.copyWith(
            userId: user.uid, photos: imageUrls, timestamp: DateTime.now());

        // Firestore에 상담글 정보 저장
        await _repository.addConsultation(updatedModel, user.uid);
        ref.read(showDialogProvider.notifier).state = true; // 성공 상태 업데이트
      });

      if (state.hasError) {
        // 오류 발생 시 사용자에게 알림
        showFirebaseErrorSnack(context, state.error);
      }
    }
  }
}

final expertTypeProvider = StateProvider<String?>((ref) => null);
final consultationTopicProvider = StateProvider<String?>((ref) => null);
final showDialogProvider = StateProvider<bool>((ref) {
  return false; // 초기값을 false로 설정하여 앱 시작 시 다이얼로그가 표시되지 않도록 함
});
final consultationProvider =
    AsyncNotifierProvider<ConsultationWritingViewModel, void>(
  () => ConsultationWritingViewModel(),
);

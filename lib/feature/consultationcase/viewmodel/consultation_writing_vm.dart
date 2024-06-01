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
      });

      if (state.hasError) {
        // 오류 발생 시 사용자에게 알림
        showFirebaseErrorSnack(context, state.error);
      }
    }
  }

  Future<void> deleteImage(String fileUrl) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.deleteImage(fileUrl);
    });
  }

  // 상담글 개수를 가져오는 메서드 추가
  Future<int> getConsultationCount(String userId) async {
    final consultations = await _repository.getUserConsultations(userId);
    return consultations.length;
  }

  Future<void> deleteConsultation(String userId, String consultationId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteConsultation(userId, consultationId);
    });
  }

  Future<void> updateConsultation(
      {required ConsultationWritingModel model,
      required List<File> newImages,
      required List<String> oldImageUrls,
      required BuildContext context}) async {
    state = const AsyncValue.loading();

    final user = ref.read(authRepo).user;

    // 기존 이미지 삭제
    var deleteTasks = oldImageUrls.map((url) => deleteImage(url)).toList();

    // 새 이미지 업로드
    var uploadTasks = newImages.map((image) async {
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}";
      return await _repository.uploadImage(image, fileName);
    }).toList();

    // 모든 작업 완료 기다림
    state = await AsyncValue.guard(() async {
      // 기존 이미지 삭제 작업 완료
      await Future.wait(deleteTasks);

      // 새 이미지 업로드 작업 완료 및 URL 얻기
      List<String> newImageUrls = await Future.wait(uploadTasks);

      // 상담글 모델에 이미지 URL 리스트 추가
      var updatedModel = model.copyWith(
        photos: newImageUrls,
        timestamp: DateTime.now(),
      );

      // Firestore에 상담글 정보 업데이트
      await _repository.updateConsultation(updatedModel, user!.uid);
    });

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      Navigator.of(context).pop(); // 성공적으로 업데이트 후 화면 닫기
    }
  }
}

final expertTypeProvider = StateProvider<String?>((ref) => null);
final consultationTopicProvider = StateProvider<String?>((ref) => null);
final consultationProvider =
    AsyncNotifierProvider<ConsultationWritingViewModel, void>(
  () => ConsultationWritingViewModel(),
);

final consultationCountProvider = FutureProvider<int>((ref) async {
  final user = ref.read(authRepo).user;
  if (user != null) {
    return ref
        .read(consultationProvider.notifier)
        .getConsultationCount(user.uid);
  }
  return 0;
});

// 상담글 시작할 때 처음에는 false임. 왜냐하면 바로 뒤로가기를 눌렀을 때 홈으로 가게하려고.
//다만 true가 되는 경우 전문가와 상담종류 모달창이 나오도록 설정했어. 그렇기 때문에 '강아지 선택하기'를 누르면
//true로 바뀌게 해놨고, 나중에 상담 등록 또는 중간에 상담을 취소하면 해당값을 다시 false로 바꿔야해.
final consultationProcessStartedProvider = StateProvider<bool>((ref) => false);

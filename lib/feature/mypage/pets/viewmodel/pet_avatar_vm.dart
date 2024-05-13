import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/mypage/pets/repo/pet_repo.dart';

class PetAvatarViewModel extends AsyncNotifier<void> {
  late final PetRepository _petRepository;

  @override
  FutureOr<void> build() {
    _petRepository = ref.read(petsInfoProvider);
  }

  Future<void> uploadPetAvatar(String userId, String petId, File file) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        // 기존 petProfile 정보를 가져옵니다.
        final petProfile = await _petRepository.getPetProfile(userId, petId);

        // 이미지를 업로드하는 로직을 구현합니다.
        //await _petRepository.uploadPetAvatar(petProfile.petId, file);

        // ViewModel 또는 기타 상태 갱신 로직
      },
    );
  }
}

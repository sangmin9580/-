import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/authentication/repo/authentication_repo.dart';
import 'package:project/feature/mypage/pets/model/pet_model.dart';
import 'package:project/feature/mypage/pets/repo/pet_repo.dart';

class PetNavigationViewModel extends AsyncNotifier<List<PetModel>> {
  late final PetRepository _petRepository;
  late final AuthenticationRepository _authenticationRepository;
  List<PetModel> _petList = [];

  @override
  FutureOr<List<PetModel>> build() async {
    _petRepository = ref.read(petsInfoProvider);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final userId = _authenticationRepository.user!.uid;
      final petsProfiles =
          await _petRepository.findPetsProfiles(userId: userId);
      _petList = petsProfiles;

      if (_petList.isNotEmpty) {
        return _petList;
      }
      return [];
    }
    return [];
  }

  Future<void> createPetProfile(PetModel petProfile) async {
    final userId = ref.read(authRepo).user!.uid;
    state = const AsyncValue.loading();

    var docRef = await _petRepository.createPetProfile(userId, petProfile);
    PetModel newPetProfile = petProfile.copyWith(
      petId: docRef,
    );
    state = await AsyncValue.guard(() async {
      _petList.add(newPetProfile);
      return List.from(_petList);
    });
  }
}

final petNavigationProvider =
    AsyncNotifierProvider<PetNavigationViewModel, List<PetModel>>(
  () => PetNavigationViewModel(),
);

final petCreateForm = StateProvider<Map<String, dynamic>>((ref) => {});

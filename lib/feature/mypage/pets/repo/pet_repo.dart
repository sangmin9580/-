import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/feature/mypage/pets/model/pet_model.dart';

class PetRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

// 펫 추가
  Future<String> createPetProfile(String userId, PetModel petProfile) async {
    var docRef = _db
        .collection("users")
        .doc(userId)
        .collection('pets')
        .doc(); // 자동 ID 생성
    petProfile = petProfile.copyWith(petId: docRef.id); // PetModel에 ID 설정
    await docRef.set(petProfile.toJson());
    return docRef.id;
  }

  Future<List<PetModel>> findPetsProfiles({required String userId}) async {
    final snapshot =
        await _db.collection('users').doc(userId).collection('pets').get();

    List<PetModel> petsProfiles = snapshot.docs
        .map(
          (profiles) => PetModel.fromJson(
            profiles.data(),
          ),
        )
        .toList();

    return petsProfiles;
  }

  Future<void> updatePetsInfo(
      String uid, String petId, Map<String, dynamic> data) async {
    await _db
        .collection("users")
        .doc(uid)
        .collection('pets')
        .doc(petId)
        .update(data);
  }
}

final petsInfoProvider = Provider((ref) => PetRepository());

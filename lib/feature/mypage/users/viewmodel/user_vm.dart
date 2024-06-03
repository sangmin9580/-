import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/authentication/user/repo/authentication_repo.dart';
import 'package:project/feature/mypage/users/model/user_profile_model.dart';
import 'package:project/feature/mypage/users/repo/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository.findProfile(
        _authenticationRepository.user!.uid,
      );
      if (profile != null) {
        return UserProfileModel.fromJson(
          profile,
        );
      }
    }

    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      hasAvatar: false,
      bio: "undefined",
      link: "undefined",
      email: credential.user!.email ?? "anon@anon.com",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? "Anon",
      address: "",
      detailAddress: "",
      nickName: "",
    );
    await _usersRepository.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> updateCompleteProfile(
      String address, String detailAddress, String nickName) async {
    state = const AsyncValue.loading(); // 상태를 로딩 중으로 설정
    state = await AsyncValue.guard(() async {
      await _usersRepository.updateUser(
        state.value!.uid,
        {
          "address": address,
          "detailAdress": detailAddress,
          "nickName": nickName,
        },
      );
      return state.value!.copyWith(
        address: address,
        detailAddress: detailAddress,
        nickName: nickName,
      );
    });
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

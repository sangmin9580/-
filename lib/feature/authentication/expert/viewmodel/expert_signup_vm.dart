import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/feature/authentication/expert/repo/expert_authrepo.dart';
import 'package:project/utils.dart';

class ExpertSignUpViewModel extends AsyncNotifier<void> {
  late final ExpertAuthenticationRepository _repository;
  late final FirebaseAuth _auth;

  @override
  FutureOr<void> build() {
    _repository = ref.read(expertAuthRepo);
    _auth = FirebaseAuth.instance;
  }

  Future<void> collectAndSignUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required XFile businessLicense,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _repository.saveExpertProfile(
        user: userCredential.user!,
        name: name,
        phoneNumber: phoneNumber,
        businessLicense: businessLicense,
      );
    });

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/expert/approval-pending");
    }
  }
}

final expertSignUpProvider = AsyncNotifierProvider<ExpertSignUpViewModel, void>(
  () => ExpertSignUpViewModel(),
);

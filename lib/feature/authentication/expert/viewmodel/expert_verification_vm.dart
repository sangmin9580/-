import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:project/utils.dart';

class ExpertVerificationViewModel extends AsyncNotifier<void> {
  late final FirebaseAuth _auth;

  @override
  FutureOr<void> build() {
    _auth = FirebaseAuth.instance;
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          context.go("/expert/profile");
        },
        verificationFailed: (FirebaseAuthException e) {
          throw e;
        },
        codeSent: (String verificationId, int? resendToken) {
          context.go("/expert/code-verification", extra: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    }
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      context.go("/expert/profile");
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    }
  }
}

final expertVerificationProvider =
    AsyncNotifierProvider<ExpertVerificationViewModel, void>(
  () => ExpertVerificationViewModel(),
);

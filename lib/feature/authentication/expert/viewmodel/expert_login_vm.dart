import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/feature/authentication/expert/repo/expert_authrepo.dart';
import 'package:project/utils.dart';

class ExpertLoginViewModel extends AsyncNotifier<void> {
  late final ExpertAuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(expertAuthRepo);
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _repository.signIn(email, password),
    );
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/expert/home");
    }
  }
}

final expertLoginProvider = AsyncNotifierProvider<ExpertLoginViewModel, void>(
  () => ExpertLoginViewModel(),
);

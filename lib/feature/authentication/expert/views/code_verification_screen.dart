import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/authentication/expert/viewmodel/expert_verification_vm.dart';

class CodeVerificationScreen extends ConsumerStatefulWidget {
  final String verificationId;

  const CodeVerificationScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState
    extends ConsumerState<CodeVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  void _onSubmitCode(BuildContext context) {
    ref.read(expertVerificationProvider.notifier).signInWithPhoneNumber(
          widget.verificationId,
          _codeController.text,
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Verification Code"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size20),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Verification Code"),
            ),
            const SizedBox(height: Sizes.size20),
            ElevatedButton(
              onPressed: () => _onSubmitCode(context),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

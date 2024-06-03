import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/authentication/expert/viewmodel/expert_signup_vm.dart';
import 'package:project/feature/authentication/expert/viewmodel/expert_verification_vm.dart';

class ExpertVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const ExpertVerificationScreen({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _ExpertVerificationScreenState createState() =>
      _ExpertVerificationScreenState();
}

class _ExpertVerificationScreenState
    extends ConsumerState<ExpertVerificationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  XFile? _businessLicense;
  String? _verificationId;

  void _pickBusinessLicense() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _businessLicense = pickedFile;
    });
  }

  String _formatPhoneNumber(String phoneNumber) {
    // 한국의 국가 코드 +82
    return '+82${phoneNumber.substring(1)}';
  }

  void _sendVerificationCode() {
    final formattedPhoneNumber = _formatPhoneNumber(_phoneController.text);
    ref.read(expertVerificationProvider.notifier).verifyPhoneNumber(
          formattedPhoneNumber,
          context,
        );
  }

  void _onSubmit(BuildContext context) {
    if (_verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify your phone number')),
      );
      return;
    }

    if (_businessLicense == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your business license')),
      );
      return;
    }

    ref.read(expertSignUpProvider.notifier).collectAndSignUp(
          email: widget.email,
          password: widget.password,
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          businessLicense: _businessLicense!,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: Sizes.size20),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: Sizes.size20),
            ElevatedButton(
              onPressed: _sendVerificationCode,
              child: const Text("Send Verification Code"),
            ),
            const SizedBox(height: Sizes.size20),
            ElevatedButton(
              onPressed: _pickBusinessLicense,
              child: const Text("Upload Business License"),
            ),
            if (_businessLicense != null)
              Text("Selected: ${_businessLicense!.name}"),
            const SizedBox(height: Sizes.size20),
            ElevatedButton(
              onPressed: () => _onSubmit(context),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

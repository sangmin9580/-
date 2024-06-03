import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/authentication/expert/views/expert_verification_screen.dart';
import 'package:project/feature/authentication/user/widgets/form_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpertSignUpScreen extends ConsumerStatefulWidget {
  static const routeName = '/expert-signup';

  const ExpertSignUpScreen({Key? key}) : super(key: key);

  @override
  _ExpertSignUpScreenState createState() => _ExpertSignUpScreenState();
}

class _ExpertSignUpScreenState extends ConsumerState<ExpertSignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain letters, numbers, and special characters';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool get _isPasswordLengthValid {
    return _passwordController.text.length >= 8;
  }

  bool get _isPasswordComplexValid {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(_passwordController.text);
  }

  bool get _isFormValid {
    return _formKey.currentState?.validate() ?? false;
  }

  void _onNextTap(BuildContext context) {
    if (_isFormValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExpertVerificationScreen(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expert Sign up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size20),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: _emailValidator,
                ),
                const SizedBox(height: Sizes.size20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: _passwordValidator,
                ),
                const SizedBox(height: Sizes.size10),
                Row(
                  children: [
                    Icon(
                      _isPasswordLengthValid
                          ? FontAwesomeIcons.circleCheck
                          : FontAwesomeIcons.circle,
                      color:
                          _isPasswordLengthValid ? Colors.green : Colors.grey,
                      size: Sizes.size20,
                    ),
                    const SizedBox(width: Sizes.size10),
                    Text(
                      'At least 8 characters',
                      style: TextStyle(
                        color:
                            _isPasswordLengthValid ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.size10),
                Row(
                  children: [
                    Icon(
                      _isPasswordComplexValid
                          ? FontAwesomeIcons.circleCheck
                          : FontAwesomeIcons.circle,
                      color:
                          _isPasswordComplexValid ? Colors.green : Colors.grey,
                      size: Sizes.size20,
                    ),
                    const SizedBox(width: Sizes.size10),
                    Text(
                      'Contains letters, numbers, and special characters',
                      style: TextStyle(
                        color: _isPasswordComplexValid
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.size20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _confirmPasswordValidator,
                ),
                const SizedBox(height: Sizes.size20),
                GestureDetector(
                  onTap: () => _onNextTap(context),
                  child: FormButton(
                    disabled: !_isFormValid,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

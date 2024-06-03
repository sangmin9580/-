import 'package:flutter/material.dart';
import 'package:project/constants/sizes.dart';

class ApprovalPendingScreen extends StatelessWidget {
  const ApprovalPendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approval Pending"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your profile is under review.",
                style: TextStyle(
                    fontSize: Sizes.size24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Sizes.size20),
              const Text(
                "We will notify you once your profile has been approved.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: Sizes.size16),
              ),
              const SizedBox(height: Sizes.size20),
              ElevatedButton(
                onPressed: () {
                  // 홈 화면이나 다른 화면으로 이동할 수 있게 추가 버튼
                },
                child: const Text("Go to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

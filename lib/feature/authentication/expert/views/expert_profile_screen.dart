import 'package:flutter/material.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/authentication/expert/views/approval_appending_screen.dart';

class ExpertProfileScreen extends StatefulWidget {
  const ExpertProfileScreen({Key? key}) : super(key: key);

  @override
  _ExpertProfileScreenState createState() => _ExpertProfileScreenState();
}

class _ExpertProfileScreenState extends State<ExpertProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _specialization = 'Veterinarian'; // Default value

  void _submitProfile() {
    // 전문가 프로필 저장 및 관리자 승인 요청
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApprovalPendingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Expert Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.size20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: "Bio"),
            ),
            TextField(
              controller: _experienceController,
              decoration: const InputDecoration(labelText: "Experience"),
            ),
            TextField(
              controller: _priceController,
              decoration:
                  const InputDecoration(labelText: "Consultation Price"),
            ),
            DropdownButton<String>(
              value: _specialization,
              onChanged: (String? newValue) {
                setState(() {
                  _specialization = newValue!;
                });
              },
              items: <String>['Veterinarian', 'Trainer']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: Sizes.size20),
            ElevatedButton(
              onPressed: _submitProfile,
              child: const Text("Submit Profile for Approval"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ExpertAuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get isLoggedIn => user != null;
  User? get user => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<UserCredential> emailSignUp(String email, String password) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> githubSignIn() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }

  Future<void> saveExpertProfile({
    required User user,
    required String name,
    required String phoneNumber,
    required XFile businessLicense,
  }) async {
    final businessLicenseUrl = await _uploadFile(user.uid, businessLicense);
    await _firestore.collection('experts').doc(user.uid).set({
      'name': name,
      'phoneNumber': phoneNumber,
      'businessLicenseUrl': businessLicenseUrl,
      'email': user.email,
    });
  }

  Future<String> _uploadFile(String userId, XFile file) async {
    // Implement the file upload to Firebase Storage and return the URL
    // This is a placeholder implementation
    final ref = FirebaseStorage.instance
        .ref()
        .child('business_licenses/$userId/${file.name}');
    final uploadTask = ref.putFile(File(file.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

final expertAuthRepo = Provider((ref) => ExpertAuthenticationRepository());

final authState = StreamProvider((ref) {
  final repo = ref.read(expertAuthRepo);
  return repo.authStateChanges();
});

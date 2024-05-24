import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';

class ConsultationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String fileName) async {
    var ref = _storage.ref().child('path/to/images/$fileName');
    var uploadTask = await ref.putFile(image);
    var downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addConsultation(
      ConsultationWritingModel consultation, String userId) async {
    // DocumentReference 설정
    var userConsultationRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('consultations')
        .doc(consultation.consultationId);
    var consultationRef =
        _firestore.collection('consultations').doc(consultation.consultationId);

    await _firestore.runTransaction((transaction) async {
      transaction.set(userConsultationRef, consultation.toJson());
      transaction.set(consultationRef, consultation.toJson());
    }).catchError((error) {
      print('Error adding consultation: $error');
      throw error;
    });
  }
}

final consultationRepo = Provider((ref) => ConsultationRepository());

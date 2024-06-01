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
    });
  }

  Future<void> updateConsultation(
      ConsultationWritingModel updatedModel, String userId) async {
    // 사용자 상담글 참조
    var userConsultationRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('consultations')
        .doc(updatedModel.consultationId);

    // 공개 상담글 참조
    var consultationRef =
        _firestore.collection('consultations').doc(updatedModel.consultationId);

    await _firestore.runTransaction((transaction) async {
      transaction.update(userConsultationRef, updatedModel.toJson());
      transaction.update(consultationRef, updatedModel.toJson());
    });
  }

  Future<void> deleteImage(String fileUrl) async {
    Reference ref = _storage.refFromURL(fileUrl);
    await ref.delete();
  }

  Future<void> deleteConsultation(String userId, String consultationId) async {
    var userConsultationRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('consultations')
        .doc(consultationId);
    var consultationRef =
        _firestore.collection('consultations').doc(consultationId);

    await _firestore.runTransaction((transaction) async {
      transaction.delete(userConsultationRef);
      transaction.delete(consultationRef);
    });
  }

  Future<List<ConsultationWritingModel>> getConsultations({
    DateTime? lastTimestamp,
    int limit = 5,
  }) async {
    Query query = _firestore
        .collection('consultations')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    // 페이지네이션: 마지막 타임스탬프가 제공되면 그 이후의 문서를 조회
    if (lastTimestamp != null) {
      query = query.startAfter([lastTimestamp]);
    }

    final result = await query.get();
    return result.docs.map((doc) {
      return ConsultationWritingModel.fromJson(
          doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // 사용자별 상담글을 가져오는 메서드 추가
  Future<List<ConsultationWritingModel>> getUserConsultations(
      String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('consultations')
        .get();

    return querySnapshot.docs.map((doc) {
      return ConsultationWritingModel.fromJson(doc.data());
    }).toList();
  }
}

final consultationRepo = Provider((ref) => ConsultationRepository());

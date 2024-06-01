import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';

class SearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 기존 메서드들 생략...

  Future<List<ConsultationWritingModel>> searchConsultations(
      String query) async {
    final searchByTitle = await _firestore
        .collection('consultations')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    final searchByConsultant = await _firestore
        .collection('consultations')
        .where('consultantName', isGreaterThanOrEqualTo: query)
        .where('consultantName', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    final results = searchByTitle.docs + searchByConsultant.docs;
    return results
        .map((doc) => ConsultationWritingModel.fromJson(doc.data()))
        .toList();
  }
}

final searchRepo = Provider((ref) => SearchRepository());

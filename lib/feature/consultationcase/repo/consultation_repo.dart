import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';

class ConsultationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addConsultation(ConsultationWritingModel consultation) async {
    await _firestore.collection('consultations').add(consultation.toJson());
  }
}

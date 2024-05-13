import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/consultationcase/model/consultation_expert_type_model.dart';

class ConsultationSelectionViewModel
    extends Notifier<ConsultationExpertTypeModel> {
  @override
  ConsultationExpertTypeModel build() {
    return ConsultationExpertTypeModel();
  }

  void updateExpertType(String expertType) {
    state = state.copyWith(expertType: expertType);
  }

  void updateConsultationTopic(String consultationTopic) {
    state = state.copyWith(consultationTopic: consultationTopic);
  }
}

final consultationSelectionProvider = NotifierProvider<
    ConsultationSelectionViewModel, ConsultationExpertTypeModel>(
  () => ConsultationSelectionViewModel(),
);

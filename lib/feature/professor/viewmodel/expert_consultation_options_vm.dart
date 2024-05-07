import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/professor/model/expert_consultation_options_model.dart';

class ExpertConsultationOptionsViewModel
    extends Notifier<ExpertConsultationOptionsModel> {
  @override
  ExpertConsultationOptionsModel build() {
    return ExpertConsultationOptionsModel.empty();
  }

  void setConsultationTypes(List<String> types) {
    state = state.copyWith(
      availableConsultationTypes: types,
    );
  }

  void setAvailableDates(List<DateTime> dates) {
    state = state.copyWith(
      availableDates: dates,
    );
  }

  void setAvailableTimesPerType(Map<String, List<String>> timesPerType) {
    state = state.copyWith(
      availableTimesPerType: timesPerType,
    );
  }

  void setPricePerType(Map<String, int> pricePerType) {
    state = state.copyWith(
      pricePerType: pricePerType,
    );
  }
}

final expertConsultationOptionsProvider = NotifierProvider<
    ExpertConsultationOptionsViewModel, ExpertConsultationOptionsModel>(
  () => ExpertConsultationOptionsViewModel(),
);

class ExpertConsultationOptionsModel {
  List<String> availableConsultationTypes;
  List<DateTime> availableDates;
  Map<String, List<String>> availableTimesPerType;
  Map<String, int> pricePerType;

  ExpertConsultationOptionsModel({
    required this.availableConsultationTypes,
    required this.availableDates,
    required this.availableTimesPerType,
    required this.pricePerType,
  });

  ExpertConsultationOptionsModel.empty()
      : availableConsultationTypes = [
          "10분 전화상담",
          "30분 고객방문",
          "30분 전문가방문",
        ],
        availableDates = List.generate(
          7,
          (i) => DateTime.now().add(
            Duration(
              days: i,
            ),
          ),
        ),
        availableTimesPerType = {},
        pricePerType = {};

  ExpertConsultationOptionsModel copyWith({
    List<String>? availableConsultationTypes,
    List<DateTime>? availableDates,
    Map<String, List<String>>? availableTimesPerType,
    Map<String, int>? pricePerType,
  }) {
    return ExpertConsultationOptionsModel(
      availableConsultationTypes:
          availableConsultationTypes ?? this.availableConsultationTypes,
      availableDates: availableDates ?? this.availableDates,
      availableTimesPerType:
          availableTimesPerType ?? this.availableTimesPerType,
      pricePerType: pricePerType ?? this.pricePerType,
    );
  }
}

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
        availableTimesPerType = {
          "10분 전화상담": List.generate(48, (index) {
            final hour = (index ~/ 2).toString().padLeft(2, '0');
            final minute = (index % 2 == 0) ? '00' : '30';
            return '$hour:$minute';
          }),
          "30분 고객방문": List.generate(48, (index) {
            final hour = (index ~/ 2).toString().padLeft(2, '0');
            final minute = (index % 2 == 0) ? '00' : '30';
            return '$hour:$minute';
          }),
          "30분 전문가방문": List.generate(48, (index) {
            final hour = (index ~/ 2).toString().padLeft(2, '0');
            final minute = (index % 2 == 0) ? '00' : '30';
            return '$hour:$minute';
          }),
        },
        pricePerType = {
          "10분 전화상담": 20000, // Example price in KRW
          "30분 고객방문": 50000, // Example price in KRW
          "30분 전문가방문": 75000, // Example price in KRW
        };

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

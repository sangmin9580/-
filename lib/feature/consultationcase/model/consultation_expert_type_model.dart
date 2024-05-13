class ConsultationExpertTypeModel {
  final String? expertType;
  final String? consultationTopic;

  ConsultationExpertTypeModel({
    this.expertType,
    this.consultationTopic,
  });

  ConsultationExpertTypeModel copyWith(
      {String? expertType, String? consultationTopic}) {
    return ConsultationExpertTypeModel(
      expertType: expertType ?? this.expertType,
      consultationTopic: consultationTopic ?? this.consultationTopic,
    );
  }
}

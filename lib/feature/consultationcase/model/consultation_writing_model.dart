class ConsultationWritingModel {
  ConsultationWritingModel({
    required this.consultationId,
    required this.petId,
    required this.expertType,
    required this.specialty,
    required this.title,
    required this.description,
    required this.photos,
    required this.timestamp,
  });

  final String consultationId;
  final String petId;
  final String expertType;
  final String specialty; // 상담 분야
  final String title; // 상담 제목
  final String description; // 상담 내용
  final List<String> photos; // URL이나 경로 문자열
  final DateTime timestamp; // 작성 시간

  // 빈 모델
  ConsultationWritingModel.empty()
      : consultationId = "",
        petId = "",
        expertType = "",
        specialty = "",
        title = "",
        description = "",
        photos = [],
        timestamp = DateTime.now();

  // 복사 메서드
  ConsultationWritingModel copyWith({
    String? consultationId,
    String? petId,
    String? expertType,
    String? specialty,
    String? title,
    String? description,
    List<String>? photos,
    DateTime? timestamp,
  }) {
    return ConsultationWritingModel(
      consultationId: consultationId ?? this.consultationId,
      expertType: expertType ?? this.expertType,
      petId: petId ?? this.petId,
      specialty: specialty ?? this.specialty,
      title: title ?? this.title,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      "consultationId": consultationId,
      'petId': petId,
      "expertType": expertType,
      'specialty': specialty,
      'title': title,
      'description': description,
      'photos': photos,
      'timestamp': timestamp,
    };
  }

  // JSON에서 모델 생성
  ConsultationWritingModel.fromJson(Map<String, dynamic> json)
      : consultationId = json['consultationId'],
        expertType = json['expertType'],
        petId = json['petId'],
        specialty = json['specialty'],
        title = json['title'],
        description = json['description'],
        photos = List<String>.from(json['photos']),
        timestamp = json['timestamp'].toDate();
}

/**
 * 
 * 상담 분야 선택: 어떤 전문가 또는 어떤 분야의 전문가에게 상담을 요청할지에 대한 선택 필드가 필요합니다.
상담 제목과 내용: 상담글 작성자 본인이 상담에 대해 기술하고 싶은 내용을 자유롭게 적을 수 있는 필드가 있어야 합니다.
사진 업로드(선택 사항): 문제가 발생한 부위 또는 특이사항을 사진으로 첨부할 수 있는 필드가 있다면 더 자세한 상담이 가능할 것입니다.
 */
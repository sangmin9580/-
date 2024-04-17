class PetModel {
  PetModel({
    required this.id,
    required this.breed,
    required this.name,
    required this.gender,
    required this.isNeutered,
    required this.weight,
    required this.birthDate,
  });

  final String breed;
  final String name;
  final String id;
  final String gender;
  final bool? isNeutered;
  final double weight;
  final DateTime birthDate;

  PetModel.empty()
      : breed = "",
        name = "",
        gender = "",
        isNeutered = null,
        weight = 0,
        birthDate = DateTime.now(),
        id = "";
  PetModel copyWith({
    String? breed,
    String? name,
    String? gender,
    String? id,
    bool? isNeutered,
    double? weight,
    DateTime? birthDate,
  }) {
    return PetModel(
      breed: breed ?? this.breed,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      isNeutered: isNeutered ?? this.isNeutered,
      weight: weight ?? this.weight,
      birthDate: birthDate ?? this.birthDate,
      id: id ?? this.id,
    );
  }

  // 나이 계산 메서드
  String getAge() {
    final today = DateTime.now();
    int years = today.year - birthDate.year;
    int months = today.month - birthDate.month;
    if (months < 0 || (months == 0 && today.day < birthDate.day)) {
      years--;
      months += 12;
    }
    return "$years년 $months개월";
  }
}

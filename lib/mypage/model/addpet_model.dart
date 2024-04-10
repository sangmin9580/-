class AddPetModel {
  AddPetModel({
    required this.breed,
    required this.name,
    required this.gender,
    required this.isNeutered,
    required this.weight,
    required this.birthDate,
  });

  final String breed;
  final String name;
  final String gender;
  final bool? isNeutered;
  final double weight;
  final DateTime birthDate;

  AddPetModel.empty()
      : breed = "",
        name = "",
        gender = "",
        isNeutered = null,
        weight = 0,
        birthDate = DateTime.now();

  AddPetModel copyWith({
    String? breed,
    String? name,
    String? gender,
    bool? isNeutered,
    double? weight,
    DateTime? birthDate,
  }) {
    return AddPetModel(
      breed: breed ?? this.breed,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      isNeutered: isNeutered ?? this.isNeutered,
      weight: weight ?? this.weight,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}

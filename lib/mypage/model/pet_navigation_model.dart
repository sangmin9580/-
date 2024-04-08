class PetNavigationModel {
  final String name;
  final int age;
  final String kind;
  final String bio;
  final String weight;

  PetNavigationModel({
    required this.name,
    required this.age,
    required this.kind,
    required this.bio,
    required this.weight,
  });

  PetNavigationModel.empty()
      : age = 0,
        bio = "남자",
        kind = "포메라니안",
        name = "공멍멍",
        weight = "80";
}

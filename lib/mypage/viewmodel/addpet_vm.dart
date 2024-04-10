import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/mypage/model/addpet_model.dart';

class AddPetViewModel extends Notifier<AddPetModel> {
  AddPetModel _model = AddPetModel.empty();

  AddPetModel get model => _model;

  @override
  AddPetModel build() => _model;

  void updateBreed(String breed) {
    _model = _model.copyWith(breed: breed);
    state = _model;
  }

  void updateName(String name) {
    _model = _model.copyWith(name: name);
    state = _model;
  }

  void updateGender(String gender) {
    _model = _model.copyWith(gender: gender);
    state = _model;
  }

  void updateNeutered(bool isNeutered) {
    _model = _model.copyWith(isNeutered: isNeutered);
    state = _model;
  }

  void updateWeight(double weight) {
    _model = _model.copyWith(weight: weight);
    state = _model;
  }

  void updateBirthDate(DateTime date) {
    _model = _model.copyWith(birthDate: date);
    state = _model;
  }

  bool get isFormValid {
    // birthDate는 현재 날짜 이전이어야 합니다.
    bool isBirthDateValid = _model.birthDate.isBefore(DateTime.now());

    // weight는 0보다 커야 합니다.
    bool isWeightValid = _model.weight > 0;

    // 성별은 '남' 또는 '여'가 선택되어야 합니다. (선택사항에 따라 조정)
    bool isGenderValid = _model.gender == '남' || _model.gender == '여';

    // 중성화 여부는 true 또는 false가 명확히 지정되어야 합니다.
    bool isNeuteredValid = _model.isNeutered != null;

    return isBirthDateValid &&
        isWeightValid &&
        isGenderValid &&
        isNeuteredValid;
  }

  // 기존 메서드 및 상태 업데이트 메서드 생략...
}

final addPetViewModelProvider =
    NotifierProvider<AddPetViewModel, AddPetModel>(() {
  return AddPetViewModel();
});

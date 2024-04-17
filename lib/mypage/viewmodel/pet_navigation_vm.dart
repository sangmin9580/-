import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/mypage/model/pet_model.dart';

class PetNavigationViewModel extends Notifier<PetModel> {
  @override
  PetModel build() {
    return PetModel.empty();
  }
}

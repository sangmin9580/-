import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/mypage/model/pet_navigation_model.dart';

class PetNavigationViewModel extends Notifier<PetNavigationModel> {
  @override
  PetNavigationModel build() {
    return PetNavigationModel.empty();
  }
}

final editModeProvider = StateProvider<bool>((ref) => false);
final selectedItemsProvider = StateProvider<List<int>>((ref) => []);
final petListProvider = StateProvider<List<PetNavigationModel>>(
  (ref) => [
    PetNavigationModel.empty(),
  ],
);

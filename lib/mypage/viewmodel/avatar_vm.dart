import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/mypage/model/petavatar_model.dart';

class AvatarViewModel extends Notifier<PetAvatarModel> {
  @override
  PetAvatarModel build() {
    return PetAvatarModel();
  }
}

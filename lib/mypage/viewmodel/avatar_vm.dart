import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/mypage/model/petprofile_model.dart';

class AvatarViewModel extends Notifier<PetProfileModel> {
  @override
  PetProfileModel build() {
    return PetProfileModel();
  }
}

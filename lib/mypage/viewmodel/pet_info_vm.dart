import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/common/viewmodel/main_navigation_vm.dart';

import 'package:project/mypage/model/pet_model.dart';

class PetInfoViewModel extends Notifier<PetModel> {
  @override
  PetModel build() => PetModel.empty();

  void updateBreed(String breed) {
    state = state.copyWith(breed: breed);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateNeutered(bool isNeutered) {
    state = state.copyWith(isNeutered: isNeutered);
  }

  void updateWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void updateBirthDate(DateTime date) {
    state = state.copyWith(
      birthDate: date,
    );
  }

  String getAge(DateTime birthDate) {
    final today = DateTime.now(); // 현재 날짜
    int years = today.year - birthDate.year; // 연도 차이를 계산
    int months = today.month - birthDate.month; // 월 차이를 계산
    int days = today.day - birthDate.day; // 일 차이를 계산

    if (months < 0 || (months == 0 && days < 0)) {
      // 생일이 아직 오지 않았다면, 나이에서 1년을 뺍니다.
      years--;
      months += (days < 0 ? 11 : 12); // 생일이 지나지 않았다면, 이전 달로 설정
    }

    if (days < 0) {
      // 이번 달의 날짜 수를 기준으로 날짜 차이를 다시 계산합니다.
      final lastMonth = DateTime(today.year, today.month, 0);
      days += lastMonth.day;
      months--;
    }

    // 결과 문자열을 "X년 Y개월" 형식으로 반환합니다.
    return "$years년 $months개월";
  }

  bool get isFormValid {
    // birthDate는 현재 날짜 이전이어야 합니다.
    bool isBirthDateValid = state.birthDate.isBefore(DateTime.now());

    // weight는 0보다 커야 합니다.
    bool isWeightValid = state.weight > 0;

    // 성별은 '남' 또는 '여'가 선택되어야 합니다. (선택사항에 따라 조정)
    bool isGenderValid = state.gender == '남' || state.gender == '여';

    // 중성화 여부는 true 또는 false가 명확히 지정되어야 합니다.
    bool isNeuteredValid = state.isNeutered != null;

    return isBirthDateValid &&
        isWeightValid &&
        isGenderValid &&
        isNeuteredValid;
  }

  // 기존 메서드 및 상태 업데이트 메서드 생략...

  void goToMyPage(BuildContext context) {
    ref.read(mainNavigationViewModelProvider.notifier).goToMyPage();
    Navigator.of(context).popUntil((route) => route.isFirst);
    resetState();
  }

  void resetState() {
    state = PetModel.empty(); // 초기 상태로 리셋
  }

  void onTapHomeIcon(BuildContext context) {
    // MainNavigationViewModel에 접근

    // 입력 중인 상태 확인 (name, breed 등 중 하나라도 값이 있는지 확인)
    bool isInputInProgress =
        state.name.isNotEmpty || state.breed.isNotEmpty; // 더 많은 조건 추가 가능

    if (isInputInProgress) {
      // 모달 창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("알림"),
          content: const Text("지금까지의 내용은 저장되지 않습니다. 계속하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("예"),
              onPressed: () {
                Navigator.of(context).pop(); // 대화상자 닫기
                goToMyPage(context);
                print("1"); // 인덱스 3으로 이동
              },
            ),
            TextButton(
              child: const Text("아니오"),
              onPressed: () => Navigator.of(context).pop(), // 대화상자 닫기
            ),
          ],
        ),
      );
    } else {
      // 입력 중인 상태가 아니라면 바로 인덱스 3으로 이동
      goToMyPage(context);

      print("2");
    }
  }
}

final addPetViewModelProvider =
    NotifierProvider<PetInfoViewModel, PetModel>(() {
  return PetInfoViewModel();
});

final editModeProvider = StateProvider<bool>((ref) => false);
final selectedItemsProvider = StateProvider<List<int>>((ref) => []);
final petListProvider = StateProvider<List<PetModel>>(
  (ref) => [
    PetModel.empty(),
    PetModel(
      birthDate: DateTime.now(),
      name: "ss",
      breed: "ddd",
      id: 'ㄱㄱㄱ3',
      gender: '남자',
      isNeutered: false,
      weight: 2.5,
    ),
    PetModel(
      birthDate: DateTime.now(),
      name: "ㄱㄱ",
      breed: "ddd",
      id: '123',
      gender: '남자',
      isNeutered: true,
      weight: 2.5,
    ),
  ],
);

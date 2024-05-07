// Notifier 클래스 정의
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project/feature/professor/model/professor_schedule_model.dart';
import 'package:project/feature/professor/viewmodel/expert_consultation_options_vm.dart';

class ConsultationScheduleViewModel
    extends Notifier<ConsultationScheduleModel> {
  // Get 함수를 통한 상태 값 접근
  String? get selectedConsultationType => state.consultationType;
  DateTime? get selectedDate => state.date;
  TimeOfDay? get selectedTime => state.time;
  int? get consultingPrice => state.price;

  // 상담 종류 선택 시 호출되는 메서드
  void selectConsultationType(String type) {
    int price = getPriceByType(type); // ViewModel에서 가격 가져오기
    state = state.copyWith(consultationType: type, price: price);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void selectTime(TimeOfDay time) {
    state = state.copyWith(time: time);
  }

  String formatPrice(int? price) {
    if (price == null) return '0원';
    return NumberFormat('#,###원', 'ko_KR').format(price);
  }

  int getPriceByType(String consultationType) {
    // 다른 ViewModel의 상태를 참조
    final pricePerType =
        ref.read(expertConsultationOptionsProvider).pricePerType;
    return pricePerType[consultationType] ?? 0; // 기본값은 0으로 설정
  }

  void reset() {
    // `build` 메서드를 호출하여 초기 상태로 리셋
    state = build();
  }

  @override
  ConsultationScheduleModel build() {
    return ConsultationScheduleModel.empty();
  }
}

// Provider 정의
final consultationScheduleProvider =
    NotifierProvider<ConsultationScheduleViewModel, ConsultationScheduleModel>(
        () {
  return ConsultationScheduleViewModel();
});

// 선택된 시간을 관리하는 StateProvider
final selectedTimeProvider = StateProvider<TimeOfDay?>((ref) => null);

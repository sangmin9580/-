// Notifier 클래스 정의
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project/professor/model/professor_schedule_model.dart';

class ConsultationScheduleViewModel
    extends Notifier<ConsultationScheduleModel> {
  // Get 함수를 통한 상태 값 접근
  String? get selectedConsultationType => state.consultationType;
  DateTime? get selectedDate => state.date;
  TimeOfDay? get selectedTime => state.time;
  int? get consultingPrice => state.price;

  void selectConsultationType(String type) {
    state = state.copyWith(consultationType: type);
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

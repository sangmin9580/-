// ConsultationScheduleModel 모델 정의
import 'package:flutter/material.dart';

class ConsultationScheduleModel {
  final String? consultationType;
  final DateTime? date;
  final TimeOfDay? time;
  final int? price; // 가격을 int 형식으로 저장

  ConsultationScheduleModel({
    this.consultationType,
    this.date,
    this.time,
    this.price,
  });

  ConsultationScheduleModel.empty()
      : consultationType = "상담 종류 선택",
        date = null,
        time = null,
        price = 0;

  ConsultationScheduleModel copyWith({
    String? consultationType,
    DateTime? date,
    TimeOfDay? time,
    int? price,
  }) {
    return ConsultationScheduleModel(
      consultationType: consultationType ?? this.consultationType,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
    );
  }
}

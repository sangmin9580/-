import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/professor/viewmodel/expert_consultation_options_vm.dart';
import 'package:project/feature/professor/viewmodel/professor_schedule_vm.dart';

class TimeSelectionWidget extends ConsumerWidget {
  final void Function(TimeOfDay) onTap;

  const TimeSelectionWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedConsultationType = ref.watch(
        consultationScheduleProvider.select((state) => state.consultationType));
    final selectedDate =
        ref.watch(consultationScheduleProvider.select((state) => state.date));
    final now = DateTime.now();
    final selectedTime = ref.watch(selectedTimeProvider);

    final availableTimesForType = ref.watch(
        expertConsultationOptionsProvider.select((state) =>
            state.availableTimesPerType[selectedConsultationType] ?? []));

    List<String> filteredTimes;
    if (selectedDate != null &&
        selectedDate.day == now.day &&
        selectedDate.month == now.month &&
        selectedDate.year == now.year) {
      filteredTimes = availableTimesForType
          .where((time) => DateTime(now.year, now.month, now.day,
                  int.parse(time.split(':')[0]), int.parse(time.split(':')[1]))
              .isAfter(now))
          .toList();
    } else {
      filteredTimes = availableTimesForType;
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 한 줄에 4개의 아이템 표시
        childAspectRatio: 3, // 아이템의 가로 세로 비율
      ),
      itemCount: filteredTimes.length,
      itemBuilder: (context, index) {
        final time = filteredTimes[index];
        final timeOfDay = TimeOfDay(
            hour: int.parse(time.split(':')[0]),
            minute: int.parse(time.split(':')[1]));

        return GestureDetector(
          onTap: () {
            ref.read(selectedTimeProvider.notifier).state = timeOfDay;
            onTap(timeOfDay);
          },
          child: Card(
            color: selectedTime == timeOfDay ? Colors.blue : Colors.white,
            child: Center(
              child: Text(time,
                  style: TextStyle(
                      color: selectedTime == timeOfDay
                          ? Colors.white
                          : Colors.black)),
            ),
          ),
        );
      },
    );
  }
}

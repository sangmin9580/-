// 모달 하단의 가격 및 '다음' 버튼을 구현
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/professor/viewmodel/professor_schedule_vm.dart';

Widget consultingApplyBottomBar(BuildContext context, WidgetRef ref) {
  // 상태를 확인하여 가격을 가져옵니다.
  final price =
      ref.watch(consultationScheduleProvider.notifier).consultingPrice;

  // 모든 선택 사항이 완료되었는지 확인합니다.
  bool allOptionsSelected = ref.watch(consultationScheduleProvider.select(
    (value) =>
        value.consultationType != null &&
        value.date != null &&
        value.time != null,
  ));

  return Container(
    height: Sizes.size96,
    padding: const EdgeInsets.all(
      16.0,
    ),
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '총 결제금액',
                  style: TextStyle(
                      fontSize: Sizes.size12, color: Colors.grey.shade500),
                ),
                Text(
                  ref
                      .read(
                        consultationScheduleProvider.notifier,
                      )
                      .formatPrice(
                        price,
                      ),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: allOptionsSelected
                      ? Colors.blue
                      : Colors.grey, // 선택 사항이 모두 선택되었을 때만 파란색으로
                ),
                onPressed: allOptionsSelected
                    ? () {
                        context.pop();
                      }
                    : null, // 모든 선택 사항이 완료되지 않았다면 버튼을 비활성화
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: allOptionsSelected ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

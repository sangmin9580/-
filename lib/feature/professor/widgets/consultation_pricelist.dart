import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/professor/viewmodel/expert_consultation_options_vm.dart';
import 'package:project/feature/professor/widgets/customtimelineentry.dart';

class ConsultationPriceList extends ConsumerWidget {
  const ConsultationPriceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expertOptions = ref.watch(expertConsultationOptionsProvider);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expertOptions.availableConsultationTypes.length,
      itemBuilder: (context, index) {
        final type = expertOptions.availableConsultationTypes[index];
        final price = expertOptions.pricePerType[type];
        return CustomTimelineEntry(
          timeline: type,
          description: '$price원',
        );
      },
    );
  }
}

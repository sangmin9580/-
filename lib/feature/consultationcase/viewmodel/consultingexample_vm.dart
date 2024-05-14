import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsultingExampleViewModel extends Notifier<void> {
  @override
  build() {
    return;
  }

  void selectExpertType(String expertType) {
    ref.read(expertTypeProvider.notifier).state = expertType;
  }

  void selectConsultationTopic(String topic) {
    ref.read(consultationTopicProvider.notifier).state = topic;
  }
}

final expertTypeProvider = StateProvider<String?>((ref) => null);
final consultationTopicProvider = StateProvider<String?>((ref) => null);
final consultingExampleProvider =
    NotifierProvider<ConsultingExampleViewModel, void>(
  () => ConsultingExampleViewModel(),
);

// 상담글 시작할 때 처음에는 false임. 왜냐하면 바로 뒤로가기를 눌렀을 때 홈으로 가게하려고.
//다만 true가 되는 경우 전문가와 상담종류 모달창이 나오도록 설정했어. 그렇기 때문에 '강아지 선택하기'를 누르면
//true로 바뀌게 해놨고, 나중에 상담 등록 또는 중간에 상담을 취소하면 해당값을 다시 false로 바꿔야해.
final consultationProcessStartedProvider = StateProvider<bool>((ref) => false);

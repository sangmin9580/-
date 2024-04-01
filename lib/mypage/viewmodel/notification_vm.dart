import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/mypage/model/notification_model.dart';
import 'package:project/mypage/repo/notification_repository.dart';

class NotificationViewModel extends Notifier<NotificationModel> {
  late final NotificationRepository _notificationRepository;

  @override
  NotificationModel build() {
    _notificationRepository = ref.read(notificationRepoProvider);
    return NotificationModel(
      push: _notificationRepository.goPush(),
      marketing: _notificationRepository.goMarketing(),
      privacy: _notificationRepository.goPrivacy(),
    );
  }

  void updatePush(bool newValue) async {
    state = NotificationModel(
        push: newValue, marketing: state.marketing, privacy: state.privacy);
    await _notificationRepository.saveNotificationSettings(state);
  }

  void updateMarketing(bool newValue) async {
    state = NotificationModel(
        push: state.push, marketing: newValue, privacy: state.privacy);
    await _notificationRepository.saveNotificationSettings(state);
  }

  void updatePrivacy(bool newValue) async {
    state = NotificationModel(
        push: state.push, marketing: state.marketing, privacy: newValue);
    await _notificationRepository.saveNotificationSettings(state);
  }
}

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationModel>(
  () => NotificationViewModel(),
);

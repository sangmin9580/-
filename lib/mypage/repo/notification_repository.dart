import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/mypage/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepository {
  final SharedPreferences _preferences;

  NotificationRepository(this._preferences);

  Future<NotificationModel> loadNotificationSettings() async {
    bool push = _preferences.getBool('push') ?? true; // 기본값을 true로 설정
    bool marketing = _preferences.getBool('marketing') ?? true; // 기본값을 true로 설정
    bool privacy = _preferences.getBool('privacy') ?? true; // 기본값을 true로 설정
    return NotificationModel(
        push: push, marketing: marketing, privacy: privacy);
  }

  Future<void> saveNotificationSettings(NotificationModel settings) async {
    await _preferences.setBool('push', settings.push);
    await _preferences.setBool('marketing', settings.marketing);
    await _preferences.setBool('privacy', settings.privacy);
  }

  bool goPush() {
    return _preferences.getBool('push') ?? false;
  }

  bool goMarketing() {
    return _preferences.getBool('marketing') ?? false;
  }

  bool goPrivacy() {
    return _preferences.getBool('privacy') ?? false;
  }
}

// SharedPreferences 인스턴스를 주입받아 NotificationRepository를 생성하는 Provider
final notificationRepoProvider = Provider<NotificationRepository>((ref) {
  throw UnimplementedError(); // main에서 SharedPreferences 인스턴스를 설정할 때까지 이 부분은 대체됩니다.
});

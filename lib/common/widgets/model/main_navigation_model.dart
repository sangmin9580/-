class MainNavigationModel {
  final int tabBarSelectedIndex;
  final int navigationBarSelectedIndex;

  MainNavigationModel({
    this.tabBarSelectedIndex = 0,
    this.navigationBarSelectedIndex = 0,
  });

  // 상태 변경을 위한 메소드들을 포함할 수 있습니다.
  MainNavigationModel copyWith({
    int? tabBarSelectedIndex,
    int? navigationBarSelectedIndex,
  }) {
    return MainNavigationModel(
      tabBarSelectedIndex: tabBarSelectedIndex ?? this.tabBarSelectedIndex,
      navigationBarSelectedIndex:
          navigationBarSelectedIndex ?? this.navigationBarSelectedIndex,
    );
  }
}

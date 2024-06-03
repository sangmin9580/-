class NavigationHistoryStateModel {
  final int tabIndex;
  final int navBarIndex;

  NavigationHistoryStateModel(
      {required this.tabIndex, required this.navBarIndex});

  NavigationHistoryStateModel.fromJson(Map<int, int> json)
      : tabIndex = json["tabIndex"]!,
        navBarIndex = json["navBarIndex"]!;

  Map<String, int> toJson() {
    return {
      "tabIndex": tabIndex,
      "navBarIndex": navBarIndex,
    };
  }

  @override
  String toString() {
    return '($tabIndex, $navBarIndex)';
  }
}

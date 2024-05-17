class NavigationHistyoryStateModel {
  final int tabIndex;
  final int navBarIndex;

  NavigationHistyoryStateModel(
      {required this.tabIndex, required this.navBarIndex});

  NavigationHistyoryStateModel.fromJson(Map<int, int> json)
      : tabIndex = json["tabIndex"]!,
        navBarIndex = json["navBarIndex"]!;

  Map<String, int> toJson() {
    return {
      "tabIndex": tabIndex,
      "navBarIndex": navBarIndex,
    };
  }
}

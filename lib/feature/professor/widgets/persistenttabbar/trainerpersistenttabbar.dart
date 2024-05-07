import 'package:flutter/material.dart';

class TrainerPersistentTabBar extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  TrainerPersistentTabBar({required this.tabController});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.5,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      height: 45,
      child: TabBar(
        indicatorColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(
          vertical: 3,
        ),
        controller: tabController,
        isScrollable: true,
        tabs: const [
          Text("훈련"),
          Text("기초훈련"),
          Text("복종훈련"),
          Text("대회훈련"),
          Text("재활훈련"),
          Text("임신훈련"),
          Text("기타"),
        ],
        labelStyle: TextStyle(
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

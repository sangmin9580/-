import 'package:flutter/material.dart';
import 'package:project/constants/sizes.dart';

class SubPersistentTabBar extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  SubPersistentTabBar({required this.tabController});
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
      height: 50,
      child: TabBar(
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size32,
        ),
        controller: tabController,
        tabs: const [
          Text(
            "수의사",
          ),
          Text(
            "훈련사",
          ),
        ],
        labelStyle: TextStyle(
          fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

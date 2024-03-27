import 'package:flutter/material.dart';

class VetPersistentTabBar extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  VetPersistentTabBar({required this.tabController});
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
          Text("일반 진료 및 예방 접종"),
          Text("특수 질병 관리"),
          Text("노령견 관리"),
          Text("응급 처치 및 사고 대비"),
          Text("생식 건강 및 관리"),
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

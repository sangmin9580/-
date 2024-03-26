import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class ProfessorScreen extends ConsumerStatefulWidget {
  const ProfessorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfessorScreenState();
}

class _ProfessorScreenState extends ConsumerState<ProfessorScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0; // 선택된 메인 탭의 인덱스를 추적하기 위한 변수

  late final TabController _mainTabController;

  late final TabController _subTabController;

  late final TabController _consultantclassTabController;
  late final TabController _trainerclassTabController; // 추가된 컨트롤러

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _subTabController = TabController(length: 2, vsync: this);
    _consultantclassTabController = TabController(length: 7, vsync: this);
    _trainerclassTabController = TabController(length: 7, vsync: this);

    _subTabController.addListener(() {
      if (!mounted) return;
      setState(() {
        _selectedIndex = _subTabController.index;
      });
    });

    _mainTabController.addListener(() {
      if (!mounted) return;
      setState(() {
        // 여기서는 _mainTabController.index의 변경을 감지하므로
        // 필요한 경우 관련 로직을 추가할 수 있습니다.
      });
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _subTabController.dispose();
    _consultantclassTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: const AppBarTheme(
          elevation: 0,
        ),
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: TabBar(
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  controller: _mainTabController,
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size3,
                  ),
                  indicatorColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    Container(
                      alignment: Alignment.center,
                      height: Sizes.size40,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "분야로 찾기",
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: Sizes.size40,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "지도로 찾기",
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SubPersistentTabBar(
                tabController: _subTabController,
              ),
            ),
            if (_mainTabController.index == 0) ...[
              if (_selectedIndex == 0)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: ClassPersistentTabBar(
                    tabController: _consultantclassTabController,
                  ),
                ),
              if (_selectedIndex == 1)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: TrainerPersistentTabBar(
                    tabController: _trainerclassTabController,
                  ),
                ),
            ]
          ];
        },
        body: TabBarView(
          controller: _mainTabController,
          children: [
            // '분야로 찾기' 탭의 TabBarView
            TabBarView(
              controller: _subTabController,
              children: [
                // '수의사' 선택 시의 컨텐츠
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey.shade300,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Sizes.size10,
                              horizontal: horizontalPadding,
                            ),
                            child: Text(
                              "성범죄",
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Gaps.v5,
                        ListTile(
                          title: const Text("성매매"),
                          subtitle: Text(
                            "조건만남, 랜덤채팅, 유흥업소,유사성매매 등",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .fontSize,
                            ),
                          ),
                        ),
                        const ListTile(
                          title: Text("성매매"),
                          subtitle: Text(
                            "조건만남, 랜덤채팅, 유흥업소,유사성매매 등",
                          ),
                        ),
                        const ListTile(
                          title: Text("성매매"),
                          subtitle: Text(
                            "조건만남, 랜덤채팅, 유흥업소,유사성매매 등",
                          ),
                        ),
                        Gaps.v32,
                      ],
                    );
                  },
                ),
                // '훈련사' 선택 시의 컨텐츠
                Container(color: Colors.blue),
              ],
            ),
            // '지도로 찾기' 탭의 화면
            Container(color: Colors.green),
          ],
        ),
      ),
    );
  }
}

class SubPersistentTabBar extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  SubPersistentTabBar({required this.tabController});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 30,
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
  double get maxExtent => 30;

  @override
  double get minExtent => 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class ClassPersistentTabBar extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  ClassPersistentTabBar({required this.tabController});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 40,
      child: TabBar(
        indicatorColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(
          vertical: 3,
        ),
        controller: tabController,
        isScrollable: true,
        tabs: const [
          Text("성범죄"),
          Text("재산범죄"),
          Text("교통사고범죄"),
          Text("형사절차"),
          Text("폭행/협박"),
          Text("명예훼손/모욕"),
          Text("기타"),
        ],
        labelStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class TrainerPersistentTabBar extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  TrainerPersistentTabBar({required this.tabController});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 40,
      child: TabBar(
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
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

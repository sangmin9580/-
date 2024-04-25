import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/common/view/search_screen.dart';
import 'package:project/consultationcase/view/consulting_detail_screen.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/common/widgets/bottomnavigationBar.dart';

import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/consultationcase/widgets/consultantexample_box.dart';
import 'package:project/professor/view/professor_screen.dart';
import 'package:project/professor/widgets/pricelistcontent.dart';

class ProfessorNavigationScreen extends ConsumerStatefulWidget {
  const ProfessorNavigationScreen({super.key});

  static const routerURL = "/ProfessorNavigation";
  static const routerName = "ProfessorNavigation";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfessorNavigationScreenState();
}

class _ProfessorNavigationScreenState
    extends ConsumerState<ProfessorNavigationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  final List<Widget> screens = [
    ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "윤상민 수의사",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.v5,
                    Text(
                      "사랑 수의원",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      '압도적인 시술 경험과 성공',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize,
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      "관련분야 후기 10개+",
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodySmall!.fontSize,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: Sizes.size32,
                  child: Text(
                    "상민",
                  ),
                ),
              ],
            ),
          ),
          Gaps.v20,
          Container(
            width: MediaQuery.of(context).size.width,
            height: Sizes.size72,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      PricelistContent(
                        content: "15분 전화상담",
                        price: "30,000원",
                      ),
                      Gaps.h10,
                      PricelistContent(
                        subject: "고객직접",
                        content: "30분 방문상담",
                        price: "80,000원",
                      ),
                      Gaps.h10,
                      PricelistContent(
                        subject: "전문가직접",
                        content: "30분 방문상담",
                        price: "150,000원",
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(
                        ProfessorScreen.routerURL,
                      );
                    },
                    child: Transform.scale(
                      scale: 1.1,
                      child: Container(
                        alignment: Alignment.center,
                        width: Sizes.size64,
                        height: Sizes.size64,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8D9440),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "예약",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "하기",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gaps.v10,
          defaultVericalDivider,
        ],
      ),
    ),
    ListView(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Row(
            children: [
              Text("정확도순"),
              Gaps.h10,
              Text("최신 답변순"),
              Gaps.h10,
              Text("최신 질문순"),
              Gaps.h10,
              Text("조회순"),
            ],
          ),
        ),
        defaultVericalDivider,
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: ListView.builder(
            shrinkWrap: true, // 여기를 추가하세요
            physics: const NeverScrollableScrollPhysics(), // 그리고 여기도 추가하세요
            itemCount: 10,
            itemBuilder: (context, index) => GestureDetector(
              child: ConsultantExampleBox(
                consultantclass: "고소/소송절차",
                title: "항소재판 변호사 선임과 징역형 상담",
                name: "윤상민",
                detail:
                    "1. 항소심에서 적극적으로 양형사유를 개진하고, 성실한 자세로 재판에 임하여 집행유예를 목표로 집중해야할 것으로 사람잉머리ㅓㅣㅏㅓㄴ",
                count: 3,
                time: 30,
                views: 16,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ConsultingDetailScreen(), // 상세 화면으로 전환
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        defaultVericalDivider,
      ],
    )
  ];

  @override
  void dispose() {
    _tabController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 나중에 누르면 홈오게 만들어야함.
        centerTitle: true,
        title: CupertinoSearchTextField(
          controller: _textEditingController,
          placeholder: "검색어를 입력해주세요",
        ),
        bottom: TabBar(
          controller: _tabController,
          splashFactory: NoSplash.splashFactory,
          unselectedLabelColor: Colors.grey.shade500,
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          labelPadding: const EdgeInsets.only(
            bottom: 10,
            top: 15,
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
          ),
          tabs: const [
            Text("전문가"),
            Text("상담사례"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: screens, // screens 리스트에 두 개의 위젯이 모두 포함되어 있어야 합니다.
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          onItemSelected: (Index) {
            // MainNavigationScreen으로 돌아가면서 해당 인덱스의 탭을 활성화합니다.
            Navigator.pop(context); // ProfessorNavigationScreen을 닫습니다.
            ref
                .read(mainNavigationViewModelProvider.notifier)
                .setNavigationBarSelectedIndex(Index); // 탭 인덱스 업데이트

            if (Index == 1) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()));
            }
          },
          selectedIndex: 1),
    );
  }
}

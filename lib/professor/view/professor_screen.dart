import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/constants/default.dart';

import 'package:project/constants/sizes.dart';
import 'package:project/professor/widgets/persistenttabbar/subpersistenttabbar.dart';

import '../widgets/item.dart';

class ProfessorScreen extends ConsumerStatefulWidget {
  const ProfessorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfessorScreenState();
}

class _ProfessorScreenState extends ConsumerState<ProfessorScreen>
    with TickerProviderStateMixin {
  late final TabController _mainTabController;
  late final TabController _subTabController;

  int _subSelectedIndex = 0;
  // late final TabController _vetclassTabController;
  // late final TabController _trainerclassTabController; // 추가된 컨트롤러

  // final List<GlobalKey> _vetItemKeys =
  //     List.generate(6, (index) => GlobalKey()); // 위치를 조정하기 위한 globalkey

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _subTabController = TabController(length: 2, vsync: this);

    // _vetclassTabController.addListener(
    //   () {
    //     if (_vetclassTabController.indexIsChanging) {
    //       switch (_vetclassTabController.index) {
    //         case 0: // '일반 진료 및 예방 접종' 탭의 경우
    //           _scrollToItem(_vetItemKeys[0]);
    //           break;
    //         case 1: // "특수질병관리" 탭의 경우
    //           _scrollToItem(_vetItemKeys[1]);
    //           break;
    //         case 2: // '노령견관리' 탭의 경우
    //           _scrollToItem(_vetItemKeys[2]);
    //           break;
    //         case 3: // '응급처치' 탭의 경우
    //           _scrollToItem(_vetItemKeys[3]);
    //           break;
    //         case 4: // '생식 건강' 탭의 경우
    //           _scrollToItem(_vetItemKeys[4]);
    //           break;
    //         case 5: // '기타' 탭의 경우
    //           _scrollToItem(_vetItemKeys[5]);
    //           break;
    //       }
    //     }
    //   },
    // );

    _mainTabController.addListener(() {
      if (!mounted) return;
      setState(() {
        // 여기서는 _mainTabController.index의 변경을 감지하므로
        // 필요한 경우 관련 로직을 추가할 수 있습니다.
      });
    });

    _subTabController.addListener(() {
      if (!mounted) return;

      setState(() {
        _subSelectedIndex = _subTabController.index;
      });
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _subTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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

          // if (_selectedIndex == 0)
          //   SliverPersistentHeader(
          //     pinned: true,
          //     delegate: VetPersistentTabBar(
          //       tabController: _vetclassTabController,
          //     ),
          //   ),
          // if (_selectedIndex == 1)
          //   SliverPersistentHeader(
          //     pinned: true,
          //     delegate: TrainerPersistentTabBar(
          //       tabController: _trainerclassTabController,
          //     ),
          //   ),
        ];
      },
      body: TabBarView(
        controller: _mainTabController,
        children: [
          // '분야로 찾기' 탭의 TabBarView
          TabBarView(
            controller: _subTabController,
            children: [
              ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) => Column(
                  children: [
                    ProfessorItems(
                      headertitle: "일반 진료 및 예방 접종",
                      items: [
                        Item(
                          title: "일상적인 건강진단",
                          subtitle: "체중, 체온 측정, 심장 및 호흡 속도 검사 등",
                        ),
                        Item(
                          title: "예방접종",
                          subtitle: "개인의 나이, 생활 환경, 여행 습관을 고려해 맞춤형 접종 계획",
                        ),
                        Item(
                          title: "기본적인 건강 관리 상담",
                          subtitle: "건강한 생활 습관, 영양 상담, 운동 권장 사항 등",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "특수 질병 관리",
                      items: [
                        Item(
                          title: "알러지",
                          subtitle: "반려동물의 알러지 반응을 진단 및 상담 제공",
                        ),
                        Item(
                          title: "피부 질환",
                          subtitle: "피부 감염, 진드기 등 피부 질환의 진단 및 치료",
                        ),
                        Item(
                          title: "내분비 질환",
                          subtitle: "갑상선 기능 장애, 당뇨병 등 내분비 계 질환의 진단과 관리",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "노령견 관리",
                      items: [
                        Item(
                          title: "노령견의 건강 관리",
                          subtitle: "노령견의 특수한 건강 요구 사항에 초점을 맞춘 관리",
                        ),
                        Item(
                          title: "영양",
                          subtitle: "반려동물의 나이, 건강 상태, 활동 수준에 맞는 영양 상담",
                        ),
                        Item(
                          title: "일상 생활의 편의 제공",
                          subtitle: "반려동물의 삶의 질 향상을 위한 일상 생활의 편의 제공",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "응급 처치 및 사고 대비",
                      items: [
                        Item(
                          title: "응급 상황",
                          subtitle: "응급 상황 발생 시 신속하고 효과적인 대응 방법",
                        ),
                        Item(
                          title: "사고 예방",
                          subtitle:
                              "가정 내 안전 조치, 외출 시 안전 수칙, 독성 식물/물질 회피 방안 등 제공",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "생식 건강 및 관리",
                      items: [
                        Item(
                          title: "임신",
                          subtitle: "임신 기간 동안 필요한 영양, 운동, 건강 모니터링에 대한 전문적 조언",
                        ),
                        Item(
                          title: "출산 관련 상담 및 건강 관리",
                          subtitle: "출산 전 후의 준비 및 주의사항",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "기타",
                      items: [
                        Item(
                          title: "기타",
                          subtitle: "기타 문의하세요",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // '수의사' 선택 시의 컨텐츠
              // '훈련사' 선택 시의 컨텐츠
              ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) => Column(
                  children: [
                    ProfessorItems(
                      headertitle: "기본 순종 훈련",
                      items: [
                        Item(
                          title: "기본적인 순종 훈련 상담",
                          subtitle: "앉기, 기다리기, 옆에 걷기와 같은 기본 명령어 숙달",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "행동 수정",
                      items: [
                        Item(
                          title: "문제 행동 수정 방법 제공",
                          subtitle:
                              "공격성, 짖음, 파괴 행동 등의 문제 행동을 인식하고 수정하기 위한 행동 치료 기법",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "고급 훈련 및 스포츠",
                      items: [
                        Item(
                          title: "고급 훈련 방법과 경쟁 준비",
                          subtitle:
                              "애견 스포츠, 트릭 훈련, 장애물 코스 통과 등을 포함한 고급 훈련 프로그램",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "사회화 및 적응 훈련",
                      items: [
                        Item(
                          title: "적절한 상호작용 및 적응 훈련",
                          subtitle:
                              "다른 동물이나 사람과의 긍정적인 상호작용 촉진 및 다양한 환경에 효과적으로 적응",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "분리 불안 해소",
                      items: [
                        Item(
                          title: "분리 불안 해소 전략 및 훈련",
                          subtitle: "주인과 떨어져 있을 때 발생하는 불안 감소를 위한 방법",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "이동 및 여행 훈련",
                      items: [
                        Item(
                          title: "여행 시 준비 및 훈련 상담",
                          subtitle:
                              "차량 이동, 대중교통 이용, 여행 시 필요한 준비 사항 및 반려견의 편안함을 위한 훈련",
                        ),
                      ],
                    ),
                    ProfessorItems(
                      headertitle: "기타",
                      items: [
                        Item(
                          title: "기타",
                          subtitle: "기타 문의하세요",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // '지도로 찾기' 탭의 화면
          // 수의사 선택시
          if (_subSelectedIndex == 0)
            ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) => Column(
                children: [
                  MapItems(
                    headertitle: "서울특별시",
                    items: [
                      Item(
                        title: "서초/강남",
                      ),
                      Item(
                        title: "강동/송파",
                      ),
                      Item(
                        title: "강서/양천/영등포/구로",
                      ),
                      Item(
                        title: "도봉/강북/성북/노원",
                      ),
                      Item(
                        title: "동대문/성동/광진/중랑",
                      ),
                      Item(
                        title: "종로/중구/용산",
                      ),
                      Item(
                        title: "서대문/마포/은평",
                      ),
                      Item(
                        title: "동작/관악/금천",
                      ),
                    ],
                  ),
                  MapItems(
                    headertitle: "경기도",
                    items: [
                      Item(
                        title: "수원/화성/용인",
                      ),
                      Item(
                        title: "안산/시흥/광명/안양",
                      ),
                      Item(
                        title: "성남/광주/하남",
                      ),
                      Item(
                        title: "고양/김포/파주",
                      ),
                      Item(
                        title: "의정부/남양주/구리",
                      ),
                      Item(
                        title: "평택/오산/안성",
                      ),
                      Item(
                        title: "여주/이천/양평",
                      ),
                    ],
                  ),
                ],
              ),
            ),

          //훈련사 선택시
          if (_subSelectedIndex == 1)
            Container(
              color: Colors.red,
            )
        ],
      ),
    );
  }
}

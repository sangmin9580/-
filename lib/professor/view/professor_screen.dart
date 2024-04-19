import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/professor/widgets/map_sample.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessorScreen extends ConsumerStatefulWidget {
  const ProfessorScreen({super.key});

  static const routerURL = '/professor';
  static const routerName = 'professor';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfessorScreenState();
}

void _launchURL() async {
  const url = 'https://map.naver.com/v5/search/서울특별시 서초구 반포대로 18길 36';
  final uri = Uri.parse(url);
  print("dafdsfa");
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $uri';
  }
}

void _callOffice() {
  // 전화 거는 로직
}
void _showBookingModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          const String selectedOption = ""; // 사용자가 선택한 예약 옵션을 저장할 변수
          // ... 기타 필요한 상태 변수를 추가

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text('상담 종류 선택'),
                // ... 여기에 상담 종류를 선택할 수 있는 위젯 추가
              ),
              const ListTile(
                title: Text('날짜 선택'),
                // ... 여기에 날짜를 선택할 수 있는 위젯 추가
              ),
              const ListTile(
                title: Text('시간 선택'),
                // ... 여기에 시간을 선택할 수 있는 위젯 추가
              ),
              ElevatedButton(
                onPressed: selectedOption != null // 모든 선택이 완료되었는지 여부
                    ? () {
                        // 다음 버튼의 액션을 처리
                      }
                    : null, // 모든 선택이 완료되지 않았다면 버튼 비활성화
                child: const Text('다음'),
              ),
            ],
          );
        },
      );
    },
  );
}

class _ProfessorScreenState extends ConsumerState<ProfessorScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4, // 탭의 개수
        child: SafeArea(
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 1,
                    expandedHeight: 300.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          var top = constraints.biggest.height;
                          Widget expandedTitle = Opacity(
                            opacity: top > 120.0 ? 1.0 : 0.0,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              child: Text(
                                "<전문 수의사 출신> 서울대 수의사, 경력 18년",
                                style: appbarTitleStyle,
                              ),
                            ),
                          );
                          // 앱 바가 축소됐을 때 보여줄 텍스트
                          Widget collapsedTitle = AnimatedOpacity(
                            opacity: top <= 120.0 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            // 앱 바가 축소됐을 때, 글자가 하단에 위치하도록 Padding을 조정
                            child: const Text("윤상민 전문가"),
                          );

                          return Stack(
                            children: <Widget>[
                              // 배치를 위한 Stack 사용
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: expandedTitle,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: collapsedTitle,
                              ),
                            ],
                          );
                        },
                      ),
                      background: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdO_aQxZsKeLQhEo3Zmi9wS-Dt3J5JClYSti2g481Iu2wBeZv_vQyPsagLdTWeolgKikA&usqp=CAU",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      const TabBar(
                        labelColor: Colors.black,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "전문가홈"),
                          Tab(text: "전문가정보"),
                          Tab(text: "상담사례"),
                          Tab(text: "고객후기"),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  ListView(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 10,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Sizes.size10,
                            horizontal: verticalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "윤상민 수의사",
                                style: TextStyle(
                                  fontSize: Sizes.size24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gaps.v20,
                              Text(
                                "성심 병원",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gaps.v10,
                              Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.map),
                                  Gaps.h10,
                                  Flexible(
                                    child: Text(
                                      "서울특별시 서초구 반포대로 18길 36(서초동, 서초센트럴 Ipark 오피스동) 17층)",
                                      style: TextStyle(
                                        fontSize: Sizes.size12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding,
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              const CertificationType(
                                icon: FontAwesomeIcons.certificate,
                                text: "수의사 자격증",
                              ),
                              const CertificationType(
                                icon: FontAwesomeIcons.certificate,
                                text: "수의사 자격증",
                              ),
                              const CertificationType(
                                icon: FontAwesomeIcons.certificate,
                                text: "수의사 자격증",
                              ),
                              const CertificationType(
                                icon: FontAwesomeIcons.certificate,
                                text: "수의사 자격증",
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: verticalPadding,
                                ),
                                child: Column(
                                  children: [
                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "분야",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Gaps.h10,
                                        Flexible(
                                          child: Text(
                                            "tkdaflskdjflksdjflsjdlkhlsdjfljsldfjlsfjlsdjfljlfjalsjflsdjflsjdlfjsl",
                                          ),
                                        )
                                      ],
                                    ),
                                    Gaps.v10,
                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "경력",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Gaps.h10,
                                        Flexible(
                                          child: Text(
                                              "tkdaflskdjflksdjflsjdlkhlsdjfljsldfjlsfjlsdjfljlfjalsjflsdjflsjdlfjsl"),
                                        )
                                      ],
                                    ),
                                    Gaps.v10,
                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "자격",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Gaps.h10,
                                        Flexible(
                                          child: Text(
                                              "tkdaflskdjflksdjflsjdlkhlsdjfljsldfjlsfjlsdjfljlfjalsjflsdjflsjdlfjsl"),
                                        )
                                      ],
                                    ),
                                    Gaps.v10,
                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "학력",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Gaps.h10,
                                        Flexible(
                                          child: Text(
                                              "tkdaflskdjflksdjflsjdlkhlsdjfljsldfjlsfjlsdjfljlfjalsjflsdjflsjdlfjsl"),
                                        )
                                      ],
                                    ),
                                    Gaps.v32,
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1,
                                          )),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: Sizes.size48,
                                      child: const Text("전문가정보 자세히 보기 >"),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                              width: 10,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 10,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: verticalPadding,
                          horizontal: horizontalPadding,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "상담사례",
                                  style: TextStyle(
                                    fontSize: Sizes.size16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gaps.h5,
                                Text(
                                  "17",
                                  style: TextStyle(
                                    fontSize: Sizes.size18,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gaps.h3,
                                FaIcon(
                                  FontAwesomeIcons.chevronRight,
                                  color: Colors.grey.shade400,
                                  size: Sizes.size16,
                                ),
                              ],
                            ),
                            Gaps.v20,
                            SizedBox(
                              height: 120,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                separatorBuilder: (context, index) {
                                  return Gaps.h20;
                                },
                                itemBuilder: (context, index) {
                                  if (index != 3) {
                                    return const ProfessorConsultingBox();
                                  } else {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                      ), // 배경색 설정) ,
                                      width: 100, // 적절한 너비 설정
                                      height: 90,
                                      margin: const EdgeInsets.all(8), // 여백 설정

                                      child: const Center(
                                        child: Text(
                                          "더 많은 \n 상담사례보기\n >",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                              width: 10,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 10,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalPadding,
                            horizontal: horizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "전문가과 직접 만나서 \n문제를 해결하세요",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size20,
                                ),
                              ),
                              Gaps.v20,
                              const Text(
                                "성심 사랑 병원",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              Gaps.v16,
                              FractionallySizedBox(
                                widthFactor: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.5, // 화면 너비의 50%
                                      ),
                                      child: const Text(
                                        "서울특별시 서초구 반포대로 18길 36(서초동, 서초센트럴 Ipark 오피스동) 17층)",
                                        style:
                                            TextStyle(fontSize: Sizes.size12),

                                        softWrap: true, // 자동으로 줄바꿈
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _launchURL,
                                      child: const Text(
                                        "네이버지도로 보기",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gaps.v40,
                              const MapSample(),
                              const SizedBox(
                                height: 200,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Center(child: Text("Tab 2 Content")),
                  const Center(child: Text("Tab 3 Content")),
                  const Center(child: Text("Tab 4 Content")),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.grey.shade100,
              height: Sizes.size60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () => _callOffice(),
                    child: const Text(
                      '사무실 전화',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showBookingModal(context),
                    child: const Text(
                      '상담 예약하기',
                      style: TextStyle(
                        color: Color(
                          0xFFC78D20,
                        ),
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfessorConsultingBox extends StatelessWidget {
  const ProfessorConsultingBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.size10,
        horizontal: Sizes.size5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10,
        ),
        border: Border.all(
          color: Colors.grey.shade500,
          width: 0.3,
        ),
      ),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "제목",
                style: TextStyle(
                  fontSize: Sizes.size14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.h5,
              Flexible(
                child: Text(
                  "제목ㅇ맒느룸느울ㄴㅁㅇ리ㅏㅇ너ㅣ라ㅓㅏㅣㄴㅁ어리ㅏㅓㄴ이라",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Gaps.v10,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "답변",
                style: TextStyle(
                  fontSize: Sizes.size12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              Gaps.h5,
              const Flexible(
                child: Text(
                  "제목ㅇ맒느룸느울ㄴㅁㅇ리ㅏㅇ너ㅣ라ㅓㅏㅣㄴㅁ어리ㅏㅓㄴ이라",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CertificationType extends StatelessWidget {
  const CertificationType({
    super.key,
    required this.icon,
    required this.text,
  });
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(
          icon,
          size: Sizes.size24,
        ),
        Gaps.v10,
        Text(
          text,
          style: const TextStyle(
            fontSize: Sizes.size16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // 배경색
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

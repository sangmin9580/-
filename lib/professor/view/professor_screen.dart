import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/consultationcase/viewmodel/consultingexample_vm.dart';
import 'package:project/consultationcase/widgets/consultantexample_box.dart';
import 'package:project/professor/viewmodel/expert_consultation_options_vm.dart';
import 'package:project/professor/viewmodel/professor_schedule_vm.dart';
import 'package:project/professor/widgets/certificationtype_box.dart';
import 'package:project/professor/widgets/consultation_pricelist.dart';
import 'package:project/professor/widgets/consulting_apply_bottom_bar.dart';
import 'package:project/professor/widgets/consulting_typebox.dart';
import 'package:project/professor/widgets/customtimelineentry.dart';
import 'package:project/professor/widgets/major_field_type_box.dart';
import 'package:project/professor/widgets/map_sample.dart';
import 'package:project/professor/widgets/time_selection_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessorScreen extends ConsumerStatefulWidget {
  const ProfessorScreen({super.key});

  static const routerURL = '/professor';
  static const routerName = 'professor';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfessorScreenState();
}

class _ProfessorScreenState extends ConsumerState<ProfessorScreen>
    with TickerProviderStateMixin {
  late AnimationController _consultingTypeAnimationController;
  late AnimationController _consultingDateAnimationController;
  late AnimationController _consultingTimeAnimationController;
  late Animation<double> _consultingTypeAnimation;
  late Animation<double> _consultingDateAnimation;
  late Animation<double> _consultingTimeAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _consultingTypeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _consultingDateAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _consultingTimeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _consultingTypeAnimation = Tween<double>(begin: 0.0, end: 0.5)
        .animate(_consultingTypeAnimationController);
    _consultingDateAnimation = Tween<double>(begin: 0.0, end: 0.5)
        .animate(_consultingDateAnimationController);
    _consultingTimeAnimation = Tween<double>(begin: 0.0, end: 0.5)
        .animate(_consultingTimeAnimationController);

    _positionAnimation = Tween<double>(begin: -300, end: 0).animate(
        CurvedAnimation(
            parent: _consultingTimeAnimationController,
            curve: Curves.easeInOut));
  }

  void _consultingTypeToggleDropdown() {
    if (_consultingTypeAnimationController.isCompleted) {
      _consultingTypeAnimationController.reverse();
    } else {
      _consultingTypeAnimationController.forward();
    }
  }

  void _consultingDateToggleDropdown() {
    if (_consultingDateAnimationController.isCompleted) {
      _consultingDateAnimationController.reverse();
    } else {
      _consultingDateAnimationController.forward();
    }
  }

  void _consultingTimeToggleDropdown() {
    print('Animation Status: ${_consultingTimeAnimationController.status}');
    print('Animation Value: ${_consultingTimeAnimationController.value}');
    if (_consultingTimeAnimationController.isCompleted) {
      _consultingTimeAnimationController.reverse();
    } else {
      _consultingTimeAnimationController.forward(from: 0.0); // 애니메이션을 처음부터 시작
    }
    setState(() {});
  }

  void _launchURL() async {
    const String url = 'https://www.google.com'; // 변경하여 테스트
    final Uri uri = Uri.parse(url);

    print('Launching URL: $url');
    if (await canLaunchUrl(uri)) {
      print('Launching in external browser');
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      print('Could not launch $url');
    }
  }

  void _callOffice() {
    // 전화 거는 로직
  }

  void _onConsultingTypeCardTap(String consultationType) {
    // 상담 종류 선택 업데이트
    print('Selected consultation type: $consultationType');
    ref
        .read(consultationScheduleProvider.notifier)
        .selectConsultationType(consultationType);
    // 드롭다운 닫기
    _consultingTypeToggleDropdown();
    if (!_consultingDateAnimationController.isCompleted) {
      _consultingDateAnimationController.forward();
    }
  }

  void _onConsultingDateCardTap(DateTime consultationDate) {
    // 상담 종류 선택 업데이트
    print('Selected consultation type: $consultationDate');
    ref
        .read(consultationScheduleProvider.notifier)
        .selectDate(consultationDate);
    // 드롭다운 닫기
    _consultingDateToggleDropdown();
    if (!_consultingTimeAnimationController.isCompleted) {
      _consultingTimeAnimationController.forward();
    }
  }

  void _onConsultingTimeCardTap(
      TimeOfDay consultationTime, Function localSetState) {
    print('Selected consultation time: $consultationTime');
    ref
        .read(consultationScheduleProvider.notifier)
        .selectTime(consultationTime);
    localSetState(() {});
  }

  void _showBookingModal(BuildContext context, WidgetRef ref) async {
    // ViewModel의 상태를 구독

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            //상담 종류 선택
            final selectedConsultationType =
                ref.watch(consultationScheduleProvider).consultationType;
            //나중에 전문가들이 가능한 상담 종류를 선택할 예정, 지금은 empty를 3개다 default로 해놓음
            final consultationOptions =
                ref.watch(expertConsultationOptionsProvider);

            //날짜 선택
            DateTime? selectedDate =
                ref.watch(consultationScheduleProvider).date;
            //날짜 선택 후 listile의 title에 날짜 목록을 넣기위한 방법
            final datetitleText = selectedDate != null
                ? DateFormat('MM/dd (E)').format(selectedDate)
                : '날짜 선택';

            TimeOfDay? selectedTime =
                ref.watch(consultationScheduleProvider).time;

            final timetitleText = selectedTime != null
                ? '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}'
                : '시간 선택';

            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(
                    bottom: Sizes.size96,
                  ),
                  children: [
                    Gaps.v20,

                    // 날짜와 시간을 위한 SizeTransition과 ListTile을 비슷한 방식으로 구현...
                    ListTile(
                      title: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.phone,
                            size: Sizes.size14,
                          ),
                          Gaps.h10,
                          Text(
                            selectedConsultationType ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.size14,
                            ),
                          ),
                        ],
                      ),
                      trailing: RotationTransition(
                        turns: _consultingTypeAnimation,
                        child: const Icon(Icons.expand_more),
                      ),
                      onTap: () => _consultingTypeToggleDropdown(),
                    ),
                    SizeTransition(
                      sizeFactor: _consultingTypeAnimation,
                      child: SizedBox(
                        height: 100, // 적절한 높이 설정
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: verticalPadding,
                          ),
                          scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                          itemCount: consultationOptions
                              .availableConsultationTypes.length,
                          itemBuilder: (context, index) {
                            final type = consultationOptions
                                .availableConsultationTypes[index];
                            return ConsultingTypeBox(
                              type: type,
                              selectedType: ref
                                      .watch(consultationScheduleProvider)
                                      .consultationType ??
                                  "", // 현재 선택된 상담 종류 변수, 기본값 설정
                              onTap: () {
                                ref
                                    .read(consultationScheduleProvider.notifier)
                                    .selectConsultationType(type);
                                // 필요한 경우 상태 업데이트 로직
                                _onConsultingTypeCardTap(type);
                                setState(
                                  () {},
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.calendarDay,
                            size: Sizes.size14,
                          ),
                          Gaps.h10,
                          Text(
                            datetitleText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.size14,
                            ),
                          ),
                        ],
                      ),
                      trailing: RotationTransition(
                        turns: _consultingDateAnimation,
                        child: const Icon(Icons.expand_more),
                      ),
                      onTap: () {
                        _consultingDateToggleDropdown();
                      },
                    ),
                    SizeTransition(
                      sizeFactor: _consultingDateAnimation,
                      child: SizedBox(
                          height: 120, // 적절한 높이 설정
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: verticalPadding,
                            ),
                            separatorBuilder: (context, index) => Gaps.h10,
                            scrollDirection: Axis.horizontal,
                            itemCount: ref
                                .watch(expertConsultationOptionsProvider)
                                .availableDates
                                .length,
                            itemBuilder: (context, index) {
                              final date = ref
                                  .watch(expertConsultationOptionsProvider)
                                  .availableDates[index];
                              final isSelected = selectedDate == date;
                              bool isToday =
                                  DateTime.now().difference(date).inDays == 0 &&
                                      date.day == DateTime.now().day;

                              return GestureDetector(
                                onTap: () {
                                  _onConsultingDateCardTap(date);
                                  setState(
                                    () {},
                                  );
                                  // 날짜 선택 핸들러 호출
                                },
                                child: Container(
                                  height: 80,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey[200], // 조건부 배경색 설정
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SizedBox(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('${date.day}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        // 오늘 날짜에는 특별한 텍스트 표시
                                        isToday
                                            ? const Text('오늘',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.orange))
                                            : Text(DateFormat('E').format(date),
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.clock,
                            size: Sizes.size14,
                          ),
                          Gaps.h10,
                          Text(
                            timetitleText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.size14,
                            ),
                          ),
                        ],
                      ),
                      trailing: RotationTransition(
                        turns: _consultingTimeAnimation,
                        child: const Icon(Icons.expand_more),
                      ),
                      onTap: () => _consultingTimeToggleDropdown(),
                    ),
                    SizedBox(
                      height: 300,
                      child: AnimatedBuilder(
                        animation: _positionAnimation,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              Positioned(
                                top: _positionAnimation
                                    .value, // 애니메이션에 의해 변경되는 위치
                                left: 0,
                                right: 0,
                                child: SizedBox(
                                  height: 150, // 적절한 높이 설정
                                  child: child,
                                ),
                              ),
                            ],
                          );
                        },
                        child: TimeSelectionWidget(
                          onTap: (TimeOfDay time) {
                            _onConsultingTimeCardTap(time, setState);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: consultingApplyBottomBar(
                    context,
                    ref,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    ref.read(consultationScheduleProvider.notifier).reset();
    if (_consultingTypeAnimationController.isCompleted) {
      _consultingTypeAnimationController.reverse();
    }
    if (_consultingDateAnimationController.isCompleted) {
      _consultingDateAnimationController.reverse();
    }
    if (_consultingTimeAnimationController.isCompleted) {
      _consultingTimeAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _consultingTypeAnimationController.dispose();
    _consultingDateAnimationController.dispose();
    _consultingTimeAnimationController.dispose();
    super.dispose();
  }

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
                  ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 5,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Sizes.size40,
                            horizontal: horizontalPadding,
                          ),
                          child: Text(
                            "윤상민 전문가의 경험을 토대로\n 전문성을 판단하세요",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Sizes.size18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 5,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: verticalPadding,
                            horizontal: horizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "주요분야",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: verticalPadding,
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8,
                                  runSpacing: 20,
                                  children: [
                                    MajorFieldTypeBox(
                                      icon: FontAwesomeIcons.certificate,
                                      text: "수의사 자격증",
                                    ),
                                    MajorFieldTypeBox(
                                      icon: FontAwesomeIcons.certificate,
                                      text: "수의사 자격증",
                                    ),
                                    MajorFieldTypeBox(
                                      icon: FontAwesomeIcons.certificate,
                                      text: "수의사 자격증",
                                    ),
                                    MajorFieldTypeBox(
                                      icon: FontAwesomeIcons.certificate,
                                      text: "수의사 자격증",
                                    ),
                                    MajorFieldTypeBox(
                                      icon: FontAwesomeIcons.certificate,
                                      text: "수의사 자격증",
                                    ),
                                    MajorFieldTypeBox(
                                      icon: FontAwesomeIcons.certificate,
                                      text: "수의사 자격증",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 5,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: verticalPadding,
                            horizontal: horizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "이력사항",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              Gaps.v10,
                              Text(
                                "경력",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size14,
                                ),
                              ),
                              Gaps.v10,
                              CustomTimelineEntry(
                                timeline: '2009-2010',
                                description: '대구지방검찰청 김천지청 검사',
                              ),
                              CustomTimelineEntry(
                                timeline: '2007-2009',
                                description: '의정부지방검찰청 고양지청 검사',
                              ),
                              CustomTimelineEntry(
                                timeline: '2005-2007',
                                description: '남부지방검찰청 고양지청 검사',
                              ),
                              Gaps.v20,
                              Text(
                                "자격",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size14,
                                ),
                              ),
                              Gaps.v10,
                              CustomTimelineEntry(
                                timeline: '2009-2010',
                                description: '대구지방검찰청 김천지청 검사',
                              ),
                              CustomTimelineEntry(
                                timeline: '2007-2009',
                                description:
                                    '의정부지방검찰청 고양지청 검사의정부지방검찰청 고양지청 검사의정부지방검찰청 고양지청 검사의정부지방검찰청 고양지청 검사의정부지방검찰청 고양지청 검사의정부지방검찰청 고양지청 검사의정부지방검찰청 고양지청 검사의정부지방검찰청 고양지청 검사',
                              ),
                              CustomTimelineEntry(
                                timeline: '2005-2007',
                                description: '남부지방검찰청 고양지청 검사',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 5,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: verticalPadding,
                            horizontal: horizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "가격정보",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                              Gaps.v10,
                              Gaps.v10,
                              ConsultationPriceList(),
                              Gaps.v20,
                              Text(
                                "서비스",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size14,
                                ),
                              ),
                              Gaps.v10,
                              CustomTimelineEntry(
                                timeline: '재활 치료',
                                description: '50,000원/ 1시간',
                              ),
                              CustomTimelineEntry(
                                timeline: '교정 치료',
                                description: '50,000원/ 1시간',
                              ),
                              CustomTimelineEntry(
                                timeline: '임신 치료',
                                description: '50,000원/ 1시간',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true, // 여기를 추가하세요
                    physics:
                        const NeverScrollableScrollPhysics(), // 그리고 여기도 추가하세요
                    itemCount: 10,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding,
                      ),
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
                          ref.read(screenProvider.notifier).state = true;
                        },
                      ),
                    ),
                  ),
                  ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 5,
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Sizes.size40,
                            horizontal: horizontalPadding,
                          ),
                          child: Text(
                            "실제 상담을 완료한 14건의 \n 고객 후기를 확인해보세요.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Sizes.size18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: verticalPadding,
                            horizontal: horizontalPadding,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "너무나 친절하시고 명쾌하십니다",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Sizes.size16,
                                    ),
                                  ),
                                  Gaps.v10,
                                  const Text(
                                    "답변의 내용도 너무나 명쾌하여 도움이 되었습니다. 오랜시간동안 의뢰인 입장에서 이야기 들어주시고 공감해주셔서 감사합니다. 너무 큰 도움이 되었습니다.",
                                    style: TextStyle(
                                      fontSize: Sizes.size12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Gaps.v20,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "전문가 진단",
                                        style: TextStyle(
                                          fontSize: Sizes.size12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Gaps.h5,
                                      Flexible(
                                        child: Text(
                                          '"이 사안은 법적으로 해결해야 하는 문제이며, 변호사 도움이 반드시 필요함"',
                                          style: TextStyle(
                                            fontSize: Sizes.size12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gaps.v20,
                                  const Row(
                                    children: [
                                      Text(
                                        "폭행/협박/상해 일반",
                                        style: TextStyle(
                                          fontSize: Sizes.size10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      VerticalDivider(
                                        width: 5,
                                        color: Colors.red,
                                        indent: 1,
                                        endIndent: 1,
                                        thickness: 5,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "고객 dm*********  2024년 4월 / 15분 전화상담 후기",
                                          style: TextStyle(
                                            fontSize: Sizes.size10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    onPressed: () => _showBookingModal(context, ref),
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

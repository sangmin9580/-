import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/consultantexample/view/consultationwriting_screen.dart';
import 'package:project/consultantexample/view/conultantexample_screen.dart';
import 'package:project/homepage/view/homepage_screen.dart';
import 'package:project/professor/view/professor_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  static const routeURL = '/home';
  static const routeName = 'home';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _tabBarselectedIndex = 0;
  int _navigationBarselctedIndex = 0;

  late final TabController _tabController;
  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _screenInitailize();
  }

// screens를 초기화하기 위해서 쓴 함수
  void _screenInitailize() {
    screens = _buildScreens();
  }

// bottomNavigationBar index에 따라서 Screen변화를 주기 위한 함수
  List<Widget> _buildScreens() {
    if (_tabBarselectedIndex != 2) {
      return [
        TabBarView(
          controller: _tabController,
          children: const [
            SingleChildScrollView(
              child: HomepageScreen(),
            ),
            SingleChildScrollView(
              child: ConsultantExampleScreen(),
            ),
            Center(
              child: Text('1'),
            ),
            // 전문가 화면으로 넘어가기 위해 그냥 끼어놓은 화면
          ],
        ),
        const ConsultationWritingScreen(),
        Container(
          color: Colors.green,
        ),
      ];
    } else {
      // _tabBarselectedIndex가 2인 경우, ProfessorScreen을 첫 번째 위치에 배치하고 나머지는 기존대로
      return [
        const ProfessorScreen(),
        const ConsultationWritingScreen(),
        Container(
          color: Colors.green,
        ),
      ];
    }
  }

  void _tabBarTap(int index) {
    _tabBarselectedIndex = index;
    _screenInitailize();
    // tabbarindex가 변화하면 _screenInitailize 값도 변할테니까 함수 넣어줌
    setState(() {});
  }

  void _navigationBarTap(int index) {
    _navigationBarselctedIndex = index;

    if (index == 0) {
      _tabBarselectedIndex = 0;
      _tabController.animateTo(index);
    }
    _screenInitailize();
    // tabbarindex가 변화하면 _screenInitailize 값도 변할테니까 함수 넣어줌
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBar = Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent, // splash 효과를 투명하게 설정
      ),
      child: BottomNavigationBar(
        currentIndex: _navigationBarselctedIndex,
        onTap: (index) => _navigationBarTap(index),
        iconSize: Sizes.size20,
        selectedFontSize: Sizes.size10,
        unselectedFontSize: Sizes.size8,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.circlePlus,
            ),
            label: "상담글 작성",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.user,
            ),
            label: "마이페이지",
          ),
        ],
      ),
    );

    if (_navigationBarselctedIndex == 1) {
      return Scaffold(
        body: screens[_navigationBarselctedIndex],
        bottomNavigationBar:
            bottomNavigationBar, // 이 부분은 예시로 추가한 부분입니다. 실제 코드에 맞게 조정하세요.
      );
    }

    return Scaffold(
      appBar: AppBar(
        // 나중에 누르면 홈오게 만들어야함.
        title: Text(
          "멍선생",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          FaIcon(
            FontAwesomeIcons.magnifyingGlass,
          ),
          Gaps.h10,
          Text(
            "로그인/가입",
          ),
          Gaps.h10,
        ],
        bottom: (_tabBarselectedIndex != 2 && _navigationBarselctedIndex == 0)
            ? TabBar(
                controller: _tabController,
                onTap: (value) => _tabBarTap(value),
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
                  Text("홈"),
                  Text("상담사례"),
                  Text("전문가"),
                ],
              )
            : null,
      ),
      body: screens[_navigationBarselctedIndex],
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/common/widgets/viewmodel/main_navigation_vm.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/consultantexample/view/consultationwriting_screen.dart';
import 'package:project/consultantexample/view/conultantexample_screen.dart';
import 'package:project/homepage/view/homepage_screen.dart';
import 'package:project/mypage/view/mypage_screen.dart';
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
  late final TabController _tabController;
  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    final state = ref.read(mainNavigationViewModelProvider);

    //_tabController 변경
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: state.tabBarSelectedIndex,
    );

    //_tabController addlistener를 통해 tabBar를 조정
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(mainNavigationViewModelProvider.notifier)
            .setTabBarSelectedIndex(_tabController.index);
      }
    });
  }

//

// bottomNavigationBar index에 따라서 Screen변화를 주기 위한 함수
  List<Widget> _buildScreens(
      int tabBarSelectedIndex, int navigationBarSelectedIndex) {
    if (tabBarSelectedIndex != 2) {
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
        const MyPageScreen(),
      ];
    } else {
      // _tabBarselectedIndex가 2인 경우, ProfessorScreen을 첫 번째 위치에 배치하고 나머지는 기존대로
      return [
        const ProfessorScreen(),
        const ConsultationWritingScreen(),
        const MyPageScreen(),
      ];
    }
  }

  void _navigationBarTap(int index) {
    final viewModel = ref.read(mainNavigationViewModelProvider.notifier);

    // 선택된 탭이 이미 활성화된 탭과 동일하면, tabBarSelectedIndex를 0으로 설정
    if (index ==
            ref
                .read(mainNavigationViewModelProvider)
                .navigationBarSelectedIndex &&
        index == 0) {
      viewModel.setTabBarSelectedIndex(0);
      _tabController.index = 0;
    }

    // 항상 navigationBarSelectedIndex를 업데이트
    viewModel.setNavigationBarSelectedIndex(index);
  }

// nivigation 값을 selectedindex에 따라 변경
  Widget _buildBottomNavigationBar(int selectedIndex, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        _navigationBarTap(index);
      },
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
    );
  }

  void _onAppbarTitleTap() {
    final state = ref.read(mainNavigationViewModelProvider.notifier);
    state.setNavigationBarSelectedIndex(0);
    _tabController.animateTo(0);
    state.setTabBarSelectedIndex(0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainNavigationViewModelProvider);
    List<Widget> screens = _buildScreens(
        state.tabBarSelectedIndex, state.navigationBarSelectedIndex);

    final bottomNavigationBar = Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // splash 효과를 투명하게 설정
        ),
        child:
            _buildBottomNavigationBar(state.navigationBarSelectedIndex, ref));

    if (state.navigationBarSelectedIndex != 0) {
      return Scaffold(
        body: screens[state.navigationBarSelectedIndex],
        bottomNavigationBar:
            bottomNavigationBar, // 이 부분은 예시로 추가한 부분입니다. 실제 코드에 맞게 조정하세요.
      );
    }

    return Scaffold(
      appBar: AppBar(
        // 나중에 누르면 홈오게 만들어야함.
        title: GestureDetector(
          onTap: _onAppbarTitleTap,
          child: Text(
            "멍선생",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              fontWeight: FontWeight.bold,
            ),
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
        bottom: (state.tabBarSelectedIndex != 2 &&
                state.navigationBarSelectedIndex == 0)
            ? TabBar(
                controller: _tabController,
                onTap: (index) {
                  ref
                      .read(mainNavigationViewModelProvider.notifier)
                      .setTabBarSelectedIndex(index);
                },
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
      body: IndexedStack(
        index: state
            .navigationBarSelectedIndex, // BottomNavigationBar의 선택에 따라 화면 전환
        children: screens,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

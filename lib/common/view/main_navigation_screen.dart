import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/feature/consultationcase/view/consultingexample_screen.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/common/widgets/bottomnavigationBar.dart';

import 'package:project/constants/gaps.dart';

import 'package:project/feature/consultationcase/view/consultingwriting_screen.dart';
import 'package:project/common/view/search_screen.dart';
import 'package:project/feature/homepage/view/homepage_screen.dart';
import 'package:project/feature/mypage/users/views/mypage_screen.dart';
import 'package:project/feature/professor/view/professor_select_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({
    super.key,
  });

  static const routeURL = '/main';
  static const routeName = 'main';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<Widget> screens = [];

  List<Widget> _buildScreens() {
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
          ProfessorSelectScreen(),
          // 전문가 화면으로 넘어가기 위해 그냥 끼어놓은 화면
        ],
      ),
      // SearchScreen을 Navigator로 감싸서 별도의 네비게이션 스택을 관리합니다.
      const SearchScreen(), // SearchScreen은 별도의 Navigator로 처리됩니다.
      const ConsultationWritingScreen(),
      const MyPageScreen(),
    ];
  }

  @override
  void initState() {
    super.initState();
    final mainNavProvider = ref.read(mainNavigationViewModelProvider);

    //_tabController 변경
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: mainNavProvider.tabBarSelectedIndex,
    );

    //_tabController addlistener를 통해 tabBar를 조정
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(tabControllerIndexProvider.notifier).state =
            _tabController.index;
        final tabIndex = ref.read(tabControllerIndexProvider.notifier).state;
        ref
            .read(mainNavigationViewModelProvider.notifier)
            .setTabBarSelectedIndex(tabIndex);
      }
    });
  }

//상담사례에서 내용전체보기 위한 값

// bottomNavigationBar index에 따라서 Screen변화를 주기 위한 함수

  void _onItemSelected(int index) {
    final mainNavProvider = ref.read(mainNavigationViewModelProvider.notifier);
    final mainNavCurrentState = ref.read(mainNavigationViewModelProvider);

    if (index == 0) {
      if (mainNavCurrentState.navigationBarSelectedIndex == 0) {
        // '홈' 탭을 한 번 더 눌렀을 때, 강제로 홈 화면 리셋

        _tabController.animateTo(index);
        ref.read(tabControllerIndexProvider.notifier).state = 0;
      } else if (mainNavProvider.wasProfessorTabPreviouslySelected) {
        ref.read(tabControllerIndexProvider.notifier).state =
            2; // 이전에 '전문가' 탭 선택 로직
      } else {
        // '전문가' 탭이 이전에 선택되지 않았다면, '홈' 인덱스로 설정
        mainNavProvider.setTabBarSelectedIndex(0);
      }
    } else {
      // 다른 탭 로직 처리

      mainNavProvider.setNavigationBarSelectedIndex(index);
    }

    // 선택된 탭이 이미 활성화된 탭과 동일하면, tabBarSelectedIndex를 0으로 설정
    if (index ==
            ref
                .read(mainNavigationViewModelProvider)
                .navigationBarSelectedIndex &&
        index == 0) {
      mainNavProvider.setTabBarSelectedIndex(0);

      ref.read(tabControllerIndexProvider.notifier).state = 0;
    }

    // 항상 navigationBarSelectedIndex를 업데이트
    mainNavProvider.setNavigationBarSelectedIndex(index);
    // index를 업데이트할때 상담사례에서 빠져나오게 함.
    ref.read(currentScreenProvider.notifier).state = index;
  }

// nivigation 값을 selectedindex에 따라 변경
  Widget buildBottomNavigationBar(int selectedIndex, WidgetRef ref) {
    return CustomBottomNavigationBar(
      onItemSelected: _onItemSelected,
      selectedIndex: selectedIndex,
    );
  }

  void _onAppbarTitleTap() {
    final state = ref.read(mainNavigationViewModelProvider.notifier);
    state.setNavigationBarSelectedIndex(0);
    _tabController.animateTo(0);
    state.setTabBarSelectedIndex(0);
  }

  void _onbodyTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainNavigationViewModelProvider);
    final mainNavigationViewModel =
        ref.watch(mainNavigationViewModelProvider.notifier);
    print("canpop : ${mainNavigationViewModel.canPop}");
    print("tabhistory : ${mainNavigationViewModel.tabHistory}");
    print("nav : ${mainNavigationViewModel.navigationBarHistory}");
    final bottomNavIndex = state
        .navigationBarSelectedIndex; // tab에 따라서 MainNavigationModel의 navigationBarSelectedIndex값이 변하고 그게 tabindex

    List<Widget> screens = _buildScreens();

    final bottomNavigationBar = Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // splash 효과를 투명하게 설정
        ),
        child: buildBottomNavigationBar(bottomNavIndex, ref));

    return PopScope(
      canPop: mainNavigationViewModel.canPop,
      onPopInvoked: (didPop) =>
          mainNavigationViewModel.handlePopScope(didPop, context),
      child: GestureDetector(
        onTap: _onbodyTap,
        child: Scaffold(
          appBar: bottomNavIndex == 0
              ? AppBar(
                  // 나중에 누르면 홈오게 만들어야함.
                  title: GestureDetector(
                    onTap: _onAppbarTitleTap,
                    child: Text(
                      "멍선생",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize:
                            Theme.of(context).textTheme.headlineSmall!.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () => _onItemSelected(1),
                      child: const FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                      ),
                    ),
                    Gaps.h10,
                    const Text(
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
                            FocusScope.of(context).unfocus();
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
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize,
                          ),
                          tabs: const [
                            Text("홈"),
                            Text("상담사례"),
                            Text("전문가"),
                          ],
                        )
                      : null,
                )
              : null,
          body: IndexedStack(
            index: bottomNavIndex, // BottomNavigationBar의 선택에 따라 화면 전환
            children: screens,
          ),
          bottomNavigationBar: bottomNavIndex == 0
              ? bottomNavigationBar
              : null, // 이 부분은 예시로 추가한 부분입니다. 실제 코드에 맞게 조정하세요.,
        ),
      ),
    );
  }
}

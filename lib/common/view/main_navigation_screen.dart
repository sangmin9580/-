import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/common/widgets/navigation_state.dart';
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
      if (!_tabController.indexIsChanging &&
          _tabController.previousIndex != _tabController.index) {
        ref
            .read(mainNavigationViewModelProvider.notifier)
            .setTabBarSelectedIndex(_tabController.index);
      }
    });
  }

// bottomNavigationBar index에 따라서 Screen변화를 주기 위한 함수

  void _onItemSelected(int index) {
    final mainNavProvider = ref.read(mainNavigationViewModelProvider.notifier);
    final mainNavCurrentState = ref.read(mainNavigationViewModelProvider);

    if (index == 0 && mainNavCurrentState.navigationBarSelectedIndex == 0) {
      // '홈' 탭을 한 번 더 눌렀을 때, 강제로 홈 화면 리셋

      _tabController.animateTo(index);
      mainNavProvider.setTabBarSelectedIndex(0);
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

  NavigationState popNavigationState() {
    final navigationHistory =
        ref.read(mainNavigationViewModelProvider.notifier).navigationHistory;
    if (navigationHistory.isNotEmpty) {
      return navigationHistory.removeLast();
    }
    // 로직에 따라 기본 상태 혹은 오류 처리 반환
    return NavigationState(0, 0); // 안전한 기본 상태 반환
  }

  void handlePopScope(bool didPop, BuildContext context) {
    final navigationHistory =
        ref.read(mainNavigationViewModelProvider.notifier).navigationHistory;

    if (navigationHistory.length > 1) {
      // 최소 두 개의 항목이 있을 때만 pop 실행
      navigationHistory.removeLast(); // 현재 상태 제거
      NavigationState newCurrentState = navigationHistory.last; // 새로운 현재 상태
      _tabController
          .animateTo(newCurrentState.tabIndex); // 새로운 현재 상태로 탭 컨트롤러 이동
    } else {
      // 뒤로 갈 이력이 없을 때의 처리, 예: 앱 종료 확인
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Exit"),
            content: const Text("Do you really want to exit the app?"),
            actions: <Widget>[
              TextButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  SystemNavigator.pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainNavigationViewModelProvider);

    final bottomNavIndex = state
        .navigationBarSelectedIndex; // tab에 따라서 MainNavigationModel의 navigationBarSelectedIndex값이 변하고 그게 tabindex

    List<Widget> screens = _buildScreens();

    final bottomNavigationBar = Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // splash 효과를 투명하게 설정
        ),
        child: buildBottomNavigationBar(bottomNavIndex, ref));

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          handlePopScope(didPop, context);
        } else {
          // 팝을 수행할 수 없을 때의 로직, 예를 들어 경고 메시지 표시
        }
      },
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

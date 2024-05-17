import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/common/viewmodel/navigation_history_state_vm.dart';
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
    bool isInitialSetup = ref.read(isInitialSetupProvder);

    //_tabController 변경
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: mainNavProvider.tabBarSelectedIndex,
    );

    _tabController.animation!.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        // 애니메이션이 완료되었을 때 isPop 상태를 false로 설정
        ref.read(isPopNavigationProvider.notifier).state = false;
      }
    });

    //_tabController addlistener를 통해 tabBar를 조정
    _tabController.addListener(() {
      print("isPop : ${ref.read(isPopNavigationProvider)}");
      if (!_tabController.indexIsChanging &&
          _tabController.previousIndex != _tabController.index &&
          !isInitialSetup) {
        ref
            .read(mainNavigationViewModelProvider.notifier)
            .setTabBarSelectedIndex(_tabController.index);
        isInitialSetup = true;
        print("901");
      }
    });
  }

// bottomNavigationBar index에 따라서 Screen변화를 주기 위한 함수

  void _onItemSelected(int index) {
    print("_onItemSelected callback");

    final mainNavProvider = ref.read(mainNavigationViewModelProvider.notifier);
    final mainNavCurrentState = ref.read(mainNavigationViewModelProvider);

    if (index == 0 && mainNavCurrentState.navigationBarSelectedIndex == 0) {
      // '홈' 탭을 한 번 더 눌렀을 때, 강제로 홈 화면 리셋

      _tabController.animateTo(index);
      mainNavProvider.setTabBarSelectedIndex(0);
    }

    // 항상 navigationBarSelectedIndex를 업데이트
    if (!ref.read(isPopNavigationProvider.notifier).state) {
      print("isPop:  ${!ref.read(isPopNavigationProvider.notifier).state}");
      mainNavProvider.setNavigationBarSelectedIndex(index);
    }
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
    print("2");
    state.setNavigationBarSelectedIndex(0);
    _tabController.animateTo(0);
    state.setTabBarSelectedIndex(0);
    print("3");
  }

  void _onbodyTap() {
    FocusScope.of(context).unfocus();
  }

  void handlePopScope(bool didPop, BuildContext context) {
    final MainNavigationViewModel =
        ref.read(mainNavigationViewModelProvider.notifier);
    final navHistory = ref.read(navigationHistoryProvider.notifier);
    final navHistoryState = ref.read(navigationHistoryProvider);

    ref.read(isPopNavigationProvider.notifier).state = true;
    if (navHistoryState.length > 1) {
      // 최소 두 개의 항목이 있을 때만 pop 실행
      final navHistoryNewState = navHistoryState.sublist(
          0, ref.read(navigationHistoryProvider).length - 1);
      navHistory.setState(navHistoryNewState);

      // 새로운 현재 상태
      final lastIndexs = navHistoryNewState.last;

      _tabController.animateTo(
        lastIndexs.tabIndex,
      ); // 새로운 현재 상태로 탭 컨트롤러 이동
      MainNavigationViewModel.setTabBarSelectedIndex(lastIndexs.tabIndex,
          isFromPop: true);
      MainNavigationViewModel.setNavigationBarSelectedIndex(
          lastIndexs.navBarIndex,
          isFromPop: true);
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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(isPopNavigationProvider.notifier).state = false;
    });
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
        } else {}
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
                            print("902");

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

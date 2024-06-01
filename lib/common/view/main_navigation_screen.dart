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
import 'package:project/feature/search/views/search_screen.dart';
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
        ],
      ),
      const SearchScreen(),
      const ConsultationWritingScreen(),
      const MyPageScreen(),
    ];
  }

  @override
  void initState() {
    super.initState();
    final mainNavProvider = ref.read(mainNavigationViewModelProvider);
    bool isInitialSetup = ref.read(isInitialSetupProvder);

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: mainNavProvider.tabBarSelectedIndex,
    );

    ref
        .read(mainNavigationViewModelProvider.notifier)
        .setTabController(_tabController);

    _tabController.animation!.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        ref.read(isPopNavigationProvider.notifier).state = false;
      }
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging &&
          _tabController.previousIndex != _tabController.index &&
          !isInitialSetup) {
        ref
            .read(mainNavigationViewModelProvider.notifier)
            .setTabBarSelectedIndex(_tabController.index);
        isInitialSetup = true;
      }
    });
  }

  void _onItemSelected(int index) {
    final mainNavProvider = ref.read(mainNavigationViewModelProvider.notifier);
    final mainNavCurrentState = ref.read(mainNavigationViewModelProvider);

    if (index == 0 && mainNavCurrentState.navigationBarSelectedIndex == 0) {
      _tabController.animateTo(index);
      mainNavProvider.setTabBarSelectedIndex(0);
    }

    if (!ref.read(isPopNavigationProvider.notifier).state) {
      mainNavProvider.setNavigationBarSelectedIndex(index);
    }
    ref.read(currentScreenProvider.notifier).state = index;
  }

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

  void handlePopScope(bool didPop, BuildContext context) {
    final mainNavProvider = ref.read(mainNavigationViewModelProvider.notifier);
    final navHistory = ref.read(navigationHistoryProvider.notifier);
    final navHistoryState = ref.read(navigationHistoryProvider);

    ref.read(isPopNavigationProvider.notifier).state = true;

    if (navHistoryState.length > 1) {
      final navHistoryNewState = navHistoryState.sublist(
          0, ref.read(navigationHistoryProvider).length - 1);
      navHistory.setState(navHistoryNewState);

      final lastIndexs = navHistoryNewState.last;

      _tabController.animateTo(lastIndexs.tabIndex);
      mainNavProvider.setTabBarSelectedIndex(lastIndexs.tabIndex,
          isFromPop: true);
      mainNavProvider.setNavigationBarSelectedIndex(lastIndexs.navBarIndex,
          isFromPop: true);
    } else {
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
    final currentIndex = ref.read(currentScreenProvider);
    final isConsultingScreenActive = currentIndex == 2;
    final bottomNavIndex = state.navigationBarSelectedIndex;

    List<Widget> screens = _buildScreens();

    final bottomNavigationBar = Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
        ),
        child: buildBottomNavigationBar(bottomNavIndex, ref));

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop && !isConsultingScreenActive) {
          handlePopScope(didPop, context);
        }
      },
      child: GestureDetector(
        onTap: _onbodyTap,
        child: Scaffold(
          appBar: bottomNavIndex == 0
              ? AppBar(
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
            index: bottomNavIndex,
            children: screens,
          ),
          bottomNavigationBar: bottomNavIndex == 0 ? bottomNavigationBar : null,
        ),
      ),
    );
  }
}

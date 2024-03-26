import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _tabBarTap(int index) {
    _tabBarselectedIndex = index;

    setState(() {});
  }

  void _navigationBarTap(int index) {
    _navigationBarselctedIndex = index;

    if (index == 0) {
      _tabBarselectedIndex = 0;
      _tabController.animateTo(index);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        bottom: _tabBarselectedIndex != 2
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
      body: _tabBarselectedIndex != 2
          ? TabBarView(
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
              ],
            )
          : const ProfessorScreen(),
      bottomNavigationBar: BottomNavigationBar(
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
  }
}

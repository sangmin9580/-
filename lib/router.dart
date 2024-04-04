import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/common/view/main_navigation_screen.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/professor/view/professor_navigation_screen.dart';

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: MainNavigationScreen.routeURL,
      routes: [
        GoRoute(
          path: "/:tab(home|search|consult|mypage)",
          name: MainNavigationScreen.routeName,
          builder: (context, state) {
            final tab = state.pathParameters['tab']!;
            ref
                .read(mainNavigationViewModelProvider.notifier)
                .setTabFromRoute(tab);
            return const MainNavigationScreen();
          },
        ),
        GoRoute(
          path: ProfessorNavigationScreen.routerURL,
          name: ProfessorNavigationScreen.routerName,
          builder: (context, state) {
            return const ProfessorNavigationScreen();
          },
        ),
      ],
    );
  },
);

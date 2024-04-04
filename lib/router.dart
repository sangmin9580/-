import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/common/view/main_navigation_screen.dart';
import 'package:project/professor/view/professor_navigation_screen.dart';

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: MainNavigationScreen.routeURL,
      routes: [
        GoRoute(
          path: MainNavigationScreen.routeURL,
          name: MainNavigationScreen.routeName,
          builder: (context, state) => const MainNavigationScreen(),
        ),
        GoRoute(
          path: ProfessorNavigationScreen.routerURL,
          name: ProfessorNavigationScreen.routerName,
          builder: (context, state) => const ProfessorNavigationScreen(),
        ),
      ],
    );
  },
);

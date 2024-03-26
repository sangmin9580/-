import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/common/widgets/main_navigation_screen.dart';

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: MainNavigationScreen.routeURL,
      routes: [
        GoRoute(
          path: MainNavigationScreen.routeURL,
          name: MainNavigationScreen.routeName,
          builder: (context, state) => const MainNavigationScreen(),
        )
      ],
    );
  },
);

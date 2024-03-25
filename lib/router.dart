import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/common/widgets/main_navigation_screen.dart';

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: MainNavgationScreen.routeURL,
      routes: [
        GoRoute(
          path: MainNavgationScreen.routeURL,
          name: MainNavgationScreen.routeName,
          builder: (context, state) => const MainNavgationScreen(),
        )
      ],
    );
  },
);

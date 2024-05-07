import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/common/view/consent_screen.dart';
import 'package:project/common/view/main_navigation_screen.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/feature/authentication/repo/authentication_repo.dart';
import 'package:project/feature/authentication/views/login_screen.dart';
import 'package:project/feature/authentication/views/signup_screen.dart';
import 'package:project/feature/mypage/pets/views/pet_navigation_screen.dart';
import 'package:project/feature/professor/view/professor_navigation_screen.dart';
import 'package:project/feature/professor/view/professor_screen.dart';

final routerProvider = Provider.family<GoRouter, bool>(
  (ref, isFirstRun) {
    print('Router is being initialized with isFirstRun: $isFirstRun');
    return GoRouter(
      // isFirstRun이 true이면 동의 화면의 경로를, 아니면 메인 화면의 경로를 초기 위치로 설정합니다.
      initialLocation: isFirstRun ? ConsentScreen.routerURL : "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.matchedLocation != SignUpScreen.routeURL &&
              state.matchedLocation != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      debugLogDiagnostics: true, // 디버그 로깅 활성화
      routes: [
        // 동의 화면에 해당하는 GoRoute 추가 (ConsentScreen 구현 필요)
        GoRoute(
          path: ConsentScreen.routerURL,
          name: ConsentScreen.routerName,
          builder: (context, state) => const ConsentScreen(),
        ),
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),

        GoRoute(
          path: "/:tab(home|search|consult|mypage)",
          name: MainNavigationScreen.routeName,
          builder: (context, state) {
            final tab = state.pathParameters['tab']!;

            Future.microtask(
              () => ref
                  .read(mainNavigationViewModelProvider.notifier)
                  .setTabFromRoute(tab),
            );
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

        GoRoute(
          path: ProfessorScreen.routerURL,
          name: ProfessorScreen.routerName,
          builder: (context, state) => const ProfessorScreen(),
        ),
        GoRoute(
          path: PetNavigationScreen.routeURL,
          name: PetNavigationScreen.routeName,
          builder: (context, state) => const PetNavigationScreen(),
        ),
      ],
    );
  },
);

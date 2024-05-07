import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/feature/mypage/pets/repo/notification_repository.dart';
import 'package:project/firebase_options.dart';

import 'package:project/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //app이 시작되기 전에 모든 준비를 마칠 수 있도록 하는 행위
  // 앱 설정을 앱 시작전 미리 하기 위해서 설정
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('firstRun') ?? true;
  runApp(
    ProviderScope(
      overrides: [
        // SharedPreferences 인스턴스를 사용하여 NotificationRepository 인스턴스를 생성하고 제공합니다.
        notificationRepoProvider
            .overrideWithValue(NotificationRepository(prefs)),
      ],
      // ProviderScope의 자식으로 MyApp을 항상 실행하되, isFirstRun 값을 routerProvider에 전달합니다.
      child: MyApp(isFirstRun: isFirstRun),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool isFirstRun;

  const MyApp({
    super.key,
    required this.isFirstRun,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirstRunFuture = ref.watch(isFirstRunProvider);
    return isFirstRunFuture.when(
      data: (isFirstRun) {
        // isFirstRun 값에 따라 GoRouter의 initialLocation을 조건적으로 설정합니다.
        final router = ref.watch(routerProvider(isFirstRun));

        return MaterialApp.router(
          routeInformationProvider: router.routeInformationProvider,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          // Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
          theme: FlexThemeData.light(
            colors: const FlexSchemeColor(
              primary: Color(0xffc78d20),
              primaryContainer: Color(0xffdeb059),
              secondary: Color(0xff8d9440),
              secondaryContainer: Color(0xffbfc39b),
              tertiary: Color(0xff616247),
              tertiaryContainer: Color(0xffbcbca8),
              appBarColor: Color(0xffbfc39b),
              error: Color(0xffb00020),
            ),
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 7,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              alignedDropdown: true,
              useInputDecoratorThemeInDialogs: true,
            ),
            useMaterial3ErrorColors: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            // To use the Playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            colors: const FlexSchemeColor(
              primary: Color(0xffdeb059),
              primaryContainer: Color(0xffc78d20),
              secondary: Color(0xffafb479),
              secondaryContainer: Color(0xff82883d),
              tertiary: Color(0xff81816c),
              tertiaryContainer: Color(0xff5a5a35),
              appBarColor: Color(0xff82883d),
              error: Color(0xffcf6679),
            ),
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 13,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 20,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              alignedDropdown: true,
              useInputDecoratorThemeInDialogs: true,
            ),
            useMaterial3ErrorColors: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            // To use the Playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (e, stack) => const MaterialApp(
        home: Scaffold(body: Center(child: Text('Error loading preferences'))),
      ),
    );
  }
}

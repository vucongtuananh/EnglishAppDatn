import 'package:english_learning_app/pages/auth/login_view.dart';
import 'package:english_learning_app/pages/auth/register_view.dart';
import 'package:english_learning_app/pages/home/home.dart';
import 'package:english_learning_app/pages/main/main_page.dart';
import 'package:english_learning_app/pages/maps/map_screen.dart';
import 'package:english_learning_app/pages/questions/questions_screen.dart';
import 'package:english_learning_app/pages/questions/result_screen.dart';
import 'package:english_learning_app/pages/topics/topic_screen.dart';
import 'package:english_learning_app/utils/app_util.dart';
import 'package:go_router/go_router.dart';

import 'app_route_name.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: AppUtil.navigatorKey,
  initialLocation: AppRouteName.main,
  routes: [
    GoRoute(
      path: AppRouteName.main,
      builder: (context, state) => MainPage(),
    ),
    GoRoute(
      path: AppRouteName.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRouteName.signup,
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
        path: AppRouteName.map,
        builder: (context, state) {
          final mapId = state.extra as String;
          return MapScreen(mapId: mapId);
        }),
    GoRoute(
      path: AppRouteName.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRouteName.result,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final score = extra['score'] as int? ?? 0;
        final percent = extra['percent'] as int? ?? 0;
        final time = extra['time'] as String? ?? '';
        return ResultScreen(
          score: score,
          percent: percent,
          time: time,
        );
      },
    ),
    GoRoute(
        path: AppRouteName.question,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final lessonId = extra['lessonId'] as String? ?? '0';
          final level = extra['level'] as String? ?? '1';
          return QuestionScreen(
            lessonId: int.parse(lessonId),
            level: int.parse(level),
          );
        }),
    GoRoute(
      path: AppRouteName.topic,
      builder: (context, state) => TopicScreen(),
    ),
  ],
);

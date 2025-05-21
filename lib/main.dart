import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:english_learning_app/router/app_router.dart';
import 'package:english_learning_app/service/data_client_service.dart';
import 'package:english_learning_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataClient.instance.initialize();
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1 / 2),
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,

        color: AppStyle.color.primary,
        // locale: context.locale,
        // supportedLocales: context.supportedLocales,
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        //   DefaultCupertinoLocalizations.delegate,
        //   ...context.localizationDelegates,
        // ],

        // theme: ThemeData(
        //   scaffoldBackgroundColor: Colors.white,
        //   canvasColor: Colors.white,
        //   useMaterial3: false,
        //   pageTransitionsTheme: PageTransitionsTheme(
        //     builders: {
        //       TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        //       TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
        //     },
        //   ),
        //   primaryColor: AppStyle.color.primary,
        //   primaryColorLight: AppStyle.color.primary,
        //   primaryColorDark: AppStyle.color.primaryBackground,
        //   appBarTheme: AppBarTheme(
        //       shadowColor: Colors.transparent,
        //       color: AppStyle.color.primary,
        //       actionsIconTheme: IconThemeData(
        //         color: AppStyle.color.primary,
        //       )),
        //   colorScheme: ColorScheme.fromSwatch().copyWith(
        //       primary: AppStyle.color.primary,
        //       onPrimary: AppStyle.color.primary, // appbar leading icon color
        //       secondary: AppStyle.color.primary, // checkbox color
        //       onSecondary: Colors.white, // floating text color,
        //       primaryContainer: AppStyle.color.primaryBackground, //image backgound,
        //       outline: AppStyle.color.primary),
        // ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      return Future.value(false);
    }
    return Future.value(true);
  }
}

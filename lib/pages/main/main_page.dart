import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../utils/app_style.dart';
import '../../utils/app_util.dart';
import '../../viewmodels/main_viewmodel.dart';
import '../auth/login_view.dart';
import '../home/home.dart';

final _vmProvider = ChangeNotifierProvider((ref) => MainViewModel());

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Platform.isAndroid ? Colors.white : null,
      // status bar color
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
    ));

    var vm = ref.watch(_vmProvider);
    if (vm.outDatedApp) {
      if (!vm.outDatedAppDialogShown) {
        vm.outDatedAppDialogShown = true;
        _showOutdatedApp(vm).whenComplete(() {});
      }
    }

    if (!vm.loggedIn) {
      return LoginPage();
    }

    // if (vm.selectedIndex == 0 && !AppUtil.isAdminOrManager()) vm.selectedIndex = 2;
    return VisibilityDetector(
      key: Key("MainPage"),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 1) {
          // vm.showMessageByNotification();
        }
      },
      child: Scaffold(
        body: HomePage(),
      ),
    );
  }

  Future<void> _showOutdatedApp(MainViewModel vm) async {
    return Future(() {
      showModalBottomSheet(
        context: AppUtil.navigatorKey.currentContext!,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image(image: AssetImage('lib/images/inforactinforact.png')),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Salework mobile",
                            style: TextStyle(
                              fontSize: AppStyle.dimen.fontSizeTitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "new_version_available",
                            style: TextStyle(
                              fontSize: AppStyle.dimen.fontSizeTitleConversation,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 1,
                  color: AppStyle.color.brButtonUnSuccess,
                ),
                Text(
                  "update_for_better_experience",
                  style: TextStyle(
                    fontSize: AppStyle.dimen.fontSizeTitleConversation,
                    height: 1.4,
                  ),
                ),
                Spacer(),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // if (Platform.isIOS)
                      //   launch(vm.version.iosAppLink!);
                      // else
                      //   launch(vm.version.androidAppLink!);
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black12),
                        borderRadius: BorderRadius.circular(8),
                        color: AppStyle.color.success,
                      ),
                      child: Center(
                        child: Text(
                          'update',
                          style: TextStyle(color: Colors.white, fontSize: AppStyle.dimen.radiusLarge, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    });
  }
}

import 'package:english_learning_app/router/app_route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_util.dart';
import '../models/viewmodel_base.dart';
import '../service/data_client_service.dart';

class MainViewModel extends ViewModelBase {
  static final MainViewModel _instance = MainViewModel._internal();

  factory MainViewModel() {
    if (DataClient.indexMainPageSelection == null) {
      _instance.selectedIndex = 0;
    } else {
      _instance.selectedIndex = DataClient.indexMainPageSelection;
    }
    return _instance;
  }

  MainViewModel._internal();

  bool showRegisterPage = false;

  bool isLoadAccount = false;
  bool loggedIn = false;
  int? selectedIndex = 0;

  bool outDatedApp = false;
  bool outDatedAppDialogShown = false;

  bool showConnectAccount = false;
  bool showDialogAccountDisconnect = false;

  void setOutDatedApp(bool outDated) {
    this.outDatedApp = outDated;
    notifyListeners();
  }

  void setShowRegisterPage(value) {
    this.showRegisterPage = value;
    notifyListeners();
  }

  void setShowAccountConnectPage(value) {
    this.showConnectAccount = value;
    notifyListeners();
  }

  void setLoggedIn(bool loggedIn) {
    if (loggedIn == true) {
      selectedIndex = 0;
      this.showRegisterPage = false;
      if (AppUtil.navigatorKey.currentContext != null) {
        GoRouter.of(AppUtil.navigatorKey.currentContext!).go(AppRouteName.home);
      }
    } else {
      isLoadAccount = true;
      DataClient.logout();
      if (AppUtil.navigatorKey.currentContext != null) {
        GoRouter.of(AppUtil.navigatorKey.currentContext!).go(AppRouteName.login);
      }
    }
    this.loggedIn = loggedIn;
    notifyListeners();
  }
}

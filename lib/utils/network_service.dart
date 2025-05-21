import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:english_learning_app/utils/app_util.dart';


class NetworkService {
  final Connectivity connectivity = Connectivity();

  static bool isConnected = true;
  static bool? showNotifyConnect;

  void startMonitoring() {
    connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.last == ConnectivityResult.none) {
        if (showNotifyConnect != null && isConnected && showNotifyConnect!) {
          showNotifyConnect = false;
          AppUtil.showToastError("Vui lòng kiểm tra kết nối mạng");
        }
        isConnected = false;
      } else {
        if (!isConnected && showNotifyConnect != null) AppUtil.showToastSuccess("Kết nối mạng thành công");
        isConnected = true;
        showNotifyConnect = true;
      }
    });
  }

  Future<bool> isConnect() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      AppUtil.showToastError("Vui lòng kiểm tra kết nối mạng");
      showNotifyConnect = null;
      isConnected = false;
      return false;
    }
    isConnected = true;
    return true;
  }
}

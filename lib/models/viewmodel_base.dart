import 'package:flutter/cupertino.dart';

abstract class ViewModelBase extends ChangeNotifier {
  bool isLoading = false;
}

class VmValueChangeNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

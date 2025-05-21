import 'package:english_learning_app/viewmodels/home_page_viewmodel.dart';
import 'package:english_learning_app/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider(
  (ref) => LoginViewModel(),
);

final homePageProvider = ChangeNotifierProvider(
  (ref) => HomePageViewModel(),
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final HomePageViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ref.read(homePageProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Only watching the currentIndex for rebuilds
    final currentIndex = ref.watch(homePageProvider.select((vm) => vm.currentIndex));

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: vm.bottomnavigationBarItems,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        onTap: vm.onItemTapped,
      ),
      body: PageView(
        controller: vm.pageController,
        onPageChanged: vm.onPageChanged,
        children: vm.pages.map((page) =>
            // Keep state alive
            KeepAliveWidget(child: page)).toList(),
      ),
    );
  }

  Widget itemAppBar(String image, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(image, height: 25),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

// Add a KeepAlive widget to preserve state of each page
class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  const KeepAliveWidget({super.key, required this.child});

  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
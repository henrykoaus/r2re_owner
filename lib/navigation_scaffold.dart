import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const NavigationScaffold({
    required this.child,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AdaptiveScaffold(
        selectedIndex: selectedIndex,
        useDrawer: false,
        transitionDuration: const Duration(seconds: 0),
        body: (_) => child,
        onSelectedIndexChange: (idx) {
          if (idx == 0) goRouter.go('/feed/restaurant_info');
          if (idx == 1) goRouter.go('/payment/payment_request');
          if (idx == 2) goRouter.go('/settings');
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            label: '가게정보',
            icon: Icon(
              Icons.menu,
              color: Colors.black54,
            ),
          ),
          NavigationDestination(
            label: '계산',
            icon: Icon(
              Icons.payment,
              color: Colors.black54,
            ),
          ),
          NavigationDestination(
            label: '세팅',
            icon: Icon(
              Icons.settings,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

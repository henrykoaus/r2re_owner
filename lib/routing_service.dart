import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:r2reowner/fade_transition_page.dart';
import 'package:r2reowner/navigation_scaffold.dart';
import 'package:r2reowner/screens/auth_screen/pages/approval_page.dart';
import 'package:r2reowner/screens/auth_screen/auth_screen.dart';
import 'package:r2reowner/screens/auth_screen/pages/email_verification.dart';
import 'package:r2reowner/screens/auth_screen/pages/entry_data_input.dart';
import 'package:r2reowner/screens/auth_screen/pages/forgot_password.dart';
import 'package:r2reowner/screens/feed_screen/feed_screen.dart';
import 'package:r2reowner/screens/feed_screen/pages/deal_offer_page.dart';
import 'package:r2reowner/screens/feed_screen/pages/restaurant_info_page.dart';
import 'package:r2reowner/screens/feed_screen/pages/sales_history.dart';
import 'package:r2reowner/screens/payment_screen/payment_history_page.dart';
import 'package:r2reowner/screens/payment_screen/payment_request_page.dart';
import 'package:r2reowner/screens/payment_screen/payment_screen.dart';
import 'package:r2reowner/screens/settings_screen.dart';

final appShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'app shell');

class RoutingService {
  final router = GoRouter(
    initialLocation: '/auth',
    routes: [
      ShellRoute(
        navigatorKey: appShellNavigatorKey,
        builder: (context, state, child) {
          return NavigationScaffold(
            selectedIndex: switch (state.uri.path) {
              var p when p.startsWith('/feed') => 0,
              var p when p.startsWith('/payment') => 1,
              var p when p.startsWith('/settings') => 2,
              _ => 0,
            },
            child: child,
          );
        },
        routes: [
          ShellRoute(
            pageBuilder: (context, state, child) {
              return FadeTransitionPage<dynamic>(
                key: state.pageKey,
                child: Builder(
                  builder: (context) {
                    return FeedScreen(
                      onTap: (idx) {
                        GoRouter.of(context).go(switch (idx) {
                          0 => '/feed/restaurant_info',
                          1 => '/feed/deal_offer',
                          2 => '/feed/sales_history',
                          _ => '/feed/restaurant_info',
                        });
                      },
                      selectedIndex: switch (state.uri.path) {
                        var p when p.startsWith('/feed/restaurant_info') => 0,
                        var p when p.startsWith('/feed/deal_offer') => 1,
                        var p when p.startsWith('/feed/sales_history') => 2,
                        _ => 0,
                      },
                      child: child,
                    );
                  },
                ),
              );
            },
            routes: [
              GoRoute(
                path: '/feed/restaurant_info',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: Builder(
                      builder: (context) {
                        return const RestaurantInfoPage();
                      },
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/feed/deal_offer',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: Builder(
                      builder: (context) {
                        return const DealOfferPage();
                      },
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/feed/sales_history',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: Builder(
                      builder: (context) {
                        return const SalesHistoryPage();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          ShellRoute(
            pageBuilder: (context, state, child) {
              return FadeTransitionPage<dynamic>(
                key: state.pageKey,
                child: Builder(
                  builder: (context) {
                    return PaymentScreen(
                      onTap: (idx) {
                        GoRouter.of(context).go(switch (idx) {
                          0 => '/payment/payment_request',
                          1 => '/payment/payment_history',
                          _ => '/payment/payment_request',
                        });
                      },
                      selectedIndex: switch (state.uri.path) {
                        var p when p.startsWith('/payment/payment_request') =>
                          0,
                        var p when p.startsWith('/payment/payment_history') =>
                          1,
                        _ => 0,
                      },
                      child: child,
                    );
                  },
                ),
              );
            },
            routes: [
              GoRoute(
                path: '/payment/payment_request',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: Builder(
                      builder: (context) {
                        return const PaymentRequestPage();
                      },
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/payment/payment_history',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: Builder(
                      builder: (context) {
                        return const PaymentHistoryPage();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) {
              return FadeTransitionPage<dynamic>(
                key: state.pageKey,
                child: const SettingsScreen(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) {
          return Builder(
            builder: (context) {
              return const AuthScreen();
            },
          );
        },
      ),
      GoRoute(
        path: '/auth/forgot_password',
        builder: (context, state) {
          return Builder(
            builder: (context) {
              return const ForgotPassword();
            },
          );
        },
      ),
      GoRoute(
        path: '/auth/email_verification',
        builder: (context, state) {
          return Builder(
            builder: (context) {
              return const EmailVerification();
            },
          );
        },
      ),
      GoRoute(
        path: '/auth/entry_data_input',
        builder: (context, state) {
          return Builder(
            builder: (context) {
              return const EntryDataInput();
            },
          );
        },
      ),
      GoRoute(
        path: '/auth/approval',
        builder: (context, state) {
          return Builder(
            builder: (context) {
              return const ApprovalPage();
            },
          );
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      final bool loggingIn = state.matchedLocation == '/feed/restaurant_info';
      if (!loggedIn) {
        return '/auth';
      }
      if (loggingIn) {
        return '/feed/restaurant_info';
      }
      return null;
    },
  );
}

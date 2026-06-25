import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cubby/features/shell/shell_screen.dart';
import 'package:cubby/features/home/home_screen.dart';
import 'package:cubby/features/inbox/inbox_screen.dart';
import 'package:cubby/features/capture/capture_screen.dart';
import 'package:cubby/features/people/people_screen.dart';
import 'package:cubby/features/assistant/assistant_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (context, state) => const InboxScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/capture',
              builder: (context, state) => const CaptureScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/people',
              builder: (context, state) => const PeopleScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ask',
              builder: (context, state) => const AssistantScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

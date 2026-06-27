import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:cubby/features/auth/sign_in_screen.dart';
import 'package:cubby/features/shell/shell_screen.dart';
import 'package:cubby/features/home/home_screen.dart';
import 'package:cubby/features/inbox/inbox_screen.dart';
import 'package:cubby/features/capture/capture_screen.dart';
import 'package:cubby/features/people/people_screen.dart';
import 'package:cubby/features/assistant/assistant_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final loggedIn = FirebaseAuth.instance.currentUser != null;
    final onSignIn = state.matchedLocation == '/sign-in';

    if (!loggedIn && !onSignIn) return '/sign-in';
    if (loggedIn && onSignIn) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
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

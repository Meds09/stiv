import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importa tus páginas
import 'package:stiv/features/onboarding/presentation/onboarding_page.dart';
import 'package:stiv/features/auth/presentation/auth_page.dart';
import 'package:stiv/features/home/presentation/home_page.dart';
import 'package:stiv/features/profile/presentation/profile_page.dart';
import 'package:stiv/features/diagnostic/presentation/diagnostic_page.dart';
import 'package:stiv/shared/widgets/custom_bottom_navigation_bar.dart';

/// Estado del Onboarding (usa SharedPreferences)
class OnboardingState extends ChangeNotifier {
  bool _done = false;
  bool _loaded = false;
  bool get done => _done;
  bool get loaded => _loaded;

  OnboardingState() {
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _done = prefs.getBool('onboarding_done') ?? false;
    _loaded = true;
    notifyListeners();
  }

  Future<void> markDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    _done = true;
    notifyListeners();
  }
}

/// Notificador que combina el estado del onboarding + auth
class RouterNotifier extends ChangeNotifier {
  final OnboardingState onboarding;
  late final StreamSubscription<User?> _authSub;

  RouterNotifier(this.onboarding) {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
    onboarding.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _authSub.cancel();
    onboarding.removeListener(notifyListeners);
    super.dispose();
  }
}

final onboardingState = OnboardingState();
final routerNotifier = RouterNotifier(onboardingState);

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  refreshListenable: routerNotifier,

  routes: [
    // Onboarding
    GoRoute(path: '/onboarding', builder: (_, _) => const OnBoardingPage()),

    // Login (fuera del shell)
    GoRoute(path: '/login', builder: (_, _) => const AuthPage()),

    // Shell persistente con BottomNavigationBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: navigationShell,
          bottomNavigationBar:  CustomBottomNavigationBar(),
        );
      },
      branches: [
        // Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(path: '/home', builder: (_, _) => const HomePage()),
          ],
        ),
        //  Diagnóstico
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/diag', builder: (_, _) => const DiagnosticPage()),
          ],
        ),
        //  Perfil
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfilePage()),
          ],
        ),
      ],
    ),
  ],

  // Redirecciones
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final onboarding = onboardingState;

    if (!onboarding.loaded) return null; // espera a que cargue

    final atOnboarding = state.matchedLocation == '/onboarding';
    final atLogin = state.matchedLocation == '/login';
    // ignore: unused_local_variable
    final inShell =
        state.matchedLocation.startsWith('/home') ||
        state.matchedLocation.startsWith('/diag') ||
        state.matchedLocation.startsWith('/profile');

    //  Onboarding no completado
    if (!onboarding.done) {
      return atOnboarding ? null : '/onboarding';
    }

    // Onboarding hecho pero sin login
    if (onboarding.done && user == null) {
      return atLogin ? null : '/login';
    }

    //  Onboarding hecho + login → entra al shell
    if (onboarding.done && user != null) {
      if (atOnboarding || atLogin) return '/home';
    }

    return null;
  },
);

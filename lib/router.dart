import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importa tus páginas
import 'package:stiv/pages/onboarding_page.dart';
import 'package:stiv/pages/auth_page.dart';
import 'package:stiv/pages/home_page.dart';

/// Estado del Onboarding (usa SharedPreferences)
class OnboardingState extends ChangeNotifier {
  bool _done = false;
  bool _loaded = false;
  bool get done => _done;
  bool get loaded => _loaded;

  OnboardingState() {
    _load();
  }

  Future<void> _load() async {
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

final router = GoRouter(
  initialLocation: '/onboarding',
  refreshListenable: routerNotifier,
  routes: [
    GoRoute(path: '/onboarding', builder: (_, _) => const OnBoardingPage()),
    GoRoute(path: '/login', builder: (_, _) => const AuthPage()),
    GoRoute(path: '/home', builder: (_, _) => const HomePage()),
  ],
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final onboarding = onboardingState;

    // Esperar a que cargue el flag del onboarding
    if (!onboarding.loaded) return null;

    final isAtOnboarding = state.matchedLocation == '/onboarding';
    final isAtLogin = state.matchedLocation == '/login';

    if (!onboarding.done) {
      // Onboarding no completado
      return isAtOnboarding ? null : '/onboarding';
    }

    // Onboarding hecho pero sin login
    if (onboarding.done && user == null) {
      return isAtLogin ? null : '/login';
    }

    // Onboarding hecho y autenticado
    if (onboarding.done && user != null) {
      return isAtOnboarding || isAtLogin ? '/home' : null;
    }

    return null;
  },
);

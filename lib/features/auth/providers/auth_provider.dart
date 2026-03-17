import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/features/auth/providers/bottom_nav_bar_provider.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(
    authStateProvider.select((state) => state.value),
  );
});


final userFirstNameProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  
  if (user == null) return 'Stiver';
  
  final displayName = user.displayName ?? 'Stiver';
  return displayName.split(' ').first;
});


class IsSigningOutNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setSigningOut(bool signingOut) => state = signingOut;
}

final isSigningOutProvider =
    NotifierProvider<IsSigningOutNotifier, bool>(IsSigningOutNotifier.new);


final _authStateListenerProvider = Provider<void>((ref) {
  ref.listen(authStateProvider, (previous, next) {
    next.whenData((user) {
      // Si hay usuario (inició sesión), resetea isSigningOut
      if (user != null) {
        ref.read(isSigningOutProvider.notifier).setSigningOut(false);
      }
    });
  });
});

final authControllerProvider = Provider<AuthController>((ref) {
  // Activa el listener
  ref.watch(_authStateListenerProvider);
  return AuthController(ref);
});

class AuthController {
  final Ref ref;
  
  AuthController(this.ref);
  
  Future<void> signOut() async {
    ref.read(isSigningOutProvider.notifier).setSigningOut(true);
    await Future.delayed(const Duration(milliseconds: 800));
    await FirebaseAuth.instance.signOut();
    ref.read(menuIndexProvider.notifier).setIndex(0);
    
  }
  
  bool get isAuthenticated {
    final user = ref.read(currentUserProvider);
    return user != null;
  }
}
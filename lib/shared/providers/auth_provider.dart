import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, _) => null,
  );
});

final userFirstNameProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  
  if (user == null) return 'Stiver';
  
  final displayName = user.displayName ?? 'Stiver';
  return displayName.split(' ').first;
});


final isSigningOutProvider = StateProvider<bool>((ref) => false);


final _authStateListenerProvider = Provider<void>((ref) {
  ref.listen(authStateProvider, (previous, next) {
    next.whenData((user) {
      // Si hay usuario (inició sesión), resetea isSigningOut
      if (user != null) {
        ref.read(isSigningOutProvider.notifier).state = false;
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
    ref.read(isSigningOutProvider.notifier).state = true;
    await Future.delayed(const Duration(milliseconds: 50));
    await FirebaseAuth.instance.signOut();
  }
  
  bool get isAuthenticated {
    final user = ref.read(currentUserProvider);
    return user != null;
  }
}
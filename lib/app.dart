import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stiv/core/theme/theme_data.dart';
import 'core/router/router.dart';
import 'package:stiv/features/guides/providers/guides_providers.dart';

class StivApp extends ConsumerStatefulWidget {
  const StivApp({super.key});

  @override
  ConsumerState<StivApp> createState() => _StivAppState();
}

class _StivAppState extends ConsumerState<StivApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await onboardingState.load();
    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize image preloader
    ref.watch(guidesImagePreloaderProvider);

    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor:  AppColors.primary,
            ),
          
          ),
        ),
        );
      
    }

    return MaterialApp.router(
      title: 'Stiv',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

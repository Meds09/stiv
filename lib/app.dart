import 'package:flutter/material.dart';
import 'package:stiv/shared/theme/theme_data.dart';
import 'router.dart';

class StivApp extends StatefulWidget {
  const StivApp({super.key});

  @override
  State<StivApp> createState() => _StivAppState();
}

class _StivAppState extends State<StivApp> {
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
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

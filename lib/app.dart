import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
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
    final light = FlexThemeData.light(scheme: FlexScheme.deepBlue);
    final dark = FlexThemeData.dark(scheme: FlexScheme.deepBlue);
    if (!_initialized) {
      return MaterialApp(
        theme: light, 
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        ),
        );
      
    }

    return MaterialApp.router(
      title: 'Stiv',
      theme: light,
      darkTheme: dark,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

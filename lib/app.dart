import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'router.dart';


class StivApp extends StatelessWidget {
const StivApp({super.key});
@override
Widget build(BuildContext context) {
final light = FlexThemeData.light(scheme: FlexScheme.deepBlue);
final dark = FlexThemeData.dark(scheme: FlexScheme.deepBlue);
return MaterialApp.router(
title: 'Stiv',
theme: light,
darkTheme: dark,
debugShowCheckedModeBanner: false,
routerConfig: router,
);
}
}